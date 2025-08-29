-- 0005_auth_functions.sql

-- Function to register a new user in the private.users table
CREATE FUNCTION public.register(email TEXT, password TEXT) RETURNS jsonb AS $$
DECLARE
    _user private.users;
    _jwt_secret text := 'gRhaJ99BB3EhcjpwI1WTA7pLywa+J25X';
BEGIN
    INSERT INTO private.users (email, password_hash)
    VALUES (email, crypt(password, gen_salt('bf')))
    RETURNING * INTO _user;

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

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to authenticate a user and return a JWT
CREATE FUNCTION public.login(p_email TEXT, password TEXT) RETURNS jsonb AS $$
DECLARE
    _user private.users;
    _user_role TEXT;
    _jwt_secret text := 'gRhaJ99BB3EhcjpwI1WTA7pLywa+J25X'; -- Your JWT secret from docker-compose.yml
BEGIN
    SELECT * INTO _user FROM private.users au WHERE au.email = p_email;

    IF _user.password_hash = crypt(password, _user.password_hash) THEN
      -- Determine the role based on the is_admin column
      IF _user.is_admin THEN
          _user_role := 'app_admin';
      ELSE
          _user_role := 'app_user';
      END IF;

      -- Generate JWT for app_user role
      RETURN json_build_object(
        'token', sign(
            json_build_object(
                'role', _user_role,
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

-- Grant execution to authenticator role
GRANT EXECUTE ON FUNCTION public.register(TEXT, TEXT) TO authenticator;
GRANT EXECUTE ON FUNCTION public.login(TEXT, TEXT) TO authenticator;
