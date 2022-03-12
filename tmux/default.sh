# Use -d to allow the rest of the function to run
tmux new-session -d -s default
tmux send-keys 'nvim -u ~/dotfiles/neovim/full.vim ~/Dropbox/vimwiki/index.md' C-m
tmux rename-window zettle
# -d to prevent current window from changing
tmux new-window -d
# -d to detach any other client (which there shouldn't be,
# since you just created the session).
tmux attach-session -d -t default
