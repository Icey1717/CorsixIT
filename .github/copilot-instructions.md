## Issue Tracking

This project uses **bd (beads)** for issue tracking.
Run `bd prime` for workflow context.

**Quick reference:**
- `bd ready` - Find unblocked work
- `bd create "Title" --type task --priority 2` - Create issue
- `bd close <id>` - Complete work
- `bd dolt push` - Push changes to remote (run at session end)

## Searching Code

This project support code munch (jcodemunch) via mcp.
The following tools are available:

index_repo 	Index a GitHub repository
index_folder 	Index a local folder
list_repos 	List indexed repositories
get_file_tree 	Repository file structure
get_file_outline 	Symbol hierarchy for a file
get_symbol 	Retrieve full symbol source
get_symbols 	Batch retrieve symbols
search_symbols 	Search symbols with filters
search_text 	Full-text search
get_repo_outline 	High-level repo overview
invalidate_cache 	Remove cached index