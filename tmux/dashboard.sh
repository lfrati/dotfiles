#!/bin/sh
#
# Setup a work space called `dash` with 4 panes
# The first pane set at 65%, split horizontally, set to api root and running vim
# pane 2 is split at 25% and running redis-server
# pane 3 is set to api root and bash prompt.
# note: `api` aliased to `cd ~/path/to/work`
#
session="dash"

# Check if the session exists, discarding output
# We can check $? for the exit status (zero for success, non-zero for failure)
tmux has-session -t $session 2>/dev/null

if [ $? != 0 ]; then

  echo "Setting up"

  # set up tmux
  tmux start-server

  # Pane 1
  # create a new tmux session
  tmux new-session -d -s $session -x $(tput cols) -y $(tput lines)

  # Pane 2
  # Make thin bottom pane for music
  tmux splitw -f -v -p 40

  # Assign tasks to each pane
  tmux selectp -t 1
  tmux send-keys "htop" C-m

  tmux selectp -t 2
  tmux send-keys "watch --no-title -n 5 nvidia-smi -i GPU-9806b0a0-d4f8-3fc1-06aa-53716a16702e" C-m

fi

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
