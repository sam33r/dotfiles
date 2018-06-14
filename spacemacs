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
     ;; Disabled in elisp because the combination is insufferable.
     ;; https://github.com/syl20bnr/spacemacs/issues/7038
     (semantic :disabled-for emacs-lisp)

     ;; Show file outline in a sidebar. Keybindings:
     ;; SPC b i	toggle imenu-list window
     ;; q	      quit imenu-list window
     ;; RET	    go to current entry
     ;; d	      display current entry, keep focus on imenu-list window
     ;; f	      fold/unfold current section
     imenu-list

     ;; Improves evil find bindings.
     ;; Adds keybinding s/S to search for two characters forward or backward
     ;; in the file.
     ;; I am also using it to add symbol groups for brackets. See
     ;; https://github.com/syl20bnr/spacemacs/tree/master/layers/%2Bvim/evil-snipe
     (evil-snipe :variables evil-snipe-enable-alternate-f-and-t-behaviors t)
     (elfeed :variables rmh-elfeed-org-files (list "~/feeds/feeds.org"))
     ;; twitter
     (shell :variables
            shell-default-shell 'eshell)
     ;; plantuml
     themes-megapack
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
                                      ox-clip
                                      shackle
                                      )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(
                                    mu4e-maildirs-extension
                                    org-projectile
                                    )
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
   dotspacemacs-themes '(zenburn solarized-dark solarized-light spacemacs-light tao-yin tao-yang dracula spacemacs-dark ujelly)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state nil
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
   dotspacemacs-which-key-position 'bottom
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

(defun sa/setup-org-mode (orgdir)
  """Setup org-mode configuration."""
  ;;
  ;; org-mode configuration.
  ;;

  ;; In org-agenda log show completed recurring tasks.
  (setq org-agenda-log-mode-items '(closed clock state))

  (message (concat "Changing org dir to: " orgdir))
  (setq org-directory orgdir)

  ;; Agenda location
  (setq org-agenda-files (list orgdir))
  (require 'org-contacts)
  ;; (setq org-contacts-files '("~/n/people.org.gpg"))
  ;; Archive in a datetree.
  (setq org-archive-location (concat orgdir "/shelved/archive.org.gpg::datetree/* Finished Tasks"))
  ;; Capture mode.
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "projects.org.gpg" "Refile Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+olp+datetree "journal.org.gpg")
           "* %?\nEntered on %U\n  %i")
          ))
  (define-key global-map "\C-cc" 'org-capture)
  ;; Publishing notes.
  (setq org-publish-project-alist
        `(("notes"
           :base-directory       orgdir
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
        ;; Other interesting characters are ▼, ↴, ⬎, ⤷, …, and ⤵.
        org-ellipsis "⤷")
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

  )

(defun sa/local-shell-command (command)
  """Run command in local machine's shell."""
  (let ((default-directory "~"))
    (shell-command command))
)

(defun sa/try-local-shell-command (command)
  """Run command in local machine's shell."""
  (interactive "sCommand: ")
  (sa/local-shell-command command)
)

(defun sa/notify (headline-string message-string)
  """Send message to notification"""
  (sa/local-shell-command (concat "notify-send --expire-time=30000 --icon=emacs \""
                         headline-string
                         "\" \""
                         message-string
                         "\"")))

(defun sa/orgmode ()
  (org-agenda)
  (delete-other-windows))

(defun sa/agenda ()
  ;; Org Agenda
  (org-agenda nil "n")
  (delete-other-windows))

(defun sa/todos ()
  ;; Pick which TODO type on load.
  (org-agenda nil "T")
  (delete-other-windows))

(defun sa/write ()
  (interactive)
  (turn-off-fci-mode)
  ;; (spacemacs/toggle-fringe-off)
  ;; (writeroom-mode t)
  (setq word-wrap t)
  (message "Activating writing mode"))

(defun sa/code ()
  (interactive)
  (fci-mode)
  (spacemacs/toggle-fringe-on)
  (message "Activating coding mode"))

(defun sa/read ()
  (interactive)
  (setq word-wrap t)
  (set-window-margins
   (car (get-buffer-window-list (current-buffer) nil t)) 24 24)
  (spacemacs/toggle-mode-line-off)
  (message "Activating reading mode"))

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
  (if (string-equal sa-file-extension "js") (setq sa-lang "javascript"))
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
  (sa/local-shell-command "touch /tmp/org-clock-flag")
  (sa/notify "ORG CLOCK-IN" "Org-mode clocking in"))

(defun sa/clock-out ()
  (sa/local-shell-command "rm -f /tmp/org-clock-flag")
  (sa/notify "ORG CLOCK-OUT" "Org-mode clocking out"))

(defun sa/switch-to-elfeed ()
  (interactive)
  (switch-to-buffer "*elfeed-entry*")
  )

(defun sa/org-todo-custom-date (&optional arg)
  "Like org-todo-yesterday, but prompt the user for a date. The time
of change will be 23:59 on that day"
  (interactive "P")
  (let* ((hour (nth 2 (decode-time
                       (org-current-time))))
         (daysback (- (date-to-day (current-time-string)) (org-time-string-to-absolute (org-read-date))))
         (org-extend-today-until (+ 1 (* 24 (- daysback 1)) hour))
         (org-use-effective-time t)) ; use the adjusted timestamp for logging
    (if (eq major-mode 'org-agenda-mode)
        (org-agenda-todo arg)
      (org-todo arg))))

(defun sa/startup()
  (dotspacemacs/sync-configuration-layers)
  (org-agenda nil "n")
  (delete-other-windows))

(defun sa/open-last-tmux-run()
  "Get results from the last run-in-tmux cell execution."
  (interactive)
  (find-file (car (last (directory-files "~/.run-tmux-sessions" 'full nil nil))))
  (delete-trailing-whitespace)
  )


;; Custom elfeed functions (to show date in headers)
;; See https://github.com/algernon/elfeed-goodies/issues/15

(defun elfeed-goodies/search-header-draw ()
  "Returns the string to be used as the Elfeed header."
  (if (zerop (elfeed-db-last-update))
      (elfeed-search--intro-header)
    (let* ((separator-left (intern (format "powerline-%s-%s"
                                           elfeed-goodies/powerline-default-separator
                                           (car powerline-default-separator-dir))))
           (separator-right (intern (format "powerline-%s-%s"
                                            elfeed-goodies/powerline-default-separator
                                            (cdr powerline-default-separator-dir))))
           (db-time (seconds-to-time (elfeed-db-last-update)))
           (stats (-elfeed/feed-stats))
           (search-filter (cond
                           (elfeed-search-filter-active
                            "")
                           (elfeed-search-filter
                            elfeed-search-filter)
                           (""))))
      (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
          (search-header/draw-wide separator-left separator-right search-filter stats db-time)
        (search-header/draw-tight separator-left separator-right search-filter stats db-time)))))

(defun elfeed-goodies/entry-line-draw (entry)
  "Print ENTRY to the buffer."

  (let* ((title (or (elfeed-meta entry :title) (elfeed-entry-title entry) ""))
         (date (elfeed-search-format-date (elfeed-entry-date entry)))
         (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
         (feed (elfeed-entry-feed entry))
         (feed-title
          (when feed
            (or (elfeed-meta feed :title) (elfeed-feed-title feed))))
         (tags (mapcar #'symbol-name (elfeed-entry-tags entry)))
         (tags-str (concat "[" (mapconcat 'identity tags ",") "]"))
         (title-width (- (window-width) elfeed-goodies/feed-source-column-width
                         elfeed-goodies/tag-column-width 4))
         (title-column (elfeed-format-column
                        title (elfeed-clamp
                               elfeed-search-title-min-width
                               title-width
                               title-width)
                        :left))
         (tag-column (elfeed-format-column
                      tags-str (elfeed-clamp (length tags-str)
                                             elfeed-goodies/tag-column-width
                                             elfeed-goodies/tag-column-width)
                      :left))
         (feed-column (elfeed-format-column
                       feed-title (elfeed-clamp elfeed-goodies/feed-source-column-width
                                                elfeed-goodies/feed-source-column-width
                                                elfeed-goodies/feed-source-column-width)
                       :left)))

    (if (>= (window-width) (* (frame-width) elfeed-goodies/wide-threshold))
        (progn
          (insert (propertize date 'face 'elfeed-search-date-face) " ")
          (insert (propertize feed-column 'face 'elfeed-search-feed-face) " ")
          (insert (propertize tag-column 'face 'elfeed-search-tag-face) " ")
          (insert (propertize title 'face title-faces 'kbd-help title)))
      (insert (propertize title 'face title-faces 'kbd-help title)))))

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

  ;; turn on yasnippets(?)
  (spacemacs/toggle-yasnippet-on)

  ;; Macros
  (fset 'sa-new-log-entry
   [?$ ?a escape ?a tab tab return ?* ?* ?  ?  escape ?, ?! return ?a ?\[ ?\] backspace ?/ ?\] M-return return ?\M-l escape])

  ;; Setup org-mode
  (sa/setup-org-mode "~/n")

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

  ;; Spaceline
  (custom-set-faces
   '(spaceline-highlight-face ((t (:foreground "dim gray" :background "gainsboro" )))))
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-default)

  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-buffer-encoding-abbrev-off)
  (spaceline-toggle-buffer-position-off)
  (spaceline-toggle-hud-off)

  ;; a bunch of hooks to disable mode-line. Blanked disable doesn't seem to
  ;; be working.
  ;; (add-hook 'text-mode-hook 'spacemacs/toggle-mode-line-off)
  ;; (add-hook 'prog-mode-hook 'spacemacs/toggle-mode-line-off)

  ;; Activate writeroom mode for org-mode and markdown-mode
  ;; (add-hook 'org-mode-hook 'writeroom-mode 'append)
  ;; (add-hook 'markdown-mode-hook 'writeroom-mode 'append)

  ;; Add hooks for clocking-in and out.
  (add-hook 'org-clock-in-hook 'sa/clock-in)
  (add-hook 'org-clock-out-hook 'sa/clock-out)

  ;; Twittering mode - cache auth
  (setq twittering-use-master-password t)

  ;; Disable emacs window management
  ;; See http://www.reflexivereflection.com/posts/2018-04-06-disabling-emacs-window-management.html
  (setq display-buffer-alist
        '(("shell.*" (display-buffer-same-window) ())
          (".*" (display-buffer-reuse-window
                 display-buffer-same-window
                 display-buffer-pop-up-frame)
           (reusable-frames . t))))
  (defun sa/same-window-instead
      (orig-fun buffer alist)
    (display-buffer-same-window buffer nil))
  (advice-add 'display-buffer-pop-up-window :around 'sa/same-window-instead)
  (defun sa/do-select-frame (orig-fun buffer &rest args)
    (let* ((old-frame (selected-frame))
           (window (apply orig-fun buffer args))
           (frame (window-frame window)))
      (unless (eq frame old-frame)
        (select-frame-set-input-focus frame))
      (select-window window)
      window))
  (advice-add 'display-buffer :around 'sa/do-select-frame)
  (setq frame-auto-hide-function 'delete-frame)
  (advice-add 'set-window-dedicated-p :around
              (lambda (orig-fun &rest args) nil))
  (setq org-agenda-window-setup 'current-window)



  ;;
  ;; mu4e settings.
  ;;


    (add-hook 'mu4e-headers-mode 'spacemacs/toggle-mode-line-off)
    (add-hook 'mu4e-main-mode 'spacemacs/toggle-mode-line-off)

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

 ;;; mu4e message view-in-chrome action
    (defun mu4e-msgv-action-view-in-chrome (msg)
      "View the body of the message in chrome."
      (interactive)
      (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
            (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
        (unless html (error "No html part for this message"))
        (with-temp-file tmpfile
          (insert
           "<html>"
           "<head><meta http-equiv=\"content-type\""
           "content=\"text/html;charset=UTF-8\">"
           html))
        (browse-url-chrome (concat "file://" tmpfile))))
    (add-to-list 'mu4e-view-actions
                 '("Chrome - View in Chrome" . mu4e-msgv-action-view-in-chrome) t)

    ;; convert html to text.
    ;; (setq mu4e-html2text-command 'mu4e-shr2text)
    ;; (setq mu4e-html2text-command "html2markdown --body-width=0 | sed \"s/&nbsp_place_holder;/ /g; /^$/d\"")
    ;; (setq mu4e-html2text-command "w3m -T text/html")
    ;; (setq mu4e-html2text-command "html2text -utf8")
    ;; (setq mu4e-html2text-command "pandoc -f html -t plain --normalize")


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

  (defadvice shr-colorize-region (before default-bg-color compile
                                         activate)
    "Use the default background color."
    (setq bg nil))
  ;; Toggle menu bar on by default.
  ;; ~SPC t m~ to toggle at runtime.
  ;; (spacemacs/toggle-menu-bar-on)

  ;; Set up modeline.
  (spacemacs/toggle-mode-line-minor-modes-off)
  (spacemacs/toggle-mode-line-major-mode-off)
  (spacemacs/toggle-mode-line-org-clock-off)
  (spacemacs/toggle-mode-line-point-position-off)
  (spacemacs/toggle-display-time-off)

  ;; disable modeline by default.
  ;; This doesn't work, of course.
  ;; (spacemacs/toggle-mode-line-off)

  (setq powerline-default-separator nil)

  ;; Centered cursor minor mode.
  ;; (spacemacs/toggle-centered-point-globally-on)

  ;; j/k go to next visual line.
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  ;; keyfreq
  ;; http://blog.binchen.org/posts/how-to-be-extremely-efficient-in-emacs.html
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1)
  (setq keyfreq-excluded-commands
        '(self-insert-command
          evil-next-visual-line
          evil-previous-visual-line
          evil-forward-char
          ))

  ;;
  ;; evil-shipe
  ;; See https://github.com/syl20bnr/spacemacs/tree/master/layers/%2Bvim/evil-snipe
  ;;

  (setq evil-snipe-scope 'buffer)
  ;; Alias [ and ] to all types of brackets
  (push '(?\[ "[[{(]") evil-snipe-aliases)
  (push '(?\] "[]})]") evil-snipe-aliases)

  ;; Not sure why, but jump forward doesn't work right in spacemacs.
  (define-key evil-normal-state-map (kbd "C-i") #'evil-jump-forward)

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
  (setq split-height-threshold 0)
  (setq split-width-threshold nil)

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
  (setq-default frame-title-format '("%b - emacs"))

  ;; Have some margins by default.
  (setq-default left-margin-width 1 right-margin-width 1)
  (set-window-buffer nil (current-buffer))

  ;; Never create windows.
  ;; (setq shackle-default-rule '(:same t))
  (shackle-mode)

  (spacemacs/toggle-evil-visual-mark-mode-on)

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
  (evil-leader/set-key "ob" #'helm-bookmarks)
  (evil-leader/set-key "oe" #'projectile-run-eshell)
  (evil-leader/set-key "or" #'sa/read)
  (evil-leader/set-key "ot" #'sa/open-last-tmux-run)

  (evil-leader/set-key "W" #'make-frame)

  ;; Eww browser keybindings

  (evil-leader/set-key "ae" #'eww)
  (evil-leader/set-key "aE" #'helm-google-suggest)

  (evil-define-key 'normal eww-mode-map
    "o" 'browse-web
    "O" 'helm-google-suggest
    "W" 'helm-wikipedia-suggest

    "Q" 'sa/switch-to-elfeed
    "q" 'delete-window

    "f" 'ace-link
    (kbd "C-j") 'shr-next-link
    (kbd "C-k") 'shr-previous-link

    "H" 'eww-back-url
    "L" 'eww-forward-url
    "r" 'eww-reload
    "R" 'eww-readable
    )

  (spacemacs/set-leader-keys-for-major-mode 'eww-mode
    "v"     'eww-browse-with-external-browser
    "a"     'eww-add-bookmark
    "U"     'eww-copy-page-url
    "u"    'eww-up-url
    "t"    'eww-top-url

    "h"     'eww-list-histories
    "B"     'eww-list-buffers
    "ba"    'eww-add-bookmark ;; also "a" in normal state
    "bl"    'eww-list-bookmarks
    "o"     'eww
    "s"     'eww-view-source
    "c"     'url-cookie-list)

  (dolist (mode '(eww-history-mode))
    (spacemacs/set-leader-keys-for-major-mode mode
      "f" 'eww-history-browse)
    (evil-define-key 'normal eww-history-mode-map "f" 'eww-history-browse
      "q" 'quit-window))
  (dolist (mode '(eww-bookmark-mode))
    (spacemacs/set-leader-keys-for-major-mode mode
      "x" 'eww-bookmark-kill
      "y" 'eww-bookmark-yank
      "f" 'eww-bookmark-browse)
    (evil-define-key 'normal eww-bookmark-mode-map
      "q" 'quit-window
      "f" 'eww-bookmark-browse
      "d" 'eww-bookmark-kill
      "y" 'eww-bookmark-yank))
  (dolist (mode '(eww-buffers-mode))
    (spacemacs/set-leader-keys-for-major-mode mode
      "f" 'eww-buffer-select
      "d" 'eww-buffer-kill
      "n" 'eww-buffer-show-next
      "p" 'eww-buffer-show-previous)
    (evil-define-key 'normal eww-buffers-mode-map
      "q" 'quit-window
      "f" 'eww-buffer-select
      "d" 'eww-buffer-kill
      "n" 'eww-buffer-show-next
      "p" 'eww-buffer-show-previous)
    )




  ;; Experimental: Resume last helm command.
  ;; (spacemacs/set-leader-keys "." 'helm-resume)

  ;; Hide modeline by default.

  ;; Allow pasting same string multiple times.
  ;; See: https://github.com/syl20bnr/spacemacs/blob/master/doc/FAQ.org
  (defun evil-paste-after-from-0 ()
    (interactive)
    (let ((evil-this-register ?0))
      (call-interactively 'evil-paste-after)))

  (define-key evil-visual-state-map "p" 'evil-paste-after-from-0)

  ;; Set default browser to eww.
  (setq browse-url-browser-function 'eww-browse-url)

  ;; Save all buffers anytime a buffer loses focus
  (defun save-all ()
    (interactive)
    (save-some-buffers t))
  (add-hook 'focus-out-hook 'save-all)
  ;; Also run on a timer, when using emacsclient via command line terminals.
  (run-with-timer 0 (* 10 60) 'save-all)

  ;; load any local init.
  (let ((sa-local-config "~/.spacemacs.local"))
    (if (file-exists-p sa-local-config)
        ((load-file sa-local-config)
         (dotspacemacs-local-init/init))
      (message "No local config found.")))
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
 '(compilation-error-regexp-alist
   (quote
    (google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google3-build-log-parser-info google3-build-log-parser-warning google3-build-log-parser-error google-blaze-error google-log-error google-log-warning google-log-info google-log-fatal-message google-forge-python gunit-stack-trace absoft ada aix ant bash borland python-tracebacks-and-caml comma cucumber msft edg-1 edg-2 epc ftnchek iar ibm irix java jikes-file maven jikes-line clang-include gcc-include ruby-Test::Unit gnu lcc makepp mips-1 mips-2 msft omake oracle perl php rxp sparc-pascal-file sparc-pascal-line sparc-pascal-example sun sun-ada watcom 4bsd gcov-file gcov-header gcov-nomark gcov-called-line gcov-never-called perl--Pod::Checker perl--Test perl--Test2 perl--Test::Harness weblint guile-file guile-line)))
 '(create-lockfiles nil)
 '(custom-safe-themes
   (quote
    ("63dd8ce36f352b92dbf4f80e912ac68216c1d7cf6ae98195e287fd7c7f7cb189" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(elfeed-goodies/entry-pane-position (quote right))
 '(elfeed-goodies/entry-pane-size 0.75)
 '(elfeed-goodies/show-mode-padding 30)
 '(elfeed-search-date-format (quote ("%Y-%m-%d" 10 :right)))
 '(epa-file-cache-passphrase-for-symmetric-encryption t)
 '(epa-pinentry-mode (quote loopback))
 '(evil-want-Y-yank-to-eol nil)
 '(global-vi-tilde-fringe-mode nil)
 '(line-spacing 0.1)
 '(mu4e-compose-dont-reply-to-self t)
 '(mu4e-headers-include-related nil)
 '(mu4e-headers-leave-behavior (quote apply))
 '(mu4e-headers-results-limit 5000)
 '(mu4e-headers-skip-duplicates t)
 '(mu4e-headers-visible-columns 0)
 '(mu4e-split-view (quote vertical))
 '(mu4e-view-show-addresses t)
 '(neo-window-fixed-size t)
 '(neo-window-width 40 t)
 '(org-M-RET-may-split-line nil)
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda and next TODOs"
      ((agenda "" nil)
       (todo "NEXT"))
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
 '(org-babel-shell-names
   (quote
    ("sh" "bash" "zsh" "run-in-tmux" "tsh" "ksh" "mksh" "posh")))
 '(org-blank-before-new-entry (quote ((heading . t) (plain-list-item . t))))
 '(org-confirm-babel-evaluate nil)
 '(org-cycle-separator-lines 0)
 '(org-habit-completed-glyph 42)
 '(org-habit-graph-column 85)
 '(org-habit-preceding-days 30)
 '(org-habit-show-all-today t)
 '(org-habit-show-habits-only-for-today t)
 '(org-hierarchical-todo-statistics nil)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-src-lang-modes
   (quote
    (("ocaml" . tuareg)
     ("elisp" . emacs-lisp)
     ("ditaa" . artist)
     ("asymptote" . asy)
     ("dot" . fundamental)
     ("sqlite" . sql)
     ("calc" . fundamental)
     ("C" . c)
     ("cpp" . c++)
     ("C++" . c++)
     ("screen" . shell-script)
     ("shell" . sh)
     ("bash" . sh)
     ("zsh" . sh)
     ("run-in-tmux" . sh))))
 '(org-startup-truncated nil)
 '(org-stuck-projects (quote ("+LEVEL=1/-DONE" ("NEXT") nil "")))
 '(package-selected-packages
   (quote
    (plantuml-mode shackle org-category-capture company-emacs-eclim eclim let-alist evil-snipe keyfreq elfeed-web elfeed-org elfeed-goodies ace-jump-mode noflet elfeed solarized-theme madhat2r-theme yaml-mode winum powerline spinner insert-shebang parent-mode fuzzy flx fish-mode anzu evil goto-chg undo-tree diminish pkg-info epl company-shell packed pythonic f dash s avy async popup web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc company-tern dash-functional tern coffee-mode imenu-list stickyfunc-enhance srefactor rainbow-mode rainbow-identifiers command-log-mode color-identifiers-mode mu4e-maildirs-extension mu4e-alert ht sr-speedbar origami go-guru go-eldoc company-go go-mode sspacemacs-dark-theme flycheck-ycmd company-ycmd ycmd request-deferred deferred company-quickhelp disaster company-c-headers cmake-mode clang-format writegood-mode zonokai-theme zenburn-theme zen-and-art-theme underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tronesque-theme toxi-theme tao-theme tangotango-theme tango-plus-theme tango-2-theme sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme seti-theme reverse-theme railscasts-theme purple-haze-theme professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme pastels-on-dark-theme organic-green-theme omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme niflheim-theme naquadah-theme mustang-theme monokai-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme majapahit-theme lush-theme light-soap-theme jbeans-theme jazz-theme ir-black-theme inkpot-theme heroku-theme hemisu-theme hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme gandalf-theme flatui-theme flatland-theme firebelly-theme farmhouse-theme espresso-theme dracula-theme django-theme darktooth-theme autothemer darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized clues-theme cherry-blossom-theme busybee-theme bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes afternoon-theme visual-fill-column writeroom-mode bind-key iedit smartparens bind-map highlight markdown-mode projectile helm helm-core hydra csv-mode engine-mode git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter diff-hl ox-twbs gmail-message-mode ham-mode html-to-markdown edit-server xterm-color web-mode tagedit smeargle slim-mode shell-pop scss-mode sass-mode pug-mode orgit org-projectile org-present org org-pomodoro alert log4e gntp org-download multi-term magit-gitflow less-css-mode htmlize helm-gitignore helm-css-scss helm-company helm-c-yasnippet haml-mode gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck evil-magit magit magit-popup git-commit with-editor eshell-z eshell-prompt-extras esh-help emmet-mode company-web web-completion-data company-statistics company-anaconda company auto-yasnippet yasnippet auto-dictionary ac-ispell auto-complete yapfify ws-butler window-numbering which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spacemacs-theme spaceline restart-emacs request rainbow-delimiters quelpa pyvenv pytest pyenv-mode py-isort popwin pip-requirements persp-mode pcre2el paradox org-plus-contrib org-bullets open-junk-file neotree move-text mmm-mode markdown-toc macrostep lorem-ipsum live-py-mode linum-relative link-hint info+ indent-guide ido-vertical-mode hy-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio gh-md flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav dumb-jump define-word cython-mode column-enforce-mode clean-aindent-mode auto-highlight-symbol auto-compile anaconda-mode aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(py-indent-offset 2)
 '(python-indent-offset 2)
 '(sh-basic-offset 2)
 '(sh-indentation 2)
 '(shackle-inhibit-window-quit-on-same-windows t)
 '(shr-external-browser (quote browse-url-chrome))
 '(shr-max-image-proportion 0.75)
 '(shr-width 80)
 '(spacemacs-theme-org-agenda-height nil)
 '(spacemacs-theme-org-height nil t)
 '(spacemacs-theme-org-highlight t)
 '(standard-indent 2)
 '(tab-stop-list (quote (2 4 6 8)))
 '(truncate-lines nil)
 '(twittering-fill-column 100)
 '(twittering-show-replied-tweets t)
 '(twittering-timer-interval 3600)
 '(vc-follow-symlinks t)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2)
 '(writeroom-border-width 20)
 '(writeroom-fullscreen-effect (quote maximized))
 '(writeroom-global-effects
   (quote
    (writeroom-set-alpha writeroom-set-menu-bar-lines writeroom-set-tool-bar-lines writeroom-set-vertical-scroll-bars writeroom-set-bottom-divider-width)))
 '(writeroom-width 100)
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
