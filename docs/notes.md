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
## 🔐 
**n8n Security Architecture**

*Understanding how n8n keeps your credentials secure while enabling workflow sharing*

### **The Security Model**

n8n uses a **separation of concerns** approach where workflow logic and sensitive credentials are stored completely separately. This allows you to safely share workflow files without exposing any secrets.

```
┌─────────────────────────────────────────────────────────────────┐
│                    n8n Security Architecture                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  📁 Workflow JSON Files          🔒 Credential Store            │
│  ┌─────────────────────┐        ┌─────────────────────────┐     │
│  │ • Node configurations│        │ • Encrypted SQLite DB   │     │
│  │ • Workflow logic     │   ←→   │ • API keys & tokens     │     │
│  │ • Email templates    │        │ • OAuth credentials     │     │
│  │ • Credential IDs     │        │ • Database passwords    │     │
│  │                     │        │ • Webhook secrets       │     │
│  │ ✅ Safe to share    │        │ ❌ Never exported       │     │
│  └─────────────────────┘        └─────────────────────────┘     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### **How Credential References Work**

When you configure a node with credentials in n8n:

#### **Step 1: Credential Creation**
```json
// What you enter in n8n UI:
{
  "name": "Gmail OAuth2",
  "clientId": "123456789-abc...apps.googleusercontent.com",
  "clientSecret": "GOCSPX-YourActualSecret",
  "accessToken": "ya29.a0AfH6SMC...",
  "refreshToken": "1//04..."
}
```

#### **Step 2: Secure Storage**
```sql
-- Stored in encrypted database.sqlite:
INSERT INTO credentials (id, name, type, data) VALUES (
  'WnIOg68zhORw4GOO',
  'Gmail OAuth2', 
  'gmailOAuth2',
  encrypt('{"clientId":"123...","clientSecret":"GOCSPX..."}')
);
```

#### **Step 3: Workflow Reference**
```json
// What appears in exported workflow JSON:
{
  "name": "Send Email",
  "type": "n8n-nodes-base.gmail",
  "credentials": {
    "gmailOAuth2": {
      "id": "WnIOg68zhORw4GOO",  // ← Only the reference ID
      "name": "Gmail OAuth2"      // ← Human-readable name
    }
  }
}
```

### **What Gets Exported vs. What Stays Protected**

| Workflow JSON Export | Credential Store |
|---------------------|------------------|
| ✅ Node configurations | ❌ API keys |
| ✅ Workflow connections | ❌ OAuth tokens |
| ✅ Email templates | ❌ Database passwords |
| ✅ Logic and conditions | ❌ Webhook secrets |
| ✅ Credential reference IDs | ❌ Client secrets |
| ✅ Test data | ❌ Access tokens |

### **Real Example from Our Workflows**

#### **In the Workflow JSON (Safe to Share):**
```json
{
  "name": "Send Consultation Email",
  "type": "n8n-nodes-base.gmail",
  "credentials": {
    "gmailOAuth2": {
      "id": "WnIOg68zhORw4GOO",
      "name": "Gmail OAuth2 API"
    }
  },
  "parameters": {
    "sendTo": "={{ $json.email }}",
    "subject": "Free Aviation Consultation - Let's Get Started! ✈️"
  }
}
```

#### **In the Encrypted Database (Never Exported):**
```json
{
  "id": "WnIOg68zhORw4GOO",
  "type": "gmailOAuth2",
  "data": {
    "clientId": "123456789-abc...apps.googleusercontent.com",
    "clientSecret": "GOCSPX-ActualSecretValue",
    "accessToken": "ya29.a0AfH6SMC...",
    "refreshToken": "1//04...",
    "scope": "https://www.googleapis.com/auth/gmail.send"
  }
}
```

### **Security Benefits of This Architecture**

#### **✅ Safe Workflow Sharing**
- **Portfolio showcase**: Share workflow logic without exposing secrets
- **Team collaboration**: Developers can work on workflows safely
- **Version control**: Commit workflow files to Git without security risks
- **Documentation**: Include real workflow examples in documentation

#### **🔒 Credential Protection**
- **Encryption at rest**: All credentials encrypted in SQLite database
- **No accidental exposure**: Impossible to accidentally commit secrets
- **Centralized management**: All credentials managed in one secure location
- **Access control**: Credentials tied to specific n8n instance

#### **🔄 Import/Export Process**
```
Export Workflow:
Workflow Logic + Credential IDs → JSON File (Safe to share)

Import Workflow:
JSON File + Configure New Credentials → Working Workflow
```

### **Why This Matters for Your Portfolio**

#### **Professional Credibility**
- **Shows real implementations**: Actual working workflow code
- **Demonstrates complexity**: Multi-service integrations visible
- **Proves expertise**: Advanced n8n patterns and best practices
- **Security awareness**: Understanding of proper credential management

#### **Technical Interview Benefits**
- **Code walkthrough**: Interviewers can examine actual workflow logic
- **Architecture discussion**: Explain separation of concerns
- **Security knowledge**: Demonstrate understanding of credential management
- **Problem-solving**: Show how complex integrations are implemented

### **Best Practices for Workflow Security**

#### **✅ Do This:**
- Export and share workflow JSON files for portfolio
- Use descriptive names for credentials (helps with imports)
- Document required credentials in README files
- Include credential setup instructions
- Use environment variables for configuration

#### **❌ Never Do This:**
- Hardcode API keys in workflow parameters
- Share screenshots with visible credentials
- Commit actual credential files to Git
- Include sensitive test data in workflows
- Share database.sqlite file

### **Credential Migration Between Environments**

When someone imports your workflow:

#### **Step 1: Import Workflow**
```bash
# Workflow imports with broken credential references
"credentials": {
  "gmailOAuth2": {
    "id": "WnIOg68zhORw4GOO"  # ← This ID won't exist in new environment
  }
}
```

#### **Step 2: Configure New Credentials**
```
1. Create new Gmail OAuth2 credential in target n8n
2. n8n assigns new ID: "XyZ789NewID"
3. Update workflow to use new credential
4. Test and activate workflow
```

#### **Step 3: Working Workflow**
```json
// Updated with new environment's credential ID
"credentials": {
  "gmailOAuth2": {
    "id": "XyZ789NewID",  # ← New ID for new environment
    "name": "Gmail OAuth2 API"
  }
}
```

### **Security Verification Commands**

To verify your workflows are safe to share:

```bash
# Check for potential secrets in workflow files
grep -r "api.*key\|secret\|password\|token" modules/*/workflows/*.json

# Look for actual credential values (should return nothing)
grep -r "AIza\|sk-\|xoxb-\|ghp_" modules/*/workflows/*.json

# Verify only credential references exist
grep -r "credentials.*id" modules/*/workflows/*.json
```

### **Summary: Why n8n's Security Model is Brilliant**

1. **🔐 Complete Separation**: Workflow logic and credentials never mix
2. **📤 Safe Sharing**: Export workflows without any security risk  
3. **🔄 Easy Migration**: Import workflows and configure credentials separately
4. **👥 Team Friendly**: Multiple developers can work on same workflows safely
5. **📚 Portfolio Ready**: Show real implementations without exposing secrets

This architecture allows you to confidently showcase your n8n automation skills while maintaining enterprise-grade security standards.

---

*Understanding this security model is crucial for professional n8n development and demonstrates advanced knowledge of automation security best practices.*