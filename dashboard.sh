
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

  # set up tmux
  tmux start-server

  # create a new tmux session
  tmux new-session -d -s $session

  # Split pane 1 horizontally to make room for GPU/CPU info
  tmux splitw -h -p 10
  # Split vertically for small CPU info
  tmux splitw -v -p 55

  # Make thin bottom pane for music
  tmux splitw -f -v -p 5

  # Taskwarrior pane
  tmux splitw -h

  # Assign tasks to each pane 
  tmux selectp -t 1 
  tmux send-keys "htop" C-m 

  tmux selectp -t 2
  tmux send-keys "watch --no-title -n 5 nvidia-smi" C-m 

  tmux selectp -t 3
  tmux send-keys "watch --no-title -n 5 sensors" C-m 

  tmux selectp -t 4
  tmux send-keys "ncmpcpp" C-m 

  tmux selectp -t 5
  tmux send-keys "while true; do clear && task next limit:3; sleep 3; done" C-m 

fi

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
