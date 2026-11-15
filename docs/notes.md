# Technical Notes

## 1. Biggest Docker problem and how I solved it

**Problem:** `docker compose up --build -d` kept failing while Docker was downloading images from Docker Hub. The error changed between attempts:

- `lookup registry-1.docker.io: no such host` (Docker could not resolve Docker Hub)
- `connectex: A connection attempt failed ...` (timeout while loading the metadata of `php:8.3-apache`)
- `short read: expected 15434095 bytes but got 1912248: unexpected EOF` (the connection dropped in the middle of pulling `mysql:8.0`)

**Cause:** an unstable internet connection, not a mistake in my Dockerfile or Compose file. The same Dockerfile had already built successfully before.

**Solution:** I read the error messages carefully and recognized that they were network errors, not configuration errors. I retried the download until it completed. Docker keeps the layers that were already downloaded, so every retry resumes from where it stopped. After `mysql:8.0` was fully pulled, `docker compose up --build -d` worked and both containers started (the database became `healthy`).

**Lesson:** distinguish network errors from configuration errors, and pull large base images separately (`docker pull mysql:8.0`) when the connection is weak.

## 2. Other Docker problems solved by design

| Problem | Solution |
| --- | --- |
| `Class "mysqli" not found` in a plain PHP image | The Dockerfile installs the extension with `docker-php-ext-install mysqli` |
| The app cannot connect to `localhost` inside a container | `db.php` reads `DB_HOST` from environment variables and Compose sets it to `db`, the service name |
| PHP starts before MySQL is ready | A MySQL healthcheck plus `depends_on: condition: service_healthy` |
| Image upload fails because of file permissions | `chown www-data` on the `uploads` folder in the Dockerfile |
| Data lost when containers are recreated | Named volumes `db_data` and `uploads_data` |
| `init.sql` does not run again | It only runs when the database volume is empty; use `docker compose down -v` to re-initialize |

## 3. Most important Git/GitHub lesson

Decide what must never enter the repository **before** the first commit. User-uploaded images are runtime data, not source code, so I excluded them with `.gitignore` and kept the empty folder with a `.gitkeep` file. I checked the result with `git ls-files` before pushing. I also learned that small commits with clear prefixes (`feat:`, `docker:`, `docs:`, `chore:`) make the history easy to read and easy to review.

## 4. Known limitations and future improvements

- Uploaded files keep their original names and are not validated; they should be type- and size-checked and renamed randomly.
- Timestamps are shown in UTC because the container timezone is UTC.
- `view_news.php` expects a default image at `uploads/default.png` for articles without a picture.
- The default database passwords in `docker-compose.yml` are for local development only; use a `.env` file for any real deployment.
