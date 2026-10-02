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
    local -a tldr_tools=(
        git rg fd jq yq tmux nix nvim vim fzf zoxide eza delta
        kubectl kubectx k9s docker go npm python python3 pip cargo
        ssh scp rsync curl wget tar gzip unzip sed awk grep find xargs
        chmod chown ps kill lsof du df htop less sort uniq cut tr date
        openssl gpg op tofu terraform
    )

    local -a sources=(bash local)
    command -v tldr >/dev/null 2>&1 && sources+=(tldr)

    local -i attempts=0
    while (( attempts < 5 && ${#sources} )); do
        local idx=$((RANDOM % ${#sources} + 1))
        local pick="${sources[$idx]}"
        case "$pick" in
            bash)  _printBashTip && return 0 ;;
            local) _printLocalCheat && return 0 ;;
            tldr)
                local -a available_tools
                local tool
                for tool in "${tldr_tools[@]}"; do
                    command -v "$tool" >/dev/null 2>&1 && available_tools+=("$tool")
                done
                if (( ${#available_tools} )); then
                    tool="${available_tools[$((RANDOM % ${#available_tools} + 1))]}"
                    _printTldrCheat "$tool" && return 0
                fi
                ;;
        esac
        sources[$idx]=()
        (( attempts++ ))
    done

    _printBashTip
}

_printCheatLine() {
    local line="$1"

    local name="${line%%|*}"
    local rest="${line#*|}"
    local example="${rest%|*}"
    local desc="${rest##*|}"

    print -Pn "%F{cyan}TIL%f %B"
    print -rn -- "$name"
    print -Pn "%b - "
    print -r -- "$desc"
    print -Pn "  %F{8}\$%f "
    print -r -- "$example"
}

_printBashTip() {
    local -a tips=(
        'bash|cmd_a && cmd_b|run the second command only when the first succeeds'
        'bash|cmd_a || cmd_b|run a fallback command when the first one fails'
        'bash|cmd >out.log 2>err.log|split stdout and stderr into separate files'
        'bash|cmd >out.log 2>&1|send stdout and stderr to the same file'
        'bash|cmd_a | tee out.log | cmd_b|save pipeline output while still passing it along'
        'bash|rg -l TODO | while read -r file; do nvim "$file"; done|loop safely over command output'
        'bash|rg "error" logs | fzf | cut -d: -f1|filter search results interactively, then extract filenames'
        'bash|find . -name "*.log" -print0 | xargs -0 wc -l|pipe filenames safely even when they contain spaces'
        'bash|printf "%s\n" "${array[@]}"|print one array item per line without word splitting'
        'bash|for file in *.md; do wc -l "$file"; done|loop over matching files with quoted variables'
        'bash|while IFS= read -r line; do printf "%s\n" "$line"; done < file|read a file line by line without mangling backslashes'
        'bash|name=${file##*/}|strip a path down to its filename with parameter expansion'
        'bash|base=${file%.*}|strip the shortest matching extension from a filename'
        'bash|: "${REQUIRED_ENV:?set REQUIRED_ENV first}"|fail early when a required variable is missing'
        'bash|tmp=$(mktemp) && trap "rm -f \"$tmp\"" EXIT|clean up a temp file automatically on exit'
        'bash|set -euo pipefail|exit on errors, unset variables, and failed pipeline stages'
        'bash|diff <(sort old.txt) <(sort new.txt)|compare generated command output with process substitution'
        'bash|mkdir -p src/{bin,lib,test}|create several sibling directories with brace expansion'
        'bash|(cd /tmp && tar -czf logs.tgz logs)|run a directory change inside a subshell'
        'bash|if cmd; then echo ok; else echo failed; fi|branch directly on a command exit status'
        'bash|curl -s URL | jq -r ".items[].name" | sort -u|pipe JSON through jq, then sort unique values'
        'bash|ps aux | sort -nrk 3 | head|show the processes using the most CPU'
        'bash|du -sh * | sort -h|summarize directory sizes and sort them naturally'
        'bash|history | fzf|search shell history interactively'
    )

    (( ${#tips} )) || return 1
    _printCheatLine "${tips[$((RANDOM % ${#tips} + 1))]}"
}

_printLocalCheat() {
    local cheats="${HOME}/.cheats.txt"

    [[ -f "$cheats" ]] || return 1
    local line trimmed
    local -a lines
    while IFS= read -r line; do
        trimmed="${line#"${line%%[![:space:]]*}"}"
        [[ -z "$trimmed" || "$trimmed" == \#* || "$trimmed" != *\|*\|* ]] && continue
        lines+=("$trimmed")
    done < "$cheats"
    (( ${#lines} )) || return 1

    local line="${lines[$((RANDOM % ${#lines} + 1))]}"

    _printCheatLine "$line"
}

_printTldrCheat() {
    local tool="$1"
    local out
    out="$(tldr "$tool" 2>/dev/null)" || return 1
    [[ -n "$out" ]] || return 1

    local line trimmed desc
    local -a descriptions commands
    for line in "${(@f)out}"; do
        trimmed="${line#"${line%%[![:space:]]*}"}"
        if [[ "$trimmed" == "- "* ]]; then
            desc="${trimmed#- }"
            desc="${desc%:}"
        elif [[ -n "$desc" && -n "$trimmed" && "$line" == [[:space:]]* ]]; then
            descriptions+=("$desc")
            commands+=("$trimmed")
            desc=
        fi
    done

    (( ${#commands} )) || return 1
    local index=$((RANDOM % ${#commands} + 1))

    print -Pn "%F{cyan}TIL%f %B"
    print -rn -- "$tool"
    print -Pn "%b - "
    print -r -- "${descriptions[$index]}"
    print -Pn "  %F{8}\$%f "
    print -r -- "${commands[$index]}"
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
    updateHomeManagerWithNix "$@" && [[ -o interactive ]] && exec zsh -l
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
