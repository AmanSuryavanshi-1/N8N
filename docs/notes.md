# n8n Automation Project

*Created by: Aman Suryavanshi*

This document provides a comprehensive overview of the n8n automation project structure and serves as your navigation guide to understanding and working with the various automation modules.

## Project Structure Overview

```
├── config/                     # Configuration files
│   ├── docker-compose.yml      # Docker container configuration
│   ├── config.yml              # Cloudflare tunnel configuration
│   └── .env.example            # Environment variables template
├── docs/                       # Documentation
│   ├── notes.md                # This file - project navigation
│   └── setup/                  # Setup and deployment guides
│       ├── n8n-setup-guide.md  # Complete n8n setup walkthrough
│       └── project-overview.md # Original project overview
├── modules/                    # Automation modules
│   ├── atc-meeting-scheduler/  # ATC lead capture and follow-up
│   │   ├── README.md           # Module documentation
│   │   └── workflows/          # Module workflow files
│   └── personal-rag-agent/     # Personal RAG automation
│       ├── README.md           # Module documentation
│       └── workflows/          # Module workflow files
├── scripts/                    # Utility scripts and tools
│   └── cloudflared.exe         # Cloudflare tunnel executable
├── workflows/                  # Standalone workflow files
├── data/                       # n8n data directory (SQLite DB, logs)
└── src/                        # Legacy source directory (deprecated)
```

## Major Components

### Configuration (`config/`)
Contains all the essential configuration files needed to run your n8n instance:
- **docker-compose.yml**: Defines the n8n Docker container setup
- **config.yml**: Cloudflare tunnel configuration for public access
- **.env.example**: Template for environment variables (copy to `.env` and customize)

### Documentation (`docs/`)
Comprehensive documentation for the project:
- **setup/n8n-setup-guide.md**: Complete guide for setting up n8n from scratch
- **setup/project-overview.md**: Original project overview and philosophy

### Automation Modules (`modules/`)

#### ATC Meeting Scheduler (`modules/atc-meeting-scheduler/`)
**Purpose**: Automated lead capture and follow-up system for Aviators Training Centre
- Captures leads from website contact forms
- Sends initial consultation booking emails
- Implements intelligent follow-up system
- Tracks lead status in Airtable
- **[📖 Read the full documentation](modules/atc-meeting-scheduler/README.md)**

#### Personal RAG Agent (`modules/personal-rag-agent/`)
**Purpose**: Personal Retrieval-Augmented Generation system for document processing
- Stores and processes documents in PostgreSQL with vector embeddings
- Scrapes and indexes web documents
- Provides AI-powered document search and retrieval
- **[📖 Read the full documentation](modules/personal-rag-agent/README.md)**

### Standalone Workflows (`workflows/`)
Individual workflow files that don't belong to a specific module. These are typically:
- Experimental workflows
- One-off automation tasks
- Template workflows for future modules

### Utility Scripts (`scripts/`)
Helper scripts and executables:
- **cloudflared.exe**: Cloudflare tunnel client for exposing local n8n to the internet

## Quick Start Guide

### 1. Initial Setup
1. Copy `config/.env.example` to `config/.env` and fill in your values
2. Ensure Docker Desktop is running
3. Navigate to the `config/` directory
4. Run: `docker-compose up -d`

### 2. Access n8n
- **Local**: http://localhost:5678
- **Public** (after tunnel setup): https://your-domain.com

### 3. Import Workflows
1. Open n8n interface
2. Go to Workflows → Import from File
3. Select workflow JSON files from `modules/*/workflows/` or `workflows/`

### 4. Configure Credentials
Each module's README provides specific credential setup instructions.

## Development Workflow

### Adding New Modules
1. Create new directory under `modules/your-module-name/`
2. Add `README.md` with module documentation
3. Create `workflows/` subdirectory for workflow files
4. Update this navigation document

### Working with Existing Modules
1. Read the module's README.md for specific instructions
2. Import required workflows from the module's workflows/ directory
3. Configure credentials as documented
4. Test workflows in n8n interface

### Backup and Version Control
- **Workflows**: Export from n8n and save to appropriate module directories
- **Data**: The `data/` directory contains your n8n database - back this up regularly
- **Configuration**: Keep `.env` file secure and never commit to version control

## Security Best Practices

1. **Environment Variables**: Never commit `.env` files to version control
2. **Credentials**: Use n8n's credential system, never hardcode API keys
3. **Access Control**: Enable basic auth for production deployments
4. **Tunnel Security**: Use Cloudflare tunnel instead of exposing ports directly

## Troubleshooting

### Common Issues
- **Workflows not triggering**: Check webhook URLs and public domain configuration
- **Credential errors**: Verify API keys and OAuth configurations
- **Database issues**: Check `data/database.sqlite` permissions and disk space

### Getting Help
1. Check module-specific README files
2. Review `docs/setup/n8n-setup-guide.md` for detailed setup instructions
3. Check n8n logs: `docker-compose logs -f n8n` (from config/ directory)

## Module Links

- [🚀 ATC Meeting Scheduler Documentation](modules/atc-meeting-scheduler/README.md)
- [🤖 Personal RAG Agent Documentation](modules/personal-rag-agent/README.md)
- [⚙️ Complete n8n Setup Guide](docs/setup/n8n-setup-guide.md)

---

*This project structure follows industry best practices for maintainability, scalability, and ease of navigation. Each module is self-contained with its own documentation and workflows.*