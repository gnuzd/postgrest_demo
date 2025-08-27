
-- 0004_private_chat_rls.sql

-- Functions for RLS and authentication (placeholder - will be more complex with actual JWT)
CREATE FUNCTION private.current_user_id() RETURNS UUID LANGUAGE plpgsql AS $$
  BEGIN
    RETURN (current_setting('request.jwt.claim.user_id', true)::UUID);
  END;
$$;

-- RLS for private.users (users can see their own info)
ALTER TABLE private.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_own_user ON private.users FOR SELECT USING (id = private.current_user_id());

-- RLS for private.channels (users can see public channels and channels they are a member of)
ALTER TABLE private.channels ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_public_channels ON private.channels FOR SELECT USING (is_private IS FALSE);
CREATE POLICY select_member_channels ON private.channels FOR SELECT USING (EXISTS (SELECT 1 FROM private.channel_members WHERE channel_id = id AND user_id = private.current_user_id()));
CREATE POLICY insert_channel_by_user ON private.channels FOR INSERT WITH CHECK (created_by = private.current_user_id());


-- RLS for private.channel_members (users can see their own memberships)
ALTER TABLE private.channel_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_own_memberships ON private.channel_members FOR SELECT USING (user_id = private.current_user_id());
CREATE POLICY insert_own_membership ON private.channel_members FOR INSERT WITH CHECK (user_id = private.current_user_id());


-- RLS for private.messages (users can see messages in channels they are members of)
ALTER TABLE private.messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_messages_in_channel ON private.messages FOR SELECT USING (EXISTS (SELECT 1 FROM private.channel_members WHERE channel_id = private.messages.channel_id AND user_id = private.current_user_id()));
CREATE POLICY insert_message_in_channel ON private.messages FOR INSERT WITH CHECK (user_id = private.current_user_id() AND EXISTS (SELECT 1 FROM private.channel_members WHERE channel_id = private.messages.channel_id AND user_id = private.current_user_id()));
