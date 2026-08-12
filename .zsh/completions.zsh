# Local completions (gitignored)

_harryai() {
    local commands=(
        'start:Create a new worktree with the given branch name'
        'delete:Delete a worktree'
        'list:List all active worktrees'
        'run:Switch active worktree in running dev environment'
        'init:Create a documented .harryai config file'
        'help:Show help message'
    )

    if (( CURRENT == 2 )); then
        _describe 'command' commands
    fi
}
compdef _harryai harryai

_teardown-ai-workspace() {
    local -a sessions
    sessions=( ${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"} )
    compadd "${sessions[@]}"
}
compdef _teardown-ai-workspace teardown-ai-workspace
