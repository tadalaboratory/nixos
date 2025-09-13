{
  pkgs,
  lib,
  ...
}:
let
  username = builtins.baseNameOf ./.;
  password = "$6$wx9q1m22.sRmurBk$6QKe5OzuWbHVTVCRj0YFQfGSnbZNy3dvXhEfuCJ1OviaXhLf6llSiF747/IcbWHc0/RLkip.2tUu.FMvpwGiu.";
  common = import ../common.nix {
    inherit pkgs lib username;
  };
in
{
  users.users."${username}" = common.recursiveMerge common.user {
    extraGroups = [ "projecthazard" ];
    hashedPassword = "${password}";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN9e6V8q6VhGSY+CHL0vb+lQH+YDOXN0RLK8Nz5NSHU nishimura"
    ];
  };

  home-manager.users."${username}" =
    { pkgs, lib, ... }:
    common.recursiveMerge (common.home { inherit pkgs lib; }) {
      home = {
        sessionVariables = {
          GTK_IM_MODULE = "fcitx";
          QT_IM_MODULE = "fcitx";
          XMODIFIERS = "@im=fcitx";
        };
      };
      programs = {
        git = {
          enable = true;
          userName = "qwertyroiro";
          userEmail = "57554521+qwertyroiro@users.noreply.github.com";
        };
        fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting
            set -g fish_key_bindings fish_vi_key_bindings
          '';
          plugins = [
            {
              name = "autopair-fish";
              src = pkgs.fishPlugins.autopair-fish.src;
            }
          ];
        };
      };
    };
}
