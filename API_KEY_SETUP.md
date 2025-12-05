# 🔐 API Key Management Guide

## TinyMCE API Key Configuration

The TinyMCE rich text editor requires an API key. This key is **NOT** stored in the codebase for security reasons.

### For Local Development

**Option 1: Environment Variable (Recommended)**
```bash
# Run container with environment variable
podman run -e TINYMCE_API_KEY=your_api_key_here -p 3000:3000 --name final-web-app -d final-web-app

# Or create a .env file (already in .gitignore)
echo "TINYMCE_API_KEY=your_api_key_here" >> .env
```

**Option 2: Rails Credentials**
```bash
# Edit encrypted credentials
EDITOR="nano" rails credentials:edit

# Add this line:
tinymce_api_key: your_api_key_here
```

### For Production Deployment

**Environment Variable:**
```bash
export TINYMCE_API_KEY=your_api_key_here
```

**GitHub Secrets (for CI/CD):**
1. Repository Settings → Secrets and variables → Actions
2. Add `TINYMCE_API_KEY` with your key value
3. Reference in workflows: `${{ secrets.TINYMCE_API_KEY }}`

### Current API Key
The API key for this project is: `sq1xw96jefpsewgycndhmzmg6yq6xdycs0vis8akcxj51sl1`

**⚠️ IMPORTANT**: This file should NOT be committed to Git! Add it to .gitignore if sharing the repository.

### How It Works
The application template uses:
```erb
<%= Rails.application.credentials.tinymce_api_key || ENV['TINYMCE_API_KEY'] || 'no-api-key' %>
```

This tries credentials first, then environment variable, then fallback to 'no-api-key'.