# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rails 8.0.3 application using Ruby 3.3.6, PostgreSQL, and Tailwind CSS with the modern Rails stack (Hotwire: Turbo + Stimulus). The application follows Rails Omakase conventions with minimal test configuration (test unit disabled).

## Technology Stack

- **Framework**: Rails 8.0.3
- **Ruby Version**: 3.3.6
- **Database**: PostgreSQL
- **Frontend**: Tailwind CSS, Hotwire (Turbo Rails + Stimulus), Importmap for JS
- **Asset Pipeline**: Propshaft
- **Background Jobs**: Solid Queue (in-puma by default)
- **Caching**: Solid Cache
- **WebSockets**: Solid Cable
- **Deployment**: Kamal with Docker + Thruster

## Development Commands

### Starting the Application

**Local development (native):**
```bash
bin/dev                    # Starts Rails server + Tailwind watcher
bin/rails server           # Rails server only
bin/rails tailwindcss:watch # Tailwind watcher only
```

**Docker development:**
```bash
docker-compose up          # Starts app with PostgreSQL
```

### Database Operations

```bash
bin/rails db:create        # Create database
bin/rails db:migrate       # Run migrations
bin/rails db:seed          # Seed database
bin/rails db:reset         # Drop, create, migrate, seed
```

### Code Quality & Security

```bash
bin/rubocop               # Lint code (Rails Omakase style)
bin/rubocop -A            # Auto-fix linting issues
bin/brakeman              # Security vulnerability scan
bin/importmap audit       # JS dependency security scan
```

### Background Jobs

```bash
bin/jobs                  # Run Solid Queue worker (if not in-puma)
```

### Deployment (Kamal)

```bash
bin/kamal setup           # Initial server setup
bin/kamal deploy          # Deploy application
bin/kamal console         # Remote Rails console
bin/kamal shell           # Remote shell
bin/kamal logs            # Tail application logs
bin/kamal dbc             # Remote database console
```

## Architecture Notes

### Background Job System

- **Solid Queue** runs inside Puma process by default (`SOLID_QUEUE_IN_PUMA: true`)
- Recurring jobs configured in `config/recurring.yml`
- When scaling to multiple servers, move job processing to dedicated machines

### Database Schemas

Three separate schemas for Solid* components:
- `db/queue_schema.rb` - Solid Queue schema
- `db/cache_schema.rb` - Solid Cache schema
- `db/cable_schema.rb` - Solid Cable schema

### Disabled Components

- Active Storage (commented out)
- Action Mailbox (commented out)
- Action Text (commented out)
- Test::Unit (disabled via `config.generators.system_tests = nil`)

### Auto-loading

- `lib/` directory auto-loads, excluding: `assets`, `tasks`
- Custom rake tasks go in `lib/tasks/`

## Configuration Files

- `config/deploy.yml` - Kamal deployment configuration
- `config/recurring.yml` - Recurring job schedules (Solid Queue)
- `config/queue.yml` - Queue configuration
- `config/cache.yml` - Cache configuration
- `config/cable.yml` - Cable configuration
- `Procfile.dev` - Development process management
- `.rubocop.yml` - Minimal config (uses rails-omakase defaults)

## CI/CD Pipeline

GitHub Actions runs three checks:
1. **scan_ruby** - Brakeman security scan
2. **scan_js** - Importmap dependency audit
3. **lint** - RuboCop style check

## Docker Notes

- Multi-stage Dockerfile optimized for production
- Development uses `docker-compose.yml` with PostgreSQL 15
- Production deployment via Kamal with amd64 architecture
- Asset fingerprinting bridged between versions during deployment