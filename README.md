# NewsPulse-Portal

A PHP & MySQL news management system, fully containerized with Docker. Registered users can create categories and news articles, upload images, edit articles, soft-delete and restore them, and print their news list.

## Tech Stack
- PHP 8.3 (Apache) with the `mysqli` extension
- MySQL 8.0
- Bootstrap 5 and Font Awesome (loaded from CDN)
- Docker and Docker Compose
- Git and GitHub

## Features
- User registration, login and logout (passwords hashed with bcrypt)
- Create and list categories
- Create, edit, list and print news articles
- Image upload for articles
- Soft delete and restore of articles
- Dashboard with light/dark theme

## Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (includes Docker Compose)
- Git

## Run with Docker (quick start)

1. Clone the repository:
   ```bash
   git clone https://github.com/maramokasha/NewsPulse-Portal.git
   cd NewsPulse-Portal
   ```
2. Build and start the containers:
   ```bash
   docker compose up --build -d
   ```
3. Check that both services are running (the database should be `healthy`):
   ```bash
   docker compose ps
   ```
4. Open the application: **http://localhost:8080**

The first start downloads the base images, so it can take a few minutes.

## Stop and clean up

| Goal | Command |
| --- | --- |
| Stop the containers (keep data) | `docker compose stop` |
| Start them again | `docker compose start` |
| Remove containers and network (keep data) | `docker compose down` |
| Remove everything including the database and uploaded images | `docker compose down -v` |

## Configuration

| Item | Value |
| --- | --- |
| Application URL | http://localhost:8080 (host port 8080 maps to container port 80) |
| Database | MySQL 8.0, available only inside the Docker network (host name `db`) |
| Environment variables | `DB_HOST`, `DB_USER`, `DB_PASS`, `DB_NAME`, `DB_ROOT_PASS` |

Default values work out of the box. To change them, copy `.env.example` to `.env` and edit it:
```bash
cp .env.example .env
```
To use another host port, change `"8080:80"` in `docker-compose.yml`.

Data persistence: the database is stored in the `db_data` volume and uploaded images in the `uploads_data` volume, so data survives container restarts.

The database schema in `db/init.sql` runs only the first time the database volume is created. To re-initialize it, run `docker compose down -v` and start again.

## How to test
1. Open http://localhost:8080 (it redirects to the login page).
2. Click **Register** and create a new account, then log in.
3. Add a category, then add a news article with an image.
4. Open **View News**: the article and its image appear.
5. Edit the article, delete it, then restore it from **Deleted News**.
6. Use the print page to print your news list.
7. Run `docker compose restart` and refresh: the data is still there.

## Project Structure
```text
NewsPulse-Portal/
|-- src/                  # PHP application source code
|   |-- categories/
|   |-- news/
|   |-- uploads/          # runtime uploads (not tracked by Git)
|   |-- dashboard.php, db.php, index.php
|   |-- login.php, logout.php, register.php
|-- db/init.sql           # database schema and sample data
|-- docs/
|   |-- screenshots/      # assignment screenshots
|   |-- notes.md          # technical notes
|-- Dockerfile
|-- docker-compose.yml
|-- .dockerignore
|-- .gitignore
|-- .env.example
|-- README.md
```

## Troubleshooting
- **Port 8080 is already in use:** change the host port in `docker-compose.yml`.
- **XAMPP is running:** stop Apache and MySQL in XAMPP to avoid port conflicts.
- **Image download fails with a network error:** run `docker pull mysql:8.0` again until it completes, then rerun `docker compose up --build -d`.

## Attribution
This is an original university coursework project by Maram Okasha. It was first developed as `assignment4/news_system` in the repository `maramokasha/NewsPulse-API` and is containerized and published here as a standalone project. No third-party open-source application code is included. Bootstrap and Font Awesome are loaded from public CDNs under their own licenses.
