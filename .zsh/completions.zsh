# Local completions (gitignored)

_workai() {
    local commands=(
        'new:Create a new worktree with the given branch name'
        'split:Split current branch into a new worktree'
        'join:Join an existing worktree branch in the main repo'
        'delete:Delete a worktree and its branch'
        'list:List all active worktrees'
        'help:Show help message'
    )

    if (( CURRENT == 2 )); then
        _describe 'command' commands
    fi
}
compdef _workai workai
