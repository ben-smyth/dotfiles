{ homeDirectory, ... }:
{
  # Start the Codex app-server daemon with remote control enabled at login.
  # `remote-control start` is idempotent and exits after spawning the daemon.
  launchd.agents.codex-remote-control = {
    enable = true;
    config = {
      ProgramArguments = [
        "${homeDirectory}/.codex/packages/standalone/current/codex"
        "remote-control"
        "start"
      ];
      RunAtLoad = true;
      StandardOutPath = "${homeDirectory}/Library/Logs/codex-remote-control.log";
      StandardErrorPath = "${homeDirectory}/Library/Logs/codex-remote-control.log";
    };
  };
}
