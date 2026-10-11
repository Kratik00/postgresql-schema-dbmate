-- migrate:up
WITH inserted_users AS (
    INSERT INTO users (email, full_name, password_hash) VALUES
        ('john@example.com', 'John Doe', 'hash1'),
        ('jane@example.com', 'Jane Matthew', 'hash2'),
        ('bob@example.com', 'Bob Smith', 'hash3'),
        ('alice@example.com', 'Alice Wilson', 'hash4')
    RETURNING id, email
),

inserted_profiles AS (
    INSERT INTO user_profiles (user_id, avatar_url, bio, phone)
    SELECT 
        id,
        'https://example.com/avatar' || row_number() OVER () || '.jpg',
        CASE 
            WHEN email LIKE 'john%' THEN 'Project Manager with 5 year experience'
            WHEN email LIKE 'jane%' THEN 'Senior Developer'
            WHEN email LIKE 'bob%' THEN 'UX Designer'
            ELSE 'Business Analyst'
        END,
        '+123456789' || row_number() OVER ()
    FROM inserted_users
),

inserted_projects AS (
    INSERT INTO projects (name, description, status, owner_id)
    SELECT 
        unnest(ARRAY[
            'Website Redesign',
            'Mobile App Development',
            'Database Migration'
        ]),
        unnest(ARRAY[
            'Complete overhaul of company Website',
            'New App for costumers',
            'Migrate legacy database to new system'
        ]),
        unnest(ARRAY[
            'active'::project_status,
            'active'::project_status,
            'active'::project_status
        ]),
        (SELECT id FROM inserted_users WHERE email = 'john@example.com')
    RETURNING id, name

),

-- Seed tasks
inserted_tasks AS (
    INSERT INTO tasks (
        project_id, title, description, priority,
        status, due_date, assigned_to
    )
    SELECT
        p.id, t.title, t.description, t.priority,
        t.status, t.due_date, u.id
    FROM (
        SELECT
            'Website Redesign' AS project_name,
            'Design Homepage' AS title,
            'Create new homepage design' AS description,
            1 AS priority,
            'pending'::task_status AS status,
            '2024-04-01'::date AS due_date,
            'bob@example.com' AS assignee

        UNION ALL

        SELECT 'Website Redesign', 'Implement Frontend',
               'Frontend development of new design', 2,
               'in_progress'::task_status, '2024-04-15'::date,
               'jane@example.com'

        UNION ALL

        SELECT 'Mobile App Development', 'API Development',
               'Create REST API for mobile app', 1,
               'pending'::task_status, '2024-04-10'::date,
               'jane@example.com'

        UNION ALL

        SELECT 'Mobile App Development', 'User Authentication',
               'Implement user auth system', 1,
               'pending'::task_status, '2024-04-05'::date,
               'jane@example.com'

        UNION ALL

        SELECT 'Database Migration', 'Data Analysis',
               'Analyze current database structure', 2,
               'completed'::task_status, '2024-03-25'::date,
               'alice@example.com'

        UNION ALL

        SELECT 'Database Migration', 'Migration Script',
               'Write data migration scripts', 1,
               'in_progress'::task_status, '2024-04-20'::date,
               'jane@example.com'
    ) AS t
    JOIN inserted_projects p ON p.name = t.project_name
    JOIN inserted_users u ON u.email = t.assignee
    RETURNING id
),
-- Seed project_members
inserted_members AS (
    INSERT INTO project_members (project_id, user_id, role)
    SELECT
        p.id,
        u.id,
        m.role::member_role
    FROM (
        SELECT
            'Website Redesign' AS project_name,
            'john@example.com' AS user_email,
            'owner' AS role

        UNION ALL

        SELECT 'Website Redesign', 'jane@example.com', 'member'

        UNION ALL

        SELECT 'Website Redesign', 'bob@example.com', 'member'

        UNION ALL

        SELECT 'Mobile App Development', 'jane@example.com', 'owner'

        UNION ALL

        SELECT 'Mobile App Development', 'bob@example.com', 'admin'

        UNION ALL

        SELECT 'Mobile App Development', 'alice@example.com', 'member'

        UNION ALL

        SELECT 'Database Migration', 'john@example.com', 'owner'

        UNION ALL

        SELECT 'Database Migration', 'jane@example.com', 'member'

        UNION ALL

        SELECT 'Database Migration', 'alice@example.com', 'admin'
    ) AS m
    JOIN inserted_projects p ON p.name = m.project_name
    JOIN inserted_users u ON u.email = m.user_email
    RETURNING id
)
SELECT
    (SELECT COUNT(*) FROM inserted_users) AS users_inserted,
    (SELECT COUNT(*) FROM inserted_projects) AS projects_inserted,
    (SELECT COUNT(*) FROM inserted_tasks) AS tasks_inserted,
    (SELECT COUNT(*) FROM inserted_members) AS members_inserted;

-- migrate:down

TRUNCATE TABLE project_members CASCADE;
TRUNCATE TABLE tasks CASCADE;
TRUNCATE TABLE projects CASCADE;
TRUNCATE TABLE user_profiles CASCADE;
TRUNCATE TABLE users CASCADE;