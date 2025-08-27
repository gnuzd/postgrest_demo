-- 0005_auth_functions.sql

-- Install pgcrypto for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Function to register a new user in the private.users table
CREATE FUNCTION public.register(email TEXT, password TEXT) RETURNS private.users AS $$
DECLARE
    usr private.users;
BEGIN
    INSERT INTO private.users (email, password_hash)
    VALUES (email, crypt(password, gen_salt('bf')))
    RETURNING * INTO usr;
    RETURN usr;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to authenticate a user and return a JWT
CREATE FUNCTION public.login(email TEXT, password TEXT) RETURNS text AS $$
DECLARE
    _user private.users;
    _jwt_secret text := 'gRhaJ99BB3EhcjpwI1WTA7pLywa+J25X'; -- Your JWT secret from docker-compose.yml
BEGIN
    SELECT id, email INTO _user FROM private.users WHERE users.email = public.authenticate.email;

    IF _user.password_hash = crypt(password, _user.password_hash) THEN
        -- Generate JWT for app_user role
        RETURN pgjwt.sign(
            json_build_object(
                'role', 'app_user',
                'user_id', _user.id,
                'exp', extract(epoch FROM now())::integer + 60*60*24 -- 24 hours expiration
            ),
            _jwt_secret
        );
    ELSE
        RETURN NULL; -- Authentication failed
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execution to authenticator role
GRANT EXECUTE ON FUNCTION public.register_user(TEXT, TEXT) TO authenticator;
GRANT EXECUTE ON FUNCTION public.authenticate(TEXT, TEXT) TO authenticator;
