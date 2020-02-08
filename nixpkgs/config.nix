{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        glibcLocales # For C locales issue.
        acpi
        autoconf-archive
        cryfs
        fbterm
        fdupes
        feh
        font-manager
        gcc
        gnome3.gnome-tweaks
        gnupg20
        google-chrome
        gparted
        inotify-tools
        inxi
        iotop
        keepassxc
        lm_sensors
        meld
        networkmanagerapplet
        networkmanager
        notmuch
        offlineimap
        pandoc
        parallel
        pasystray
        pavucontrol
        pdfgrep
        pdftk
        pinentry
        powertop
        rclone
        ripgrep
        rofi
        sqlite
        stow
        dmenu
        i3lock
        tmux
        unclutter
        vim
        vlc
        vnstat
        wmctrl
        xautolock
        xorg.xbacklight
        xbindkeys
        xbindkeys-config
        xdotool
        xprintidle-ng
        xtrace
        zsh
        firefox
        xorg.libX11  #for dwm.
      ];
    };
  };
}
