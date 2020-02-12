{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        # System monitoring
        acpi
        inxi
        iotop
        lm_sensors
        powertop
        vnstat

        # X Utils
        wmctrl
        xautolock
        xbindkeys
        xbindkeys-config
        xdotool
        xorg.xbacklight
        xprintidle-ng
        xtrace

        # Command line tools
        fdupes
        inotify-tools
        pandoc
        parallel
        pdfgrep
        pdftk
        rclone
        ripgrep
        stow
        tmux
        zsh

        # Apps
        emacs
        firefox
        google-chrome
        vim
        vlc

        # Desktop Tools
        dmenu
        feh
        font-manager
        fontconfig
        fontconfig-penultimate
        gnome3.gnome-tweaks
        gparted
        i3lock
        meld
        networkmanager
        networkmanagerapplet
        pasystray
        pavucontrol
        rofi
        unclutter

        # Email
        notmuch
        offlineimap

        # Crypt
        cryfs
        gnupg20
        keepassxc
        pinentry

        # Misc
        fbterm
        sqlite
      ];
    };
  };
}
