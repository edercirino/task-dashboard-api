# Task Dashboard API 🧠

A secure and scalable **User Management API** built with **Ruby on Rails**.  
This backend serves as the foundation for the Task Dashboard frontend, providing **JWT authentication**, **role-based access (admin/user)**, and full **CRUD** operations for users.

**This back-end application belongs to this [front-end project](https://github.com/edercirino/task-dashboard)**

## Table of Contents 📚

- [Features 🚀](#features-)
- [Tech Stack 💻](#tech-stack-)
- [Getting Started 🛠](#getting-started-)
- [Usage ⚙️](#usage-)
- [Authentication 🔐](#authentication-)
- [Master Admin 👑](#master-admin-)
- [Author 👤](#author-)

## Features 🚀

- JWT-based authentication 🔐
- Role-based authorization using Pundit 🧑‍⚖️
- Admin can:
  - Create, update and delete users 👥
  - View all users
- Users can:
  - View and update their own profiles
- Master Admin cannot be deleted or edited by others 👑
- CORS enabled for cross-origin requests from the frontend

## Tech Stack 💻

<span href="tech-stack"></span>

- **Ruby on Rails 7** – API mode
- **PostgreSQL** – Relational database
- **JWT** – Authentication tokens
- **Pundit** – Authorization layer
- **Rack::CORS** – CORS handling
- **BCrypt** – Password hashing

## Getting Started 🛠

<span href="getting-started"></span>

1. Clone the repository:

   ```
   git clone https://github.com/your-username/task-dashboard-api.git
   cd task-dashboard-api
   ```

2. Install dependencies:

```
   bundle install
```

3. Set up the database:

```
   rails db:create db:migrate db:seed

```

4. Run the server:

```
   rails s
```

5. API will be available at `http://localhost:3000/api/v1`

## Usage ⚙️

<span href="usage"></span>

**Endpoints Overview**

| Method | Endpoint          | Description                         |
| ------ | ----------------- | ----------------------------------- |
| POST   | /api/v1/login     | Authenticate and return token       |
| GET    | api/v1/users      | List all users (admin only)         |
| POST   | /api/v1/users     | Create a new user (admin only)      |
| GET    | /api/v1/users/:id | Get a specific user (admin or self) |
| PATCH  | /api/v1/users/:id | Update user info (admin or self)    |
| DELETE | /api/v1/users/:id | Delete user (admin only)            |

<span href="authentication"></span>

## Authentication 🔐

Use the `/api/v1/login` endpoint to receive a JWT token.
Include the token in every protected request:
`Authorization: Bearer your_jwt_token
`
<span href="master-admin"><span>

## Master Admin 👑

This user is automatically created via seed and has special protection, This user
authentication can be defined before deploy.

Rules:

- Cannot be deleted
- Cannot be updated by other users
- Only the master admin can change their own password

<a href="https://www.linkedin.com/in/edercirino/">
<img style="border-radius: 50%;" src="https://avatars3.githubusercontent.com/u/25642656" width="100px" alt=""/>
<br />

<span href="author"></span>

<sub><b>Éder Cirino</b></sub></a>

Made with ❤️ for Éder Cirino 👋 Get in touch

[![Linkedin Badge](https://img.shields.io/badge/-Éder-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/edercirino/)](https://www.linkedin.com/in/edercirino/)
