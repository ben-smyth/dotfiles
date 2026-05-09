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
    local repo="${DOTFILES_REPO:-$HOME/dotfiles}"
    "$repo/nix/scripts/update_system.sh" "$@"
}

rebuildHostWithNix() {
    local repo="${DOTFILES_REPO:-$HOME/dotfiles}"
    "$repo/nix/scripts/update_system.sh" --no-update "$@"
}

updateHomeManagerWithNix() {
    local repo="${DOTFILES_REPO:-$HOME/dotfiles}"
    local configuration="${1:-${USER:-${LOGNAME:-}}}"

    if [[ -z "$configuration" ]]; then
        configuration="$(/usr/bin/id -un)"
    fi

    /bin/bash "$repo/nix/scripts/update_home.sh" "$configuration"
}

homeManagerNewsWithNix() {
    local repo="${DOTFILES_REPO:-$HOME/dotfiles}"
    local configuration="${1:-${USER:-${LOGNAME:-}}}"

    if [[ -z "$configuration" ]]; then
        configuration="$(/usr/bin/id -un)"
    fi

    (
        cd "$repo" || return
        nix run ".#home-manager" -- --flake ".#${configuration}" news
    )
}

hmup() {
    updateHomeManagerWithNix "$@"
}

hmnews() {
    homeManagerNewsWithNix "$@"
}

updateNvimPlugins() {
    local repo="${DOTFILES_REPO:-$HOME/dotfiles}"
    "$repo/nix/scripts/update_neovim.sh"
}

updateShellPlugins() {
    if ! command -v zinit >/dev/null 2>&1; then
        echo "zinit is not loaded in this shell" >&2
        return 1
    fi

    zinit self-update
    zinit update --all
}
