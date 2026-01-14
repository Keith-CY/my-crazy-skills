# Auto-Add Trending Skills GitHub Action

This GitHub Action automatically discovers and adds trending skills repositories to your collection.

## Features

- 🔄 **Automatic Discovery**: Weekly scan for trending skills repositories
- 📝 **Manual Trigger**: Run on-demand with custom search queries
- 🎯 **Issue-Based**: Add specific skills by creating issues
- 🔀 **Auto PR**: Creates pull requests for all additions
- 📦 **Submodule Integration**: Adds skills as git submodules for easy updates

## How It Works

### 1. Scheduled Runs

Every 8 hours, the workflow automatically:

1. Searches GitHub for trending skills repositories (created in last 30 days, 10+ stars)
2. Uses default query: `topic:ai-skill OR topic:skill`
3. Analyzes each repository to determine the best category using multi-factor analysis
4. Adds new skills as git submodules
5. Creates a pull request for review

### 2. Manual Trigger

Run the workflow manually from GitHub Actions tab:

1. Go to **Actions** → **Auto-Add Trending Skills**
2. Click **Run workflow**
3. Configure options:
   - **Search Query**: Customize repository search
   - **Category**: Target category (coding, frontend, research, devops, general)

### 3. Issue-Based Trigger

Create an issue to add specific skills:

**Title**: `[ADD SKILL] My Awesome Skills Collection`

**Body**:
```
Please add these skills:

https://github.com/owner/awesome-skill
https://github.com/owner/another-skill
```

The workflow will:
- Parse the issue
- Add the repositories as submodules
- Create a pull request
- Update the issue with PR details

## Workflow Structure

```
┌─────────────────┐
│  parse-issue    │ ← Parse issues for repo URLs
└────────┬────────┘
         │
    ┌────▼─────┐
    │ discover │ ← Search trending repos (scheduled/manual)
    │ trending │
    └────┬─────┘
         │
    ┌────▼────────┐
    │ process     │ ← Add skills as submodules
    │ skills      │
    └────┬────────┘
         │
    ┌────▼─────────┐
    │ create-pr    │ ← Create pull request
    └──────────────┘
```

## Skill Categories

Skills are automatically categorized using intelligent multi-factor analysis:

### Detection Factors

The workflow analyzes each repository using:

1. **GitHub API Metadata**
   - Primary programming language
   - Repository description
   - GitHub topics/tags

2. **Repository Content**
   - README.md file content (cloned temporarily for analysis)

3. **Repository Name**
   - Keywords in repository name

### Scoring System

Each factor contributes points to category scores:

- **Frontend**: JavaScript/TypeScript, UI/UX keywords, component-related topics
- **Coding**: Python/Java/Go/Rust, development tools, programming keywords
- **DevOps**: Shell/Dockerfile, infrastructure topics, deployment keywords
- **Research**: Analysis/documentation topics, ML/AI keywords
- **General**: Fallback category when no strong signals detected

The category with the highest score is selected. If README.md contains strong category indicators, it can override the algorithmic decision.

### Categories

- **coding**: For software development and programming skills
- **frontend**: For UI/UX and component development skills
- **research**: For analysis, documentation, and research skills
- **devops**: For CI/CD and infrastructure skills
- **general**: For general-purpose skills (default when no clear category)

## Permissions

The workflow requires these permissions:
- `contents: write` - Create commits and branches
- `pull-requests: write` - Create pull requests
- `issues: write` - Update issues with status

## Customization

### Modify Search Query

Edit the workflow file `.github/workflows/auto-add-skills.yml`:

```yaml
- name: Search for trending skills repositories
  run: |
    SEARCH_QUERY="topic:your-topic OR topic:another-topic"
    MIN_STARS=20  # Minimum star count
    DAYS_AGO=30   # Look back period
```

### Change Schedule

Modify the cron expression:

```yaml
on:
  schedule:
    - cron: '0 9 * * 1'  # Monday 9 AM UTC
```

Cron format: `minute hour day month weekday`

Examples:
- Daily at midnight: `0 0 * * *`
- Weekly on Friday: `0 9 * * 5`
- Monthly on 1st: `0 9 1 * *`

## Examples

### Add Skills via Issue

```
[ADD SKILL] Add React and TypeScript Skills

I found these useful React and TypeScript skills:

https://github.com/owner/react-component-skill
https://github.com/owner/typescript-utility-skill
```

### Manual Trigger with Custom Query

1. Go to Actions → Auto-Add Trending Skills
2. Click "Run workflow"
3. Set:
   - Search Query: `language:typescript stars:>50 pushed:>2025-01-01`
   - Category: frontend
4. Click "Run workflow"

## Troubleshooting

### Workflow fails with "No valid URLs found"

**Issue**: Issue doesn't contain valid GitHub repository URLs

**Solution**: Format URLs correctly:
```
https://github.com/owner/repo-name
```

### "Already exists as submodule" message

**Issue**: Repository is already added as a submodule

**Solution**: This is normal behavior - the workflow skips duplicates

### PR not created

**Issue**: No new skills found

**Solution**: Check the workflow logs to see what happened. It may be that all matching repositories are already added.

## Integration with Existing Workflow

This workflow works seamlessly with the existing `update-submodules.yml` workflow:

- **auto-add-skills.yml**: Discovers and adds new skills
- **update-submodules.yml**: Keeps all submodules up to date

Together they provide a complete skills management system.

## Monitoring

Check workflow status:
- **Actions** tab → See all workflow runs
- **Issues** → Track automation status via labels
- **Pull Requests** → Review and merge automated additions

## Best Practices

1. **Review PRs**: Always review automated PRs before merging
2. **Use Labels**: The workflow adds helpful labels for tracking
3. **Custom Categories**: Choose appropriate categories when manually triggering
4. **Check Quality**: Verify skill repositories are well-maintained before merging
5. **Update Documentation**: Keep this README updated with your customizations

## Related Files

- `.github/workflows/auto-add-skills.yml` - Main workflow
- `.github/workflows/update-submodules.yml` - Submodule updater
- `skills/` - Directory containing all skill submodules
