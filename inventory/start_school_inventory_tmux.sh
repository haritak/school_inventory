#!/bin/bash
tmux new-session -s invent -d
tmux send-keys -t invent 'cd /home/administrator/school_inventory/inventory' C-m
tmux send-keys -t invent 'bin/rails server -b 0.0.0.0 -p 3000' C-m
tmux new-window -t invent
