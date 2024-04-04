{ config, pkgs, ...}:

{ 
  systemd.timers."fitness-tracker-ci-update-lock" = {
    timerConfig	= {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "fitness-tracker-ci-update-lock.service";
    };
  };

  systemd.services."fitness-tracker-ci-update-lock" = {
    script = ''
      cd /home/jeff/fitness-tracker/ci
      nix flake update
      if [[ `git status --porcelain` ]]; then
          echo "Changes detected!"
          git add flake.lock 
          git commit -m "Automatic lock update"
          git push github main
      else
          echo "No changes detected"
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "jeff";
    };
  };
}
