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
ALTER TABLE private.users OWNER TO app_admin;
GRANT ALL PRIVILEGES ON private.users TO app_user;

-- Channels table private channels
CREATE TABLE private.channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    is_private BOOLEAN DEFAULT FALSE,
    user_id UUID REFERENCES private.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
ALTER TABLE private.channels OWNER TO app_admin;
GRANT ALL PRIVILEGES ON private.channels TO app_user;


CREATE TYPE channel_members_role AS ENUM ('owner', 'moderator', 'member');

-- Channel Members (for private channels and user participation)
CREATE TABLE private.channel_members (
    channel_id UUID REFERENCES private.channels(id),
    user_id UUID REFERENCES private.users(id),
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    role channel_members_role DEFAULT 'member',
    PRIMARY KEY (channel_id, user_id)
);
ALTER TABLE private.channel_members OWNER TO app_admin;
GRANT ALL PRIVILEGES ON private.channel_members TO app_user;

CREATE TYPE message_type AS ENUM ('system', 'user');

-- Messages table
CREATE TABLE private.messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id UUID REFERENCES private.channels(id),
    user_id UUID REFERENCES private.users(id),
    body TEXT NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    message_type message_type NOT NULL DEFAULT 'user',
    reply_to UUID REFERENCES private.messages(id),
    read_by UUID[] DEFAULT ARRAY[]::UUID[]
);
ALTER TABLE private.messages OWNER TO app_admin;
GRANT ALL PRIVILEGES ON private.messages TO app_user; 

