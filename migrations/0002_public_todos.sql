
-- 0002_public_todos.sql

-- Table for public schema (todos)
CREATE TABLE public.todos (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    completed BOOLEAN DEFAULT FALSE
);
ALTER TABLE public.todos OWNER TO app_user;
GRANT ALL PRIVILEGES ON public.todos TO app_user;
GRANT USAGE, SELECT ON SEQUENCE public.todos_id_seq TO app_user;
