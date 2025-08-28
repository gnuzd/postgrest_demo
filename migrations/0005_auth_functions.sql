-- 0005_auth_functions.sql

-- Install pgcrypto for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to register a new user in the private.users table
CREATE FUNCTION public.register(email TEXT, password TEXT) RETURNS jsonb AS $$
DECLARE
    usr private.users;
    _jwt_secret text := 'gRhaJ99BB3EhcjpwI1WTA7pLywa+J25X';
BEGIN
    INSERT INTO private.users (email, password_hash)
    VALUES (email, crypt(password, gen_salt('bf')))
    RETURNING * INTO usr;

    RETURN json_build_object(
        'token', sign(
            json_build_object(
                'role', 'app_user',
                'user_id', usr.id,
                'exp', extract(epoch FROM now())::integer + 60*60*24 -- 24 hours expiration
            ),
            _jwt_secret
        ),
        'user', json_build_object(
            'id', usr.id,
            'email', usr.email
        )
    );

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to authenticate a user and return a JWT
CREATE FUNCTION public.login(p_email TEXT, password TEXT) RETURNS jsonb AS $$
DECLARE
    _user private.users;
    _jwt_secret text := 'gRhaJ99BB3EhcjpwI1WTA7pLywa+J25X'; -- Your JWT secret from docker-compose.yml
BEGIN
    SELECT * INTO _user FROM private.users au WHERE au.email = p_email;

    IF _user.password_hash = crypt(password, _user.password_hash) THEN
        -- Generate JWT for app_user role
      RETURN json_build_object(
        'token', sign(
            json_build_object(
                'role', 'app_user',
                'user_id', _user.id,
                'exp', extract(epoch FROM now())::integer + 60*60*24 -- 24 hours expiration
            ),
            _jwt_secret
        ),
        'user', json_build_object(
            'id', _user.id,
            'email', _user.email
        )
      );
    ELSE
        RETURN NULL; -- Authentication failed
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

REATE OR REPLACE FUNCTION check_user() RETURNS void AS $$
DECLARE
  email text := current_setting('request.jwt.claims', true)::json->>'email';
BEGIN
  IF email = 'evil.user@malicious.com' THEN
    RAISE EXCEPTION 'No, you are evil'
      USING HINT = 'Stop being so evil and maybe you can log in';
  END IF;
END
$$ LANGUAGE plpgsql;

-- Grant execution to authenticator role
GRANT EXECUTE ON FUNCTION public.register(TEXT, TEXT) TO authenticator;
GRANT EXECUTE ON FUNCTION public.login(TEXT, TEXT) TO authenticator;
