{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  mercury = {
    # Enable the CA cert used for internal resources
    internalCertificateAuthority.enable = true;

    # Enable services required for MWB development (Postgres)
    mwbDevelopment.enable = true;

    # Enable the internal Nix cache
    nixCache.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  networking = {
    hostName = "jon-mercury";
    nameservers = [ "8.8.8.8" ];
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.sandbox = true;
    optimise.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    useXkbConfig = true;
  };

  users.users.jstrickland = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "video"
      "audio"
      "plugdev"
    ];
    shell = "${pkgs.zsh}/bin/zsh";
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth = {
      enable = true;
      settings = {
        General = {
          ControllerMode = "bredr";
        };
      };
    };
    ipu6 = {
      enable = true;
      platform = "ipu6ep";
    };
  };

  system.stateVersion = "23.11"; # do not change

  environment.systemPackages = with pkgs; [
    # system
    zsh
    zplug
    acpi
    man-pages
    man-pages-posix
    which
    file
    binutils
    moreutils
    # tracing
    bcc
    bpftrace
    btop
    # lock / screensaver
    xlockmore
    xscreensaver
    xwinwrap
    # screen
    light
    # screen capture
    peek
    # documents
    pandoc
    # sandboxing
    bubblewrap
    rsync
    pueue
    broot
    mdcat
    bat
    eza
    termdown
    # calculator
    fend
    # visualization
    visidata
    graphviz
    # shell
    tmux
    fd
    sd
    ripgrep
    fzf
    shellcheck
    direnv
    # network utils
    curl
    dnsutils
    dogdns
    whois
    openssl
    gnutls
    nethogs
    # terminal emulator
    kitty
    # fonts
    terminus_font
    terminus_font_ttf
    # json / yaml / xml
    jq
    yq
    xmlstarlet
    # nix
    nixfmt-rfc-style
    patchelf
    nix-prefetch-scripts
    # passwords
    (pass.withExtensions (ext: with ext; [ pass-otp ]))
    oath-toolkit
    # haskell
    haskellPackages.cabal-install
    ghc
    stack
    ormolu
    # file management
    unrar
    unzip
    p7zip
    zip
    du-dust
    nnn
    # audio
    pavucontrol
    pulsemixer
    alsa-utils
    # media
    mpv
    # music
    mpd
    mpdas
    ncmpcpp
    spotify
    # email
    isync
    notmuch
    # editors
    emacs
    neovim
    # web
    firefox
    google-chrome
    yt-dlp
    ddgr
    # perl6
    rakudo
    # rust
    rustup
    # coding
    entr
    tokei
    cloc
    hyperfine
    rtss
    sqlite
    # debugging
    lldb
    radare2
    # dhall
    dhall
    dhall-bash
    dhall-json
    # git
    git
    diff-so-fancy
    delta
    git-lfs
    gist
    gh
    # gaming
    sgt-puzzles
    qgo
    runelite
    openjdk11
    # window management
    rofi
    arandr
    nitrogen
    picom
    xmobar
    maim
    xclip
    # graphic design
    krita
    # python
    poetry
    black
    # typescript
    deno
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb.layout = "us";
      xkb.options = "caps:escape";
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = builtins.readFile ./xmonad.hs;
      };
    };
    udev.extraRules = ''
      # Rules for Oryx web flashing and live training
      KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
    '';
    openssh.enable = true;
    tailscale.enable = true;
    kolide-launcher.enable = true;
  };
}
