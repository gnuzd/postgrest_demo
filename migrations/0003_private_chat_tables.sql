-- 0003_private_chat_tables.sql

-- Tables for private schema (chat features)

-- Users table
CREATE TABLE private.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    display_name TEXT,
    image TEXT,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- ALTER TABLE private.users OWNER TO app_user;
GRANT ALL PRIVILEGES ON private.users TO app_user; -- Not needed as app_user is owner
GRANT ALL PRIVILEGES ON private.users TO app_admin; -- Not needed as app_user is owner

-- Channels table private channels
CREATE TABLE private.channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    is_private BOOLEAN DEFAULT FALSE,
    user_id UUID REFERENCES private.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- ALTER TABLE private.channels OWNER TO app_user;
GRANT ALL PRIVILEGES ON private.channels TO app_user; -- Not needed as app_user is owner
GRANT ALL PRIVILEGES ON private.channels TO app_admin; -- Not needed as app_user is owner


CREATE TYPE channel_members_role AS ENUM ('owner', 'moderator', 'member');

-- Channel Members (for private channels and user participation)
CREATE TABLE private.channel_members (
    channel_id UUID REFERENCES private.channels(id),
    user_id UUID REFERENCES private.users(id),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    role channel_members_role DEFAULT 'member',
    PRIMARY KEY (channel_id, user_id)
);
-- ALTER TABLE private.channel_members OWNER TO app_user;
GRANT ALL PRIVILEGES ON private.channel_members TO app_user; -- Not needed as app_user is owner
GRANT ALL PRIVILEGES ON private.channel_members TO app_admin; -- Not needed as app_user is owner

CREATE TYPE message_type AS ENUM ('system', 'user');

-- Messages table
CREATE TABLE private.messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id UUID REFERENCES private.channels(id),
    user_id UUID REFERENCES private.users(id),
    content TEXT NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    message_type message_type NOT NULL DEFAULT 'user',
    reply_to UUID REFERENCES private.messages(id)
);
-- ALTER TABLE private.messages OWNER TO app_user;
GRANT ALL PRIVILEGES ON private.messages TO app_user; -- Not needed as app_user is owner
GRANT ALL PRIVILEGES ON private.messages TO app_admin; -- Not needed as app_user is owner

