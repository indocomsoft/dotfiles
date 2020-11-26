# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

with pkgs;
let
  my-python-packages = python-packages: with python-packages; [
    flake8
    mypy
    pandas
    pylint
    requests
    yapf
  ];
  python-with-my-packages = python38.withPackages my-python-packages;
  my-ruby-packages = ruby-packages: with ruby-packages; [
    rubocop
  ];
  ruby-with-my-packages = ruby_2_7.withPackages my-ruby-packages;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
    (self: super: {
      fluminurs = with pkgs;
        rustPlatform.buildRustPackage rec {
          name = "fluminurs-${version}";
          version = "d476b49ddbbfb306200bb10c27f2fd1e0a5bae7f";

          nativeBuildInputs = [
            cargo
            rustc
            pkgconfig
          ];

          buildInputs = [
            openssl
          ];

          src = fetchFromGitHub {
            owner = "indocomsoft";
            repo = "fluminurs";
            rev = version;
            sha256 = "049xjnkqf4qw2nz6p4wl99jv00afv863b99sx0b94ndmzplwrq6d";
          };

          cargoSha256 = "10hig3g8hqrrayybi2sxnfh5d4232v2als1jlws4pamjbpr67a32";

          meta = with stdenv.lib; {
            description = "Luminus api";
            homepage = https://github.com/indocomsoft/fluminurs;
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
    })
  ];

  nix = {
    nixPath = [
      "nixpkgs=/home/julius/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    gc.automatic = true;
    optimise.automatic = true;
    # keep tarball for 2 days
    extraOptions = ''
      tarball-ttl = 172800
    '';
  };

  hardware.cpu.intel.updateMicrocode = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot.tmpOnTmpfs = true;

  boot.supportedFilesystems = [ "zfs" ];
  services.zfs= {
    autoScrub = {
      enable = true;
      interval = "Sun, 02:00";
    };
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
      frequent = 4; # 15 minutes interval
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
    };
  };
  boot.initrd.kernelModules = [ "zfs" ];
  boot.postBootCommands = ''
    echo Importing all zfs zpool pools
    ${pkgs.zfs}/bin/zpool import -a -N
    echo Mounting all zfs filesystems
    ${pkgs.zfs}/bin/zfs mount -a
  '';

  networking.hostName = "julius-odroid-h2-nixos"; # Define your hostname.
  networking.hostId = "0d670bf5";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  nixpkgs.config.allowUnfree = true;

  services.fail2ban = {
    enable = true;
    bantime-increment = {
      enable = true;
    };
  };

  services.postgresql = {
    enable = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (lib.hiPrio pkgs.bashInteractive_5)
    aria2
    bazel
    bitwarden
    borgbackup
    cachix
    clang
    clang-tools
    cloc
    coreutils
    curl
    duplicacy
    # emacsGit
    erlang
    file
    fd
    ffmpeg
    firefox-devedition-bin
    fluminurs
    fzf
    gcc
    ghidra-bin
    git
    gitAndTools.gh
    gti
    gnucash
    gnumake
    google-chrome
    gparted
    htop
    i7z
    inetutils
    insync
    iperf3
    lame
    lsb-release
    lsof
    m4
    mbuffer
    neovim
    networkmanagerapplet
    nix-prefetch-github
    nmon
    nodejs_latest
    pandoc
    parallel
    parted
    perl
    pv
    python-with-my-packages
    smartmontools
    rdfind
    ripgrep
    ruby-with-my-packages
    s-tui
    screen
    sl
    tailscale
    texlive.combined.scheme-full
    universal-ctags
    unrar
    unzip
    vim
    vlc
    vscode
    wget
    yarn
    youtube-dl
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk14;
  };

  programs.thefuck.enable = true;
  programs.tmux.enable = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
  };

  services.tailscale.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 445 139 22 5201 3389 ];
  networking.firewall.allowedUDPPorts = [ 137 138 5201 3389 ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 60000; to = 61000; } # Allow mosh
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:escape";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.julius = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bashInteractive_5;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjupNLEV1H5WdOeVvqnNegbCOerCNVH/WXfsSzQP/fFm2kqPAefGRDDJlYhdma4nVMwmzFOYinRoZBWGhlhss32hQ0F3s7jptbm5pgnBICuhrJ3w9yU7xqiMK4ALVuv/QZK/u6/wmamZ6tEdrLp3zMCF8h3hO+kC3Df/BCMin2/AMpnnBk0al8jlL8Weq06msrPls00aj42eM8Xu8h6dTYm7XKOtDEuGWIfziH1bEtX2jjQoshPo5YrPLw+fOn4QmExAC8l+NoM30jYvlgeip8iHbfALlZaU5u7BCcjTGagDA7a84RASaVs/jQc/SwIkjJYJpJ9YTPkO3ujMdoZS/f indocomsoft@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9hNBuTcWCo0X7CV/1FJbXy5cjNIrUw+ctnNH5zLHTtcBwlArHSCBz+619rJhPP7Ly0YlsCe0dhDIMKLnxQNNcF0jNvTbjKZMG52Hew687mnSKm2Qvv0RfxjlxFdL5qaH0Mt64wVU9ybHBqOcPoLzoJNMjrhhHLA8g2e7/OJWws4FWGv/t2btQk1F2/XXWIgfljSr8FEthVYU3QbYKGrQlbdtbLVWSc20nC2I5hGQYqnvwS7KF/Ei5aUqQvZ4g1hAOFV2xOmvq840cf78gNGeHIjVrJ9IzYa0FIeUdZbqPfJpWfZ9Dc8Tj+hD2QPf/E1WipCYfmFk3oEZnTh8+ybOBDFqfOs+JNzC1RXZNl7ZA9m8DshC+edQD9Sd/x1JQHDktb+ohK0WCuqrH5J+odACbT+h8Sk1qGxjGpfSs4qYcoiqDt7opBfN/NRB/eVKHxjpR1+9jzoJSthzvNGDtveO1lESDkOe91OUZYShihhR3e9uUYnQYClW9mrrpV1cuY8yp/ym+QvGZYx3OxxZRNy8/7Zz+VsksbLHJ5zmxG1pnLBlmDGsi1jSmHFj7KJSigzmegkMu5uw0CTWl1NRgMTkPJN9uJG+XlgLdUY2/VfFydurEqP8jVyvAIeskLn38BeyP+Ru+hIEIsFLBFXNhOOp1hkWlixk1cQP+XCUW2ut5Cw== blink@ipad"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDc4tOZ5qT+hUwtujxwE8kIVFq9zL1SlunnsPt0lzfOj8Dr4TaMcTNyM15pat1nCe/IT90qmvUSluQgc3xfuDtrsHvlZj4gatu3Uxs3yXHV15fBPhnuJrjiSEcFtZCRUGdGJjf4iP3UTGKXYBKwgXdeI9K9+dGL7dfuKklLth7RuwCCO8Bq4HlfEwE4UvPMPRSMC4isFTc3CXSZwhjmovh3oSlkRMsi1+FZGeQj34i8v/q6v/6u+vB5rZE7KGKdX6+tCZWCVTonTSTpFBRu/Q5/bJZ39RjsSijOcXDjI/D9EqiRTF4VYS17wQ4UMfkjDOI8iS+OUSfPlWoQ544AxHjCR+58mCRF1tJJmnN82lYMLqXh/LCO6YEHphI4pSnqgw2c7ifci5ZHproZ/2mEdwcTkfDQbVDRYLAhqgGrY5ISOSbPnpiDLEatsyg30pTAnoXle/ysTp+JJ8ljUYaT1RqVTPan4q0z2qYUbe2/3uNfxEW7RcJezoDivUt+myj+VWDPSVCeFGlDXe9HPIJiHk5JRbc9ypdvoHiTdCj/q23xZ99I8K3MruvhGcHNisKfEQQUVuxi0Exzm1PS577i0Xp3gVUMuTQhIEA5Y57wtRqndvIsAEb0btWV6Vk+HgUQ7rXOj+K3eb81hsCh7xumoChn0zVDZ5UcPxGlq5Ubg9MGmQ=="
    ];
  };

  programs.bash.shellAliases = {
    v = "nvim";
  };

  programs.mosh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  fonts = {
    fontDir = { enable = true; };
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      iosevka
      libre-baskerville
      emacs-all-the-icons-fonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      etBook
      ia-writer-duospace
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
       monospace = [ "Source Code Pro" ];
       sansSerif = [ "Source Sans Pro" ];
       serif = [ "Source Serif Pro" ];
      };
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      netbios name = smbnix
      fruit:resource = xattr
      server min protocol = SMB2
    '';
    shares = {
      timemachine = {
        path = "/JULIUS4TB/timemachine";
        writeable = "yes";
        browseable = "yes";
        public = "no";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "create mask" = "0600";
        "directory mask" = "0700";
        "spotlight" = "yes";
      };
      julius4tb = {
        path = "/JULIUS4TB";
        writeable = "yes";
        browseable = "yes";
        public = "no";
        "create mask" = "0600";
        "directory mask" = "0700";
        spotlight = "yes";
      };
    };
  };

  services.fstrim.enable = true;

  systemd.services.blue = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    startLimitIntervalSec = 0;
    path = [ pkgs.openssh ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 10;
      User = "julius";
      ExecStart = "/home/julius/tunnel_ssh";
    };
  };
}
