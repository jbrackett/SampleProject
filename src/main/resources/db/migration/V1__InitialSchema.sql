CREATE TABLE public.todo (
    id uuid PRIMARY KEY,
    message VARCHAR(255) NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE
);