{
  config,
  pkgs,
  lib,
  ...
}:
let
  hostName = builtins.baseNameOf ./.;
in
{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
    optimise = {
      automatic = true;
      dates = [ "05:00" ];
    };
    gc = {
      automatic = true;
      dates = "05:00";
      options = "-d";
    };
  };
  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      allowUnfree = true;
      cudaSupport = true;
      nvidia.acceptLicense = true;
    };
  };
  system = {
    stateVersion = "25.05";
    autoUpgrade = {
      enable = true;
      dates = "05:00";
      flake = "/etc/nixos#${hostName}";
      allowReboot = true;
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/bd0e7ec7-5d59-4b22-9ecf-e7aafd31b91b";
      fsType = "ext4";
    };
    "/mnt/data" = {
      device = "/dev/disk/by-uuid/e564e92e-f715-4554-ad3d-b826c3a25526";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FA39-70C7";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    "/mnt/data_4tb" = {
      device = "/dev/disk/by-uuid/3710c08f-42dd-41d0-9608-f17fa3668660";
      fsType = "ext4";
    };
  };
  swapDevices = [ { device = "/dev/disk/by-uuid/5c6cfda6-b821-4bb1-9439-62cb5057529c"; } ];
  hardware = {
    cpu = {
      intel = {
        updateMicrocode = true;
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
      extraPackages32 = [ pkgs.nvidia-vaapi-driver ];
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      nvidiaSettings = false;
      modesetting.enable = true;
      open = false;
    };
    nvidia-container-toolkit = {
      enable = true;
    };
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "udev.log_level=3"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
      "boot.shell_on_fail"
      "systemd.show_status=auto"
      "nvidia_drm.modeset=1"
      "pcie_aspm.policy=performance"
    ];
    kernelModules = [
      "kvm-intel"
      "ecryptfs"
    ];
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
      kernelModules = [
        "kvm-intel"
        "ecryptfs"
      ];
      availableKernelModules = [
        "kvm-intel"
        "ecryptfs"
        "nvidia"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      luks.devices = {
        "luks-f77a09ca-9f4a-4d50-974e-258ffc652145".device =
          "/dev/disk/by-uuid/f77a09ca-9f4a-4d50-974e-258ffc652145";
        "luks-4f8ebcda-b115-4aa5-b0d0-bd25609c04d2".device =
          "/dev/disk/by-uuid/4f8ebcda-b115-4aa5-b0d0-bd25609c04d2";
      };
    };
    plymouth = {
      enable = true;
      theme = "black_hud";
      themePackages = with pkgs; [ adi1090x-plymouth-themes ];
    };
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    loader = {
      timeout = 0;
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
    };
  };
  console = {
    useXkbConfig = true;
  };
  environment.systemPackages = with pkgs; [
    vim
    git
    tmux
    wget
    ecryptfs
    keyutils
    curl
    aria2
    httpie
    xh
    jq
    yq-go
    miller
    xan
    visidata
    ripgrep
    fd
    fzf
    bat
    eza
    tree
    broot
    zoxide
    procs
    sd
    delta
    diff-so-fancy
    colordiff
    just
    entr
    watchexec
    tealdeer
    zip
    unzip
    p7zip
    zstd
    xz
    lz4
    pigz
    pbzip2
    unrar
    atool
    pv
    progress
    rsync
    rclone
    sshfs
    sshpass
    keychain
    gnupg
    age
    rage
    sops
    openssl
    wl-clipboard
    xclip
    xsel
    htop
    btop
    bottom
    sysstat
    dool
    iotop
    lsof
    psmisc
    procps
    duf
    dua
    dust
    ncdu
    smartmontools
    nvme-cli
    parted
    gptfdisk
    hdparm
    fio
    lshw
    pciutils
    usbutils
    lm_sensors
    acpi
    efibootmgr
    iproute2
    iputils
    inetutils
    dnsutils
    ldns
    dogdns
    traceroute
    mtr
    tcpdump
    wireshark-cli
    nmap
    whois
    ethtool
    socat
    netcat-openbsd
    arp-scan
    iperf3
    speedtest-cli
    iw
    bluez
    wireguard-tools
    openvpn
    docker-compose
    ctop
    dive
    podman
    buildah
    skopeo
    strace
    ltrace
    valgrind
    gdb
    sysdig
    bpftrace
    lnav
    multitail
    screen
    ffmpeg
    imagemagick
    poppler_utils
    pdfgrep
    exiftool
  ];
  systemd = {
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
    services.gnome-remote-desktop = {
      wantedBy = [ "graphical.target" ];
    };
  };
  security = {
    protectKernelImage = true;
    polkit.enable = true;
    rtkit.enable = true;
    pam.enableEcryptfs = true;
    sudo.extraConfig = ''
      Defaults env_reset,pwfeedback
      Defaults badpass_message="残念😎！君のパスワードは脆弱だ👊"
    '';
  };
  networking = {
    hostName = "${hostName}";
    useDHCP = lib.mkDefault true;
    nameservers = [ "192.168.10.1" ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5900
        9090
        9093
      ];
    };
  };
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "05:00";
        flags = [ "--all" ];
      };
    };
  };
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans CJK JP" ];
        serif = [ "Noto Serif CJK JP" ];
        monospace = [ "JetBrains Mono" ];
      };
      subpixel = {
        rgba = "rgb";
      };
      hinting = {
        enable = true;
      };
    };
  };
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    supportedLocales = [
      "ja_JP.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };
  time = {
    timeZone = "Asia/Tokyo";
  };
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.bash;
    groups = {
      projecthazard = { };
    };
  };
  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        user = {
          name = "tadalaboratory";
          email = "103712387+tadalaboratory@users.noreply.github.com";
        };
      };
    };
    fish = {
      enable = true;
    };
    nix-ld = {
      enable = true;
    };
    dconf = {
      profiles.gdm.databases = [ { settings."org/gnome/login-screen".disable-user-list = true; } ];
    };
  };
  services = {
    pulseaudio = {
      enable = false;
    };
    libinput = {
      enable = true;
      mouse = {
        middleEmulation = false;
        accelProfile = "flat";
        accelSpeed = "0.0";
      };
    };
    logind = {
      lidSwitch = "ignore";
    };
    openssh = {
      enable = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
    xserver = {
      enable = true;
      xkb.layout = "jp";
      videoDrivers = [ "nvidia" ];
      xrandrHeads = [
        {
          output = "DP-0";
          primary = true;
        }
        { output = "HDMI-0"; }
      ];
      desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = false;
        autoSuspend = false;
      };
      excludePackages = with pkgs; [ xterm ];
    };
    xrdp = {
      enable = true;
      openFirewall = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    };
    udev = {
      enable = true;
      packages = with pkgs; [ gnome-settings-daemon ];
    };
    gnome = {
      gnome-keyring.enable = true;
      gnome-remote-desktop.enable = true;
    };
    printing = {
      enable = true;
    };
    avahi = {
      enable = true;
    };
    prometheus = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = 9090;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [
            "systemd"
            "logind"
          ];
        };
        systemd.enable = true;
        nvidia-gpu.enable = true;
      };
      alertmanager = {
        enable = true;
        listenAddress = "";
        port = 9093;
        openFirewall = true;
        configuration = {
          route = {
            receiver = "null";
          };
          receivers = [
            { name = "null"; }
          ];
        };
      };
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
            }
          ];
        }
        {
          job_name = "systemd";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.systemd.port}" ];
            }
          ];
        }
        {
          job_name = "nvidia-gpu";
          static_configs = [
            {
              targets = [ "localhost:${toString config.services.prometheus.exporters.nvidia-gpu.port}" ];
            }
          ];
        }
      ];
    };
    cron = {
      enable = true;
      systemCronJobs = [
        "0 2 * * *	root	bash ${builtins.path { path = ./archive.sh; }}"
        "0 3 * * *	root	bash ${builtins.path { path = ./cleanup.sh; }}"
      ];
    };
  };
}
