-- DROP DATABASE IF EXISTS app_db;
-- CREATE DATABASE app_db;

-- Create a role for PostgREST
CREATE ROLE authenticator NOINHERIT CREATEDB LOGIN PASSWORD 'password';
CREATE ROLE web_anon NOLOGIN;
GRANT web_anon TO authenticator;

-- Create a user for the application
CREATE ROLE app_user LOGIN PASSWORD 'password';
GRANT app_user TO authenticator;

CREATE ROLE app_admin;
GRANT app_admin TO authenticator;

-- Set up the public schema
CREATE SCHEMA IF NOT EXISTS public;
GRANT USAGE ON SCHEMA public TO web_anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO web_anon;

-- Set up the private schema
CREATE SCHEMA IF NOT EXISTS private;
GRANT USAGE ON SCHEMA private TO app_user;
GRANT USAGE ON SCHEMA private TO app_admin;

-- Grant privileges to authenticator
GRANT USAGE ON SCHEMA public TO authenticator;
GRANT USAGE ON SCHEMA private TO authenticator;

GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticator;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO authenticator;

GRANT ALL ON ALL TABLES IN SCHEMA private TO authenticator;
GRANT ALL ON ALL SEQUENCES IN SCHEMA private TO authenticator;

-- Create an event trigger function
CREATE OR REPLACE FUNCTION pgrst_watch() RETURNS event_trigger
  LANGUAGE plpgsql
  AS $$
BEGIN
  NOTIFY pgrst, 'reload schema';
END;
$$;

-- This event trigger will fire after every ddl_command_end event
CREATE EVENT TRIGGER pgrst_watch ON ddl_command_end EXECUTE PROCEDURE pgrst_watch();

