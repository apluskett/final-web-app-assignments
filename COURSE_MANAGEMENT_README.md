# Course Management System

A modern Ruby on Rails application for managing university courses, sections, and student enrollments with rich text editing capabilities.

## Features

- **Course Management System**: Complete course, section, and student management
- **Rich Text Editing**: FOSS Trix editor integration for course syllabi with formatting capabilities
- **Responsive Design**: Modern UI with Tailwind CSS that works on all devices
- **Database Management**: SQLite with proper migrations and seeding
- **Containerized Deployment**: Docker/Podman support with automated database setup
- **No External Dependencies**: Fully offline-capable with no API keys required

## Prerequisites

- Ruby 3.4.4
- Rails 8.0
- Node.js 20+
- Docker/Podman (for containerized deployment)

## Technology Stack

- **Backend**: Ruby on Rails 8.0
- **Frontend**: React 18 with modern JavaScript (ES6+)
- **Styling**: Tailwind CSS
- **Database**: SQLite (production-ready with proper configuration)
- **Rich Text**: Trix Editor (FOSS) via Rails ActionText
- **Build Tools**: esbuild for JavaScript bundling
- **Deployment**: Containerized with Podman/Docker
- **Asset Pipeline**: Rails Propshaft for efficient asset management

## Quick Start (Container)

### Build and Run

```bash
# Build the container image
podman build -t final-web-app .

# Run the container
podman run -p 3000:3000 --name final-web-app -d final-web-app
```

Or with Docker:
```bash
docker build -t final-web-app .
docker run -p 3000:3000 --name final-web-app -d final-web-app
```

The application will be available at http://localhost:3000

### Container Management

```bash
# Stop the container
podman stop final-web-app

# Remove the container
podman rm final-web-app

# View logs
podman logs final-web-app
```

## Development Setup

### Local Development

```bash
# Clone the repository
git clone <repository-url>
cd final-web-app

# Install Ruby dependencies
bundle install

# Install Node.js dependencies
npm install

# Setup database
rails db:create db:migrate db:seed

# Build JavaScript assets
npm run build

# Start the server
rails server
```

Visit http://localhost:3000

## Rich Text Editing

The application uses Trix editor (FOSS) via Rails ActionText for rich text editing of course syllabi. Features include:

- **No API Keys Required**: Completely self-contained
- **Offline Capable**: Works without internet connection
- **FOSS Solution**: Open source Trix editor
- **Theme Compatible**: Styled for light, dark, and custom themes
- **Full Formatting**: Bold, italic, lists, links, and more

## Database Schema

### Core Entities

- **Prefixes**: Course prefixes (CSCI, MATH, etc.)
- **Courses**: Course definitions with rich text syllabi
- **Sections**: Course sections with instructors
- **Students**: Student records with contact information
- **Section Students**: Enrollment relationships

### Key Features

- Unique constraints prevent duplicate enrollments
- Rich text content stored via ActionText
- Proper foreign key relationships
- Comprehensive seed data for testing

## API Endpoints

### Courses
- `GET /courses` - List all courses
- `GET /courses/new` - New course form
- `POST /courses` - Create course
- `GET /courses/:id` - Show course details
- `GET /courses/:id/edit` - Edit course form
- `PATCH/PUT /courses/:id` - Update course
- `DELETE /courses/:id` - Delete course

### Other Resources
Similar CRUD operations available for:
- `/prefixes` - Course prefixes
- `/sections` - Course sections  
- `/students` - Student records

## Deployment

### Container Deployment

The application includes a complete containerized deployment setup:

- **Multi-stage build** for optimized image size
- **Automatic database setup** with migrations and seeding
- **Production-ready configuration** with proper security
- **Health checks** and proper logging
- **Asset compilation** during build process

### Production Considerations

- SQLite configured for production use
- Assets precompiled and fingerprinted
- Security headers and CSRF protection
- Proper error handling and logging

## Development Notes

### Asset Pipeline
- React components built with esbuild
- CSS processed through Tailwind
- Rails Propshaft for asset serving
- Source maps for debugging

### Database
- SQLite with WAL mode for better concurrency
- Proper indexing for performance
- Foreign key constraints enabled
- Comprehensive migrations

### Security
- CSRF protection enabled
- Secure headers configured
- SQL injection prevention
- XSS protection via Rails helpers

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly (both React and Rails components)
5. Submit a pull request

## License

This project is available as open source under the terms of the MIT License.