# PostgreSQL Schema Management with dbmate

A hands-on PostgreSQL project focused on relational database design, version-controlled schema migrations, seed data, indexing, and automated timestamp management using **PostgreSQL** and **dbmate**.

## Overview

This project demonstrates how to structure and manage a relational database using SQL migrations. It includes a project and task management schema with users, profiles, projects, tasks, and project memberships.

## Tech Stack

- **Database:** PostgreSQL
- **Migration Tool:** dbmate
- **Query Editor:** TablePlus
- **Version Control:** Git and GitHub

## Database Schema

The database consists of five main tables:

| Table | Description |
|---|---|
| `users` | Stores user accounts and authentication-related fields |
| `user_profiles` | Stores additional user information, including avatar URLs, bios, and phone numbers |
| `projects` | Stores project details, owners, and statuses |
| `tasks` | Stores tasks associated with projects and assigned users |
| `project_members` | Manages user membership and roles within projects |

### Enums

The schema uses PostgreSQL ENUM types to represent predefined values:

- `project_status`: `active`, `completed`, `archived`
- `task_status`: `pending`, `in_progress`, `completed`, `cancelled`
- `member_role`: `owner`, `admin`, `member`

## Features

### 1. Database Migrations

Uses dbmate to version-control database changes and maintain a migration history.

### 2. Seed Data

Includes sample data for development and testing across users, profiles, projects, tasks, and memberships.

### 3. Indexing and Query Performance

Uses indexes to support common filtering, sorting, and join operations, including:

- User email lookups
- Project ownership queries
- Task filtering by project, assignee, and status
- Sorting by creation timestamps
- Project membership lookups

Query plans can be inspected with PostgreSQL's `EXPLAIN ANALYZE`.

### 4. Automatic Timestamp Updates

Uses a reusable PL/pgSQL trigger function to update `updated_at` automatically when records change.

### 5. Relational Integrity

Uses primary keys, foreign keys, unique constraints, and deletion rules to maintain consistent relationships between tables.

## Project Structure

```text
postgresql-schema-dbmate/
├── db/
│   ├── migrations/
│   │   ├── *_create_users_table.sql
│   │   ├── *_seed_data.sql
│   │   └── *_trigger_indexes.sql
│   └── schema.sql
└── README.md
```

*Migration filenames may differ depending on your actual repository.*

## Getting Started

### Prerequisites

- PostgreSQL
- dbmate
- Git

### 1. Clone the repository

```bash
git clone https://github.com/Kratik00/postgresql-schema-dbmate/
cd postgresql-schema-dbmate
```

### 2. Configure the database connection

Set the `DATABASE_URL` environment variable:

```bash
export DATABASE_URL="postgresql://username:password@localhost:5432/pg_lab?sslmode=disable"
```

Replace the username, password, and database name with your local configuration.

### 3. Apply migrations

```bash
dbmate up
```

### 4. Check migration status

```bash
dbmate status
```

### 5. Inspect the generated schema

```bash
cat db/schema.sql
```

## Example Queries

### Retrieve tasks for a project

```sql
SELECT *
FROM tasks
WHERE project_id = 'your-project-uuid';
```

### Find the latest users

```sql
SELECT id, email, created_at
FROM users
ORDER BY created_at DESC
LIMIT 10;
```

### Inspect query performance

```sql
EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE status = 'completed';
```

## Learning Outcomes

Through this project, I am practising:

- Relational database design and normalization
- PostgreSQL data types and constraints
- Schema versioning with dbmate
- Reversible SQL migrations
- Index design and query-plan analysis
- PL/pgSQL functions and triggers
- Referential integrity and cascading behavior
- Git-based database project management

## Future Improvements

- Add composite and covering indexes where query patterns justify them.
- Explore transactions and isolation levels.
- Practise CTEs and window functions.
- Benchmark queries using larger datasets.
- Add automated migration checks and database tests.

## Author

**Kratik**

B.Tech Computer Science and Engineering

[GitHub Profile](https://github.com/Kratik00)

---

*This project is part of my hands-on learning journey with PostgreSQL and backend development.*
