-- 0004_private_chat_rls.sql

-- Functions for RLS and authentication (placeholder - will be more complex with actual JWT)
CREATE FUNCTION private.current_user_id() RETURNS UUID LANGUAGE plpgsql AS $$
  BEGIN
    RETURN (current_setting('request.jwt.claims', true)::json->>'user_id');
  END;
$$;


-- Admin bypass policies for various tables
CREATE POLICY admin_bypass_policy ON private.users
FOR ALL TO app_admin
USING (true);

CREATE POLICY admin_bypass_policy ON private.channels
FOR ALL TO app_admin
USING (true);

CREATE POLICY admin_bypass_policy ON private.channel_members
FOR ALL TO app_admin
USING (true);

CREATE POLICY admin_bypass_policy ON private.messages
FOR ALL TO app_admin
USING (true);


-- RLS for private.users (users can see their own info)
ALTER TABLE private.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_own_user ON private.users
FOR ALL
USING (id = private.current_user_id());


-- RLS for private.channels (users can see public channels and channels they are a member of)
ALTER TABLE private.channels ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_public_channels ON private.channels
FOR SELECT
USING (is_private IS FALSE);

CREATE POLICY select_member_channels ON private.channels
FOR SELECT
USING (
    EXISTS (SELECT 1 FROM private.channel_members WHERE channel_id = id AND user_id = private.current_user_id())
);

CREATE POLICY insert_channel_by_user ON private.channels
FOR INSERT
WITH CHECK (user_id = private.current_user_id());


-- RLS for private.channel_members (users can see their own memberships)
ALTER TABLE private.channel_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_own_memberships ON private.channel_members
FOR SELECT
USING (user_id = private.current_user_id());

CREATE POLICY insert_own_membership ON private.channel_members
FOR INSERT
WITH CHECK (user_id = private.current_user_id());


-- RLS for private.messages (users can see messages in channels they are members of)
ALTER TABLE private.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY select_messages_in_channel ON private.messages
FOR SELECT
USING (
    EXISTS (SELECT 1 FROM private.channels WHERE id = private.messages.channel_id AND is_private = FALSE)
    OR EXISTS (SELECT 1 FROM private.channel_members WHERE channel_id = private.messages.channel_id AND user_id = private.current_user_id())
);

CREATE POLICY insert_message_in_channel ON private.messages
FOR INSERT
WITH CHECK (
    (message_type = 'system' AND EXISTS (SELECT 1 FROM private.channel_members WHERE channel_id = private.messages.channel_id AND user_id = private.current_user_id() AND (role = 'owner' OR role = 'moderator')))
    OR (user_id = private.current_user_id() AND (
        EXISTS (SELECT 1 FROM private.channels WHERE id = private.messages.channel_id AND is_private = FALSE)
        OR EXISTS (SELECT 1 FROM private.channel_members WHERE channel_id = private.messages.channel_id AND user_id = private.current_user_id())))
);


-- Create a function to set the user ID for new records
CREATE OR REPLACE FUNCTION set_user_id() RETURNS TRIGGER AS $$
BEGIN
  NEW.user_id := private.current_user_id();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Triggers to automatically set user_id on insert
CREATE TRIGGER set_channels_created_by_trigger
BEFORE INSERT ON private.channels
FOR EACH ROW
EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_channel_members_created_by_trigger
BEFORE INSERT ON private.channel_members
FOR EACH ROW
EXECUTE FUNCTION set_user_id();

CREATE TRIGGER set_messages_created_by_trigger
BEFORE INSERT ON private.messages
FOR EACH ROW
EXECUTE FUNCTION set_user_id();


-- Function and trigger to automatically add the channel owner to members
CREATE OR REPLACE FUNCTION add_channel_owner_to_members()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO private.channel_members (channel_id, user_id, role)
  VALUES (NEW.id, NEW.user_id, 'owner');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_owner_trigger
AFTER INSERT ON private.channels
FOR EACH ROW
EXECUTE FUNCTION add_channel_owner_to_members();


-- Function and trigger to add a user as a member on their first message to a channel
CREATE OR REPLACE FUNCTION add_member_on_first_message()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM private.channel_members
    WHERE channel_id = NEW.channel_id AND user_id = NEW.user_id
  ) THEN
    INSERT INTO private.channel_members (channel_id, user_id, role)
    VALUES (NEW.channel_id, NEW.user_id, 'member');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_member_on_message_trigger
AFTER INSERT ON private.messages
FOR EACH ROW
EXECUTE FUNCTION add_member_on_first_message();
