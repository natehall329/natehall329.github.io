# Claude Code Instructions for Hugo Website Management

## Website Verification Protocol
When making changes to this Hugo academic website:

1. **Always verify live website state** before making claims about what's currently displayed
   - Use WebFetch tool to check https://natehall329.github.io 
   - Compare current state with expected changes
   - Don't assume changes are live until verified

2. **Build and deploy verification**
   - After making changes, commit and push to GitHub
   - Wait 2-3 minutes for GitHub Pages to rebuild
   - Use WebFetch to confirm changes are live before reporting completion
   - If changes don't appear, investigate build issues or caching problems

3. **Navigation and content structure**
   - This site uses Hugo Blox Builder theme
   - Navigation menu is controlled by config/_default/menus.yaml
   - Homepage sections are defined in content/_index.md
   - Always verify menu structure matches intended site organization

4. **Common issues to check**
   - GitHub Pages build errors (check for YAML syntax issues)
   - Browser/CDN caching (recommend hard refresh to users)
   - Theme compatibility issues with Hugo version
   - Demo blocks or template content overriding custom content

5. **Debugging approach**
   - If website doesn't show expected changes, make a small test change and push
   - Use WebFetch to see actual rendered content vs expected content
   - Check git log to confirm commits were pushed successfully
   - Consider GitHub Pages deployment delays

## Website Structure Notes
- Main site: https://natehall329.github.io
- Owner: Nathan (Nate) Hall, PhD candidate in Psychology/Neuroscience at UNC
- Theme: Hugo Academic/Blox Builder template
- Target sections: Biography (homepage), Research, Publications, Posts, CV, Clinical Psychology decision

## Key Files
- Homepage: content/_index.md
- Navigation: config/_default/menus.yaml
- Site config: config/_default/hugo.yaml
- Author profile: content/authors/admin/_index.md

## Commands to run
- Build: `hugo`
- Local server: `hugo server`
- Deploy: `git add -A && git commit -m "message" && git push`