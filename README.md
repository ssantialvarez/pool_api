# Pool API

This API is an 8-Ball Pool Match & Tournament Manager using Ruby on Rails. It allows users to:
  
  1.​ Manage players: create, read, update, and delete players.
  
  2.​ Schedule matches: create, read, update, and delete matches.
  
  3.​ Prevent double-bookings (two matches overlapping in time for the same player).
  
  4.​ Optionally handle tournaments or leagues (e.g., track wins/losses, update rankings).
  
  5.​ Handle user profile pictures using Amazon S3 pre-signed URLs.
  
  6.​ Use Auth0 for authentication: Users must log in/register via Auth0. Users are also players in the system.

## Ruby version
• ruby 3.4.2 (2025-02-15 revision d2930f8e7a) +PRISM [x86_64-linux]

## Development Environment
This project is configured to run in a Dev Container, which includes all necessary dependencies and services pre-configured. No manual setup is required—just open in a compatible environment such as GitHub Codespaces or VS Code with the Dev Containers extension.

## Getting Started
### Prerequisites
  • Docker
  
  • Visual Studio Code
  
  • Dev Containers Extension

## Setup

  1. Clone the repository:

  ```
  git clone https://github.com/your-username/your-project.git
  cd your-project
  ```
  2. Open the folder in VS Code and select **"Reopen in Container"** when prompted.

  3. Once the container is ready, all dependencies (including the database) will be set up automatically.

## Database

Database setup is fully automated via the Dev Container configuration.

Manual commands, if needed:

```
rails db:setup      # Creates, loads schema, and seeds
rails db:migrate    # Runs migrations
```

## Running the Application

Inside the Dev Container:

```
rails server
```

Then visit: http://localhost:3000

## API Documentation

This project includes full API documentation using OpenAPI (Swagger):

• https://pool-api-sdoe.onrender.com/api-docs


## Running Tests

To run the tests (RSpec):

```
bundle exec rspec
```

## Deployment

This application is live at:

• https://pool-api-sdoe.onrender.com

• https://pool-web-app.onrender.com

• https://github.com/ssantialvarez/pool_web_app

Deployment is managed through Render with continuous deployment from the main branch.
