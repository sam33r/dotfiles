;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     yaml
     javascript
     go
     shell-scripts
     csv
     python
     c-c++
     html
     markdown
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     helm
     (auto-completion :variables
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-complete-with-key-sequence-delay 0.07
                      auto-completion-enable-help-tooltip t
                      )
     emacs-lisp
     git
     (org :variables
          org-enable-bootstrap-support t)
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     spell-checking
     syntax-checking
     (version-control :variables
                      version-control-diff-tool 'diff-hl
                      version-control-diff-side 'right)
     ycmd
     mu4e
     ;; Trial Layers:
     ;; Colorize variables and nyan cat
     (colors :variables
             )
     ;; fast access to dired (-)
     ;; vinegar
     ;; command log, toggle with ~SPC a L~
     ;; command-log
     ;; semantic layer: show function header while inside it, and support
     ;; common refactoring. (~SPC m r~ to refactor at point).
     ;; Disabling for now because the refactoring features don't work for
     ;; me and the always-visible-header is not that useful for me.
     semantic
     ;; Show file outline in a sidebar. Keybindings:
     ;; SPC b i	toggle imenu-list window
     ;; q	      quit imenu-list window
     ;; RET	    go to current entry
     ;; d	      display current entry, keep focus on imenu-list window
     ;; f	      fold/unfold current section
     imenu-list
     themes-megapack
     ;; Improves evil find bindings.
     ;; Adds keybinding s/S to search for two characters forward or backward
     ;; in the file.
     ;; I am also using it to add symbol groups for brackets. See
     ;; https://github.com/syl20bnr/spacemacs/tree/master/layers/%2Bvim/evil-snipe
     (evil-snipe :variables evil-snipe-enable-alternate-f-and-t-behaviors t)
     (elfeed :variables rmh-elfeed-org-files (list "~/n/feeds.org"))
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(
                                      writeroom-mode
                                      writegood-mode
                                      smtpmail
                                      keyfreq
                                      )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(mu4e-maildirs-extension)
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update t
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading t
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner nil
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists nil
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(dracula spacemacs-dark spacemacs-light ujelly tao-yin tao-yang)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Input"
                               :size 16
                               :weight normal
                               :width normal
                               :powerline-scale 1.0)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'right-then-bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 100
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'trailing
   ))


;; Custom functions.
(defun sa/notify (headline-string message-string)
  """Send message to notification"""
  (shell-command (concat "notify-send --expire-time=30000 --icon=emacs \""
                         headline-string
                         "\" \""
                         message-string
                         "\"")))

(defun sa/orgmode ()
  (org-agenda)
  (delete-other-windows))

(defun sa/todos ()
  ;; Pick which TODO type on load.
  (org-agenda nil "T")
  (delete-other-windows))

(defun sa/write ()
  (interactive)
  (turn-off-fci-mode)
  (spacemacs/toggle-fringe-off)
  (writeroom-mode t)
  (setq word-wrap t)
  (message "Activating writing mode"))

(defun sa/code ()
  (interactive)
  (fci-mode)
  (spacemacs/toggle-fringe-on)
  (message "Activating coding mode"))

(defun sa/shell-insert (command)
  "Run a shell command and insert output"
  (interactive "sCommand to run: ")
  (insert (shell-command-to-string command)))

(defun sa/shell-on-range-insert (command)
  "Run a shell command and insert output"
  (interactive "sCommand to run (prefixes any selected text): ")
  (insert (shell-command-to-string
           (concat command " " (buffer-substring (region-beginning) (region-end))))))

(defun sa/howdoi (command)
  "Run howdoi with user-input text"
  (interactive "sQuery: ")
  (setq sa-file-extension (file-name-extension (buffer-file-name)))
  (setq sa-lang "")
  (if (string-equal sa-file-extension "go") (setq sa-lang "golang"))
  (if (string-equal sa-file-extension "sh") (setq sa-lang "bash"))
  (if (string-equal sa-file-extension "py") (setq sa-lang "python"))
  (if (string-equal sa-file-extension "h") (setq sa-lang "c++"))
  (if (string-equal sa-file-extension "cc") (setq sa-lang "c++"))
  (insert (shell-command-to-string (concat "~/pyenv/bin/howdoi -n 3 " sa-lang " " command)))
  )

(defun sa/mail ()
  "Open emacs and run mu4e"
  (dotspacemacs/user-config)
  (mu4e))


;; Format C++ files on save.
(defun sa/formatcpponsave ()
  (interactive)
  (message "In before-hook")
  (when (eq major-mode 'c++-mode) (clang-format-buffer))
  )

(defun sa/clock-in ()
  (shell-command "touch /tmp/org-clock-flag")
  (sa/notify "ORG CLOCK-IN" "Org-mode clocking in"))

(defun sa/clock-out ()
  (shell-command "rm -f /tmp/org-clock-flag")
  (sa/notify "ORG CLOCK-OUT" "Org-mode clocking out"))



(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  ;; load mu4e from local build path.
  (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

  (setq-default git-magit-status-fullscreen t)
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."


  ;;
  ;; org-mode configuration.
  ;;

  ;; In org-agenda log show completed recurring tasks.
  (setq org-agenda-log-mode-items '(closed clock state))

  (setq org-agenda-files (list "~/n"))
  (require 'org-contacts)
  (setq org-contacts-files '("~/n/people.org.gpg"))

  ;; custom keybindings
  ;; (spacemacs/set-leader-keys-for-major-mode 'org-mode
  ;;   "k" 'org-backward-heading-same-level
  ;;   "j" 'org-forward-heading-same-level
  ;;   )
  (evil-define-key '(normal visual motion) org-mode-map
    "gh" 'outline-up-heading
    "gj" 'outline-forward-same-level
    "gk" 'outline-backward-same-level
    "gl" 'outline-next-visible-heading
    "gu" 'outline-previous-visible-heading)

  ;; Appearance
  (setq org-bullets-bullet-list '("•" "•" "•" "•")
        org-priority-faces '((65 :inherit org-priority :foreground "red")
                             (66 :inherit org-priority :foreground "brown")
                             (67 :inherit org-priority :foreground "blue"))
        org-ellipsis " ▼")
  ;; Setup refiling.
  (setq org-refile-use-outline-path t)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-targets
        '((nil :maxlevel . 3)
          (org-agenda-files :maxlevel . 2)))

  ;; Task tags
  (setq org-todo-keywords
        '((sequence "TODO(t)" "ICKY(i)" "NEXT(n!)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
  (setq org-todo-keyword-faces
        '(("TODO" . "orange") ("ICKY" . org-warning)
          ("NEXT" . (:foreground "orange" :weight bold))
          ("WAIT" .(:foreground "purple" :weight bold))
          ("CANCELED" . (:foreground "blue" :weight bold))
          ("DONE" . (:foreground "green" :weight bold))))
  ;; Capture mode.
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/n/refile.org.gpg" "Refile Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/n/journal.org.gpg")
           "* %?\nEntered on %U\n  %i")
          ))

  ;; Publishing notes.
  (setq org-publish-project-alist
        `(("notes"
           :base-directory       "~/n"
           :base-extension       "org"
           :publishing-directory "~/pub"
           :recursive            t
           :publishing-function  org-html-publish-to-html
           :auto-sitemap         t
           :sitemap-filename     "index.org"
           :sitemap-title        "Index"
           ;; This doesn't seem to work, disabling for now.
           ;; :sitemap-sort-folders 'last
           :sitemap-ignore-case  t
           )))
  (define-key global-map "\C-cc" 'org-capture)

  ;; Other misc org-mode settings.
  (setq org-startup-folded 'show-all)


  ;;
  ;; Hooks.
  ;;
  (add-hook 'before-save-hook 'sa/formatcpponsave)

  ;; Activate column indicator in prog-mode and text-mode, except for org-mode
  (add-hook 'prog-mode-hook 'fci-mode)
  (add-hook 'text-mode-hook 'fci-mode)
  (add-hook 'prog-mode-hook 'sa/code)
  (add-hook 'org-mode-hook 'turn-off-fci-mode 'append)
  (add-hook 'org-mode-hook 'sa/write 'append)

  ;; Activate writeroom mode for org-mode and markdown-mode
  (add-hook 'org-mode-hook 'writeroom-mode 'append)
  (add-hook 'markdown-mode-hook 'writeroom-mode 'append)

  ;; Add hooks for clocking-in and out.
  (add-hook 'org-clock-in-hook 'sa/clock-in)
  (add-hook 'org-clock-out-hook 'sa/clock-out)

  ;;
  ;; mu4e settings.
  ;;

  ;; References:
  ;; http://www.djcbsoftware.nl/code/mu/mu4e/Gmail-configuration.html
  ;; https://gist.github.com/areina/3879626
  ;; http://spacemacs.org/layers/+email/mu4e/README.html

  ;; This should be overridden by local config.
  (setq mu4e-get-mail-command "")

  ;; don't save message to Sent Messages, GMail/IMAP will take care of this
  (setq mu4e-sent-messages-behavior 'delete)

  ;; prefer html rendering by default.
  (setq mu4e-view-prefer-html t)

  (defun sa/mu4e-prefer-html ()
    "Prefer html formatting. Note that based on the email content, the
     actual view might not change."
    (interactive)
    (setq mu4e-view-prefer-html t)
    (mu4e-view-refresh))
  (defun sa/mu4e-prefer-text ()
    "Prefer html formatting. Note that based on the email content, the
     actual view might not change."
    (interactive)
    (setq mu4e-view-prefer-html nil)
    (mu4e-view-refresh))

  ;; convert html to text.
  ;; (setq mu4e-html2text-command 'mu4e-shr2text)
  ;; (setq mu4e-html2text-command "html2markdown --body-width=0 | sed \"s/&nbsp_place_holder;/ /g; /^$/d\"")
  ;; (setq mu4e-html2text-command "w3m -T text/html")
  ;; (setq mu4e-html2text-command "html2text -utf8")
  ;; (setq mu4e-html2text-command "pandoc -f html -t plain --normalize")

  (defadvice shr-colorize-region (before default-bg-color compile
                                         activate)
    "Use the default background color."
    (setq bg nil))

  ;; Use tab and shift tab to navigate links in email messages.
  (add-hook 'mu4e-view-mode-hook
            (lambda()
              (local-set-key (kbd "<tab>") 'shr-next-link)
              (local-set-key (kbd "<backtab>") 'shr-previous-link)))

  ;; don't keep message buffers around
  (setq message-kill-buffer-on-exit t)

  ;; Setup mu4e notifications.
  (setq mu4e-enable-notifications t)
  (with-eval-after-load 'mu4e-alert
    ;; Enable Desktop notifications
    (mu4e-alert-set-default-style 'notifications) ; For linux
    )
  (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
  (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)

  ;; Display images inline.
  (setq mu4e-view-show-images t)
  ;; use imagemagick, if available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  ;; Allow reflowing of emails.
  ;; https://www.djcbsoftware.nl/code/mu/mu4e/Writing-messages.html
  (setq mu4e-compose-format-flowed t)

  ;; Don't CC myself in sent emails.
  (setq mu4e-compose-keep-self-cc nil)

  ;;
  ;; Other spacemacs settings.
  ;;

  ;; Toggle menu bar on by default.
  ;; ~SPC t m~ to toggle at runtime.
  ;; (spacemacs/toggle-menu-bar-on)

  ;; Set up modeline.
  (spacemacs/toggle-mode-line-minor-modes-off)
  (spacemacs/toggle-mode-line-major-mode-off)
  (spacemacs/toggle-mode-line-org-clock-on)
  (spacemacs/toggle-display-time-on)
  (setq powerline-default-separator nil)

  ;; Centered cursor minor mode.
  (spacemacs/toggle-centered-point-globally-on)

  ;; j/k go to next visual line.
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  ;; keyfreq
  ;; http://blog.binchen.org/posts/how-to-be-extremely-efficient-in-emacs.html
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1)
  (setq keyfreq-excluded-commands
        '(self-insert-command))

  ;;
  ;; evil-shipe
  ;; See https://github.com/syl20bnr/spacemacs/tree/master/layers/%2Bvim/evil-snipe
  ;;

  (setq evil-snipe-scope 'buffer)
  ;; Alias [ and ] to all types of brackets
  (push '(?\[ "[[{(]") evil-snipe-aliases)
  (push '(?\] "[]})]") evil-snipe-aliases)

  ;; Turn off line numbers for org-mode. This causes weird slowdowns for large
  ;; org files.
  ;; (defun nolinum ()
  ;;   (interactive)
  ;;   (message "Deactivated linum mode")
  ;;   (global-linum-mode 0)
  ;;   (linum-mode 0)
  ;; )
  ;; (add-hook 'org-mode-hook 'nolinum)

  ;; Remove the ugly fringe tildes
  (spacemacs/toggle-vi-tilde-fringe-off)

  ;; Prefer splitting horizontally.
  (setq split-height-threshold nil)
  (setq split-width-threshold 80)

  ;; Use spaces for indent.
  (setq indent-tabs-mode nil)
  (setq tab-width 2)

  ;; Turn on word wrap
  (setq word-wrap t)

  ;; Enable auto-completion everywhere.
  (global-company-mode)

  ;; Use tmp for backups and autosave.
  (setq backup-directory-alist
        `((".*" . , "~/.emacs_backups")))
  (setq auto-save-file-name-transforms
        `((".*" ,temporary-file-directory t)))
  ;; Store many backups
  (setq delete-old-versions -1)
  (setq version-control t)
  (setq vc-make-backup-files t)
  ;; Keep history
  (setq savehist-file "~/.emacs_history")
  (savehist-mode 1)
  (setq history-length 1)
  (setq history-delete-duplicates t)
  (setq savehist-save-minibuffer-history 1)
  ;; Smarter frame title
  (setq-default frame-title-format '("%b (emacs)"))

  ;; Have some margins by default.
  (setq-default left-margin-width 1 right-margin-width 1)
  (set-window-buffer nil (current-buffer))

  ;; Custom keybindings.
  (spacemacs/declare-prefix "o" "custom-bindings")
  (evil-leader/set-key "ow" #'sa/write)
  (evil-leader/set-key "oc" #'sa/code)
  (evil-leader/set-key "oo" #'helm-semantic-or-imenu)
  (evil-leader/set-key "ou" #'org-dblock-update)
  (evil-leader/set-key "os" #'spacemacs/helm-swoop-region-or-symbol)
  (evil-leader/set-key "oS" #'spacemacs/helm-project-do-ag-region-or-symbol)
  (evil-leader/set-key "oi" #'sa/shell-insert)
  (evil-leader/set-key "oI" #'sa/shell-on-range-insert)
  (evil-leader/set-key "oh" #'sa/howdoi)

  ;; Experimental: Resume last helm command.
  (spacemacs/set-leader-keys "." 'helm-resume)

  ;; Allow pasting same string multiple times.
  ;; See: https://github.com/syl20bnr/spacemacs/blob/master/doc/FAQ.org
  (defun evil-paste-after-from-0 ()
    (interactive)
    (let ((evil-this-register ?0))
      (call-interactively 'evil-paste-after)))

  (define-key evil-visual-state-map "p" 'evil-paste-after-from-0)

  ;; load any local init.
  (load-file "~/.spacemacs.local")
  (dotspacemacs-local-init/init)
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(browse-url-browser-function (quote browse-url-chrome))
 '(compilation-error-regexp-alist
   (quote
    (google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google-blaze-error google-log-error google-log-warning google-log-info google-log-fatal-message google-forge-python gunit-stack-trace absoft ada aix ant bash borland python-tracebacks-and-caml comma cucumber msft edg-1 edg-2 epc ftnchek iar ibm irix java jikes-file maven jikes-line clang-include gcc-include ruby-Test::Unit gnu lcc makepp mips-1 mips-2 msft omake oracle perl php rxp sparc-pascal-file sparc-pascal-line sparc-pascal-example sun sun-ada watcom 4bsd gcov-file gcov-header gcov-nomark gcov-called-line gcov-never-called perl--Pod::Checker perl--Test perl--Test2 perl--Test::Harness weblint guile-file guile-line)))
 '(create-lockfiles nil)
 '(custom-safe-themes
   (quote
    ("63dd8ce36f352b92dbf4f80e912ac68216c1d7cf6ae98195e287fd7c7f7cb189" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(epa-file-cache-passphrase-for-symmetric-encryption t)
 '(evil-want-Y-yank-to-eol nil)
 '(global-vi-tilde-fringe-mode nil)
 '(golden-ratio-mode t)
 '(org-M-RET-may-split-line nil)
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda, next TODOs and all TODOs"
      ((agenda "" nil)
       (todo "NEXT")
       (todo "TODO"))
      nil))))
 '(org-agenda-file-regexp "\\`[^.].*\\.org\\.gpg\\'")
 '(org-agenda-prefix-format
   (quote
    ((agenda . " %i %-12:c%?-12t% s")
     (timeline . "  % s")
     (todo . " %i %-10:c %(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\") ")
     (tags . " %i %-10:c %(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\") ")
     (search . " %i %-12:c"))))
 '(org-agenda-span (quote week))
 '(org-agenda-sticky t)
 '(org-agenda-time-grid
   (quote
    ((daily weekly today require-timed)
     "----------------"
     (800 1000 1200 1400 1600 1800 2000))))
 '(org-agenda-window-setup (quote current-window))
 '(org-archive-location "~/n/archive.org.gpg::datetree/* Finished Tasks")
 '(org-blank-before-new-entry (quote ((heading . t) (plain-list-item . t))))
 '(org-habit-show-habits-only-for-today t)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-startup-truncated nil)
 '(org-stuck-projects (quote ("+LEVEL=1/-DONE" ("NEXT") nil "")))
 '(package-selected-packages
   (quote
    (let-alist evil-snipe keyfreq elfeed-web elfeed-org elfeed-goodies ace-jump-mode noflet elfeed solarized-theme madhat2r-theme yaml-mode winum powerline spinner insert-shebang parent-mode fuzzy flx fish-mode anzu evil goto-chg undo-tree diminish pkg-info epl company-shell packed pythonic f dash s avy async popup web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc company-tern dash-functional tern coffee-mode imenu-list stickyfunc-enhance srefactor rainbow-mode rainbow-identifiers command-log-mode color-identifiers-mode mu4e-maildirs-extension mu4e-alert ht sr-speedbar origami go-guru go-eldoc company-go go-mode sspacemacs-dark-theme flycheck-ycmd company-ycmd ycmd request-deferred deferred company-quickhelp disaster company-c-headers cmake-mode clang-format writegood-mode zonokai-theme zenburn-theme zen-and-art-theme underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme toxi-theme tao-theme tangotango-theme tango-plus-theme tango-2-theme sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme seti-theme reverse-theme railscasts-theme purple-haze-theme professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme pastels-on-dark-theme organic-green-theme omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme niflheim-theme naquadah-theme mustang-theme monokai-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme majapahit-theme lush-theme light-soap-theme jbeans-theme jazz-theme ir-black-theme inkpot-theme heroku-theme hemisu-theme hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme gandalf-theme flatui-theme flatland-theme firebelly-theme farmhouse-theme espresso-theme dracula-theme django-theme darktooth-theme autothemer darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized clues-theme cherry-blossom-theme busybee-theme bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes afternoon-theme visual-fill-column writeroom-mode bind-key iedit smartparens bind-map highlight markdown-mode projectile helm helm-core hydra csv-mode engine-mode git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter diff-hl ox-twbs gmail-message-mode ham-mode html-to-markdown edit-server xterm-color web-mode tagedit smeargle slim-mode shell-pop scss-mode sass-mode pug-mode orgit org-projectile org-present org org-pomodoro alert log4e gntp org-download multi-term magit-gitflow less-css-mode htmlize helm-gitignore helm-css-scss helm-company helm-c-yasnippet haml-mode gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck evil-magit magit magit-popup git-commit with-editor eshell-z eshell-prompt-extras esh-help emmet-mode company-web web-completion-data company-statistics company-anaconda company auto-yasnippet yasnippet auto-dictionary ac-ispell auto-complete yapfify ws-butler window-numbering which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spacemacs-theme spaceline restart-emacs request rainbow-delimiters quelpa pyvenv pytest pyenv-mode py-isort popwin pip-requirements persp-mode pcre2el paradox org-plus-contrib org-bullets open-junk-file neotree move-text mmm-mode markdown-toc macrostep lorem-ipsum live-py-mode linum-relative link-hint info+ indent-guide ido-vertical-mode hy-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio gh-md flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav dumb-jump define-word cython-mode column-enforce-mode clean-aindent-mode auto-highlight-symbol auto-compile anaconda-mode aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(py-indent-offset 2)
 '(python-indent-offset 2)
 '(sh-basic-offset 2)
 '(sh-indentation 2)
 '(spacemacs-theme-org-agenda-height nil)
 '(spacemacs-theme-org-height nil t)
 '(spacemacs-theme-org-highlight t)
 '(standard-indent 2)
 '(tab-stop-list (quote (2 4 6 8)))
 '(truncate-lines nil)
 '(vc-follow-symlinks t)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((type nil)) (:background "#000000" :foreground "#f8f8f2")) (((class color) (min-colors 89)) (:background "#282a36" :foreground "#f8f8f2")))))
