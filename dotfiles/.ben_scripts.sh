multissh() {
    local HOSTS=($@)
    if [ -z "$HOSTS" ]; then
       echo -n "Please provide a list of hosts separated by spaces [ENTER]: "
       read -A HOSTS
    fi

    tmux new-window "ssh ${HOSTS[1]};"
    printf '%s\n' "${HOSTS[@]:1}" | xargs -I {} tmux split-window -h "ssh {};"
    tmux select-layout tiled > /dev/null
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
}

getCheatSheet() {
    # remind me of critical hotkeys and commands

}

updateHostWithNix() {
    # update a host using nix flakes

}
