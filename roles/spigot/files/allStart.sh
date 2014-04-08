#!/bin/sh
byobu-tmux new-session -d -s minecraft

# BUNGEECORD ROOT
echo "Starting Core BungeeCord Services"
# start the bungeecord core server
byobu-tmux new-window -t minecraft:1 -n 'BungeeCord' 'cd bungeeCord; ./start.sh'

# lobby
echo "Starting Core BungeeCord Lobby"
byobu-tmux new-window -t minecraft:2 -n 'BungeeCordLobby' 'cd backend/lobby; ./start.sh'

# BUNGEECORD BACKENDS
# survival
echo "Starting Survival"
byobu-tmux new-window -t minecraft:3 -n 'Survival' 'cd backend/survival; ./start.sh'

# creative
echo "Starting Creative"
byobu-tmux new-window -t minecraft:4 -n 'Creative' 'cd backend/creative; ./start.sh'

# LAUNCH COMPLETE
# attatch to the bungeecord session
echo "Startup complete, connecting to BungeeCord Root"
byobu-tmux select-window -t minecraft:1
byobu-tmux -2 attach-session -t minecraft

