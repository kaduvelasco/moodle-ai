# Moodle Development Rules

## Coding Standards

Follow Moodle coding style.

Important rules:

- Use Moodle APIs whenever possible
- Avoid direct SQL when Moodle DB API exists
- Follow capability system

## Security

Always use:

require_login()

Validate parameters using:

required_param()
optional_param()

## Database

Database tables must be defined in:

db/install.xml
