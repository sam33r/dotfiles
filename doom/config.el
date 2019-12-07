;;; .doom.d/config.el --- Custom doom config.
;; Place your private configuration here

(setq sa/local-config "~/.doom.d/config.local.el")
(if (file-readable-p sa/local-config)
    (load-file sa/local-config)
  (message "No local config found."))

;; Enable opening encrypted files.
(epa-file-enable)
(setq epa-file-cache-passphrase-for-symmetric-encryption t)
(setq doom-theme 'doom-one-light)


;; ;; Org mode setup.

(defadvice org-agenda-quit
    (after close-agenda-quickview)
  (if (equal "agenda" (frame-parameter nil 'name))
      (delete-frame)))
(ad-activate 'org-agenda-quit)

;; Make the frame contain a single window. by default org-capture
;; splits the window.
;; (add-hook 'org-capture-mode-hook
;;           'delete-other-windows)

(defun sa/make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  ()
  (make-frame '((name . "capture")
                (width . 120)
                (height . 15)))
  (delete-frame)
  (select-frame-by-name "capture")
  (setq word-wrap 1)
  (setq truncate-lines nil)
  (org-capture))

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
  """Send message to notification."""
  (sa/local-shell-command (concat "notify-send --expire-time=30000 --icon=emacs \""
                                  headline-string
                                  "\" \""
                                  message-string
                                  "\"")))

(defun sa/orgmode ()
  (org-agenda)
  (delete-other-windows))

(defun sa/agenda (key)
  (make-frame '((name . "agenda")
                (width . 120)
                (height . 100)))
  (delete-frame)
  (select-frame-by-name "agenda")
  (org-agenda nil key)
  (delete-other-windows)

  ;; TODO: It's a bug that these following function calls are needed.
  (org-agenda-goto-today)
  (setq org-agenda-log-mode-items '(closed clock state))
  (org-agenda-log-mode)
  (org-agenda-log-mode)
  )

(defun sa/current ()
  (interactive)
  (when (display-graphic-p)
    (make-frame '((name . "current")
                  (width . 120)
                  (height . 100)))
    (delete-frame)
    (select-frame-by-name "current")
    (delete-other-windows)
    )
  (org-clock-goto)
  (org-tree-to-indirect-buffer)
  ;; (delete-window)
  (org-narrow-to-subtree)
  )

(defun sa/current-add-note ()
  (interactive)
  (when (display-graphic-p)
    (make-frame '((name . "current")
                  (width . 120)
                  (height . 100)))
    (delete-frame)
    (select-frame-by-name "current")
    (delete-other-windows))
  (org-clock-goto)
  (org-narrow-to-subtree)
  (org-add-note)
  )

(defun sa/task-clocked-time ()
  "Return a string with the clocked time and effort, if any."
  (interactive)
  (let* ((clocked-time (org-clock-get-clocked-time))
         (h (floor clocked-time 60))
         (m (- clocked-time (* 60 h)))
         (work-done-str (org-minutes-to-clocksum-string m)))
    (if org-clock-effort
        (let* ((effort-in-minutes
                (org-duration-string-to-minutes org-clock-effort))
               (effort-h (floor effort-in-minutes 60))
               (effort-m (- effort-in-minutes (* effort-h 60)))
               (effort-str (org-minutes-to-clocksum-string effort-m)))
          (format "[%s/%s (%s)" work-done-str effort-str org-clock-heading))
      (format "[%s : %s]" work-done-str org-clock-heading))))

(defun sa/clock-in ()
  (sa/local-shell-command "touch /tmp/org-clock-flag")
  (sa/notify "ORG CLOCK-IN" (sa/task-clocked-time)))

(defun sa/clock-out ()
  (sa/local-shell-command "rm -f /tmp/org-clock-flag")
  (sa/notify "ORG CLOCK-OUT" (sa/task-clocked-time)))

(defun sa/search-org-agenda-headings ()
  "Widen and search through all org-mode agenda buffers."
  (interactive)
  ;; This has the side-effect of widening all org-mode buffers.
  ;; The way I use org-mode, that is not an issue.
  (mapc (lambda (buffer)
          (when (eq 'org-mode (buffer-local-value 'major-mode buffer))
            (save-excursion
              (set-buffer buffer)
              (widen))))
        ;; (widen-buffer buffer))
        (buffer-list))
  (helm-org-rifle-agenda-files))


(defun sa/setup-org-mode (orgdir)
  """Setup org-mode configuration."""

  ;; Required org modules.
  (require 'org-checklist)
  (require 'org-contacts)
  (require 'org-expiry)
  (require 'org-inlinetask)
  ;;(require 'org-web-tools)

  (message (concat "Changing org dir to: " orgdir))
  (setq org-directory orgdir)

  ;; Remove the default doom-emacs behaviour of enabling line numbers,
  ;; only for text mode.
  (remove-hook! '(text-mode-hook) #'display-line-numbers-mode)
  ;; In org-agenda log show completed recurring tasks.
  ;; (setq org-agenda-log-mode-items '(closed clock state))

  ;; Agenda location
  (defun sa/set-org-agenda-files()
    (interactive)
    (setq sa/extra-org-files
          (split-string
           (shell-command-to-string
            "find -L ~/work-notes ~/mobile-notes -not -path '*/.*' -name '*.org' -o -name '*.org.gpg' 2> /dev/null"
            )
           "[\n]+"
           ))
    (setq org-agenda-files (append (list org-directory) sa/extra-org-files)))
  (sa/set-org-agenda-files)

  ;; TODO: Re-enable Elfeed Org.
  ;; (setq rmh-elfeed-org-files (list "~/mobile-notes/feeds.org"))
  ;; (elfeed-org)

  ;; Narrow to item when following.
  (advice-add 'org-agenda-goto :after
              (lambda (&rest args)
                (org-narrow-to-subtree)))

  ;; Allow creating new nodes when refiling.
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  (setq helm-org-rifle-close-unopened-file-buffers nil)
  ;; There seems to be a bug that hides the headline when path is shown.
  (setq helm-org-rifle-show-path nil)
  (setq helm-org-rifle-show-todo-keywords nil)

 ;; (setq org-contacts-files '("~/notes/people.org.gpg"))

  ;; Best-effort log CREATED timestamp.
  ;; Call (org-expiry-insert-created) to manually insert timestamps.
  (setq
   org-expiry-inactive-timestamps t
   org-expiry-created-property-name "CREATED")

  ;; Give up on aligning tags
  (setq org-tags-column 0)

  ;; Max width for inline images
  (setq org-image-actual-width 800)

  ;; Accept encrypted files.
  (setq org-agenda-file-regexp "\\`[^.].*\\.org\\.gpg\\'")

  ;; Don't subscript on encountering underscore.
  (setq org-use-sub-superscripts (quote {}))
  ;; Set location for sunrise/sunset.
  (setq calendar-latitude 37.774929)
  (setq calendar-longitude -122.419418)
  (setq calendar-location-name "San Francisco, CA")

  ;; Archive in a datetree.
  (setq org-archive-location (concat orgdir "/journal.org.gpg::datetree/* Finished Tasks"))

  ;; Keep inherited tags when archiving.
  (defadvice org-archive-subtree
      (before add-inherited-tags-before-org-archive-subtree activate)
    "add inherited tags before org-archive-subtree"
    (org-set-tags-to (org-get-tags-at)))
  (setq org-protocol-default-template-key "t")
  (defun sa/generate-bookmark-template ()
    (concat "* "
            (org-web-tools--org-link-for-url)
            " %^G\n%?\nBookmarked on %U"))
  (defun sa/generate-todo-link-template ()
    (concat "* TRIAGE %? %^G\n"
            (org-web-tools--org-link-for-url)))

  ;; Set up agenda custom commands.
  (setq org-agenda-custom-commands
        (quote
         (
          ("n" "Small Agenda"
           ((agenda "" nil)
            (tags-todo "+PRIORITY=\"A\"|PRIORITY=\"B\""
                       ((org-agenda-overriding-header "
Important"))))
           nil)
          ("N" "Comprehensive Agenda"
           ((agenda "" nil)
            (tags-todo "+PRIORITY=\"A\"|PRIORITY=\"B\""
                       ((org-agenda-overriding-header "
Important")))
            (todo "IN-PROGRESS"
                  ((org-agenda-overriding-header "
In-Progress Items")))
            (todo "NEXT"
                  ((org-agenda-overriding-header "
Unscheduled next items")
                   (org-agenda-skip-function
                    (quote
                     (org-agenda-skip-entry-if
                      (quote scheduled))))))
            (todo "TRIAGE"
                  ((org-agenda-overriding-header "
Items to Triage")))
            (todo "ICKY"
                  ((org-agenda-overriding-header "
Items to Breakdown")
                   (org-agenda-skip-function
                    (quote
                     (org-agenda-skip-entry-if
                      (quote scheduled))))))
            (todo "WAIT"
                  ((org-agenda-overriding-header "
Waiting on others")
                   (org-agenda-skip-function
                    (quote
                     (org-agenda-skip-entry-if
                      (quote scheduled))))))
            (tags-todo "+email+work"
                       ((org-agenda-overriding-header "
Work Email Tasks")
                        (org-agenda-skip-function
                         (quote
                          (org-agenda-skip-entry-if
                           (quote scheduled))))))
            (tags-todo "+email-work"
                       ((org-agenda-overriding-header "
Personal Email Tasks")
                        (org-agenda-skip-function
                         (quote
                          (org-agenda-skip-entry-if
                           (quote scheduled))))))
            (tags-todo "+people|+social"
                       ((org-agenda-overriding-header "
People")
                        (org-agenda-skip-function
                         (quote
                          (org-agenda-skip-entry-if
                           (quote scheduled))))))
            (tags-todo "+work"
                       ((org-agenda-overriding-header "
Unscheduled Work TODOs")
                        (org-agenda-skip-function
                         (quote
                          (org-agenda-skip-entry-if
                           (quote scheduled))))))
            (tags-todo "+refile"
                       ((org-agenda-overriding-header "
Items to Refile")))
            (tags-todo "-work-someday"
                       ((org-agenda-overriding-header "
Unscheduled Non-Work TODOs")
                        (org-agenda-skip-function
                         (quote
                          (org-agenda-skip-entry-if
                           (quote scheduled))))))
            (tags-todo "+fun"
                       ((org-agenda-max-entries 3)
                        (org-agenda-cmp-user-defined
                         (quote sa/org-random-cmp))
                        (org-agenda-sorting-strategy
                         (quote
                          (user-defined-up)))
                        (org-agenda-overriding-header "
Random fun items")
                        (org-agenda-skip-function
                         (quote
                          (org-agenda-skip-entry-if
                           (quote scheduled))))))
            (tags-todo "+someday"
                       ((org-agenda-max-entries 3)
                        (org-agenda-cmp-user-defined
                         (quote sa/org-random-cmp))
                        (org-agenda-sorting-strategy
                         (quote
                          (user-defined-up)))
                        (org-agenda-overriding-header "
Random someday items")
                        (org-agenda-skip-function
                         (quote
                          (org-agenda-skip-entry-if
                           (quote scheduled)))))))))))


  ;; Set up capture mode.
  (setq org-capture-templates
        '(
          ("t" "Todo" entry (file "~/mobile-notes/inbox.org")
           "* TRIAGE %? %^G\n%i\n%x\n")
          ("e" "Todo from email" entry (file "~/mobile-notes/inbox.org")
           "* TRIAGE %:subject %^G\n%?\n %i\n %a\n")
          ("l" "Todo from link" entry (file "~/mobile-notes/inbox.org")
           (function sa/generate-todo-link-template))
          ("b" "Bookmark" entry (file+headline "~/mobile-notes/mobile.org" "Bookmarks")
           (function sa/generate-bookmark-template)
           )
          ("B" "Manual Bookmark" entry (file+headline "~/mobile-notes/mobile.org" "Bookmarks")
           "* %? %^G\nBookmarked on %U"
           )
          ("j" "Journal" entry (file+olp+datetree "journal.org.gpg")
           "* %? :journal:\n%T\n%i\n")
          ("c" "Current Item" entry (file+olp+datetree "journal.org.gpg")
           "* %? %^G\n%i\n" :clock-in t :clock-keep t)
          ("d" "Journal: End of Day" entry (file+olp+datetree "journal.org.gpg")
           "* End of Day :end-of-day:\n%T\n** Three things about today\n\"
            - %^{first}\n- %^{second}\n- %^{third}\n\
            ** Rough plan for tomorrow\n%^{plan}"
           :immediate-finish t)
          ("Q" "Journal: Quote" entry (file+olp+datetree "journal.org.gpg")
           "* %^{title|A quote} :quote:\n%T\n#+BEGIN_QUOTE\n%x\n#+END_QUOTE\n%?\n")
          ("s" "Social Call" entry (file+olp+datetree "journal.org.gpg")
           "* %^{title} :social:\n%T\n%?\n")
          ;; ("F" "Code Reference to Current Task"
          ;;  plain (clock)
          ;;  "%(sa/org-capture-code-snippet \"%F\")"
          ;;  :empty-lines 1 :immediate-finish t)
          ;; ("f" "Code Reference with Comments to Current Task"
          ;;  plain (clock)
          ;;  "%(sa/org-capture-code-snippet \"%F\")\n\n   %?"
          ;;  :empty-lines 1)

          ("w" "Work")
          ("wt" "Work Todo" entry (file+headline "~/work-notes/work.org" "Unfiled Tasks")
           "* TRIAGE %? %^G\n%i\n%x\n")
          ("we" "Work Todo from email" entry (file+headline "~/work-notes/work.org" "Unfiled Tasks")
           "* TRIAGE %:subject %^G\n%?\n %i\n %a\n")
          ("wl" "Work Todo from link" entry (file+headline "~/work-notes/work.org" "Unfiled Tasks")
           (function sa/generate-todo-link-template))
          ("wj" "Work Journal" entry (file+olp+datetree "~/work-notes/work-journal.org")
           "* %^{title} %^G\n%T\n%?")
          ("wc" "Current Work Item" entry (file+olp+datetree "~/work-notes/work-journal.org")
           "* %? %^G\n%i\n" :clock-in t :clock-keep t)
          ("wm" "Meeting Notes" entry (file+olp+datetree "~/work-notes/work-journal.org")
           "* %^{meeting-title} :meeting:\n%T\n%?\n")

          ("m" "Mobile")
          ("me" "Errand" entry (file+headline "~/mobile-notes/mobile.org" "Errands")
           "* TODO %? %^G\n")
          ("mp" "Phone Call" entry (file+headline "~/mobile-notes/mobile.org" "Phone Calls")
           "* TODO %? %^G\n")

          )
        )
  (define-key global-map "\C-cc" 'org-capture)


  (setq org-agenda-file-regexp "\\`[^.].*\\.org\\.gpg\\'")
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-span (quote day))
  (setq org-agenda-start-with-log-mode (quote (closed clock)))
  (setq org-agenda-sticky nil)
  (setq org-agenda-window-setup (quote current-window))
  ;; (setq org-babel-load-languages
  ;;   (quote
  ;;    ((emacs-lisp . t)
  ;;     (shell . t)
  ;;     (python . t)
  ;;     (C . t)
  ;;     (sqlite . t)
  ;;     (js . t))))
  ;; (setq org-babel-shell-names
  ;;   (quote
  ;;    ("sh" "bash" "zsh" "run-in-tmux" "tsh" "ksh" "mksh" "posh")))
  (setq org-blank-before-new-entry (quote ((heading) (plain-list-item))))
  ;; (setq org-clock-out-remove-zero-time-clocks t)
  (setq org-confirm-babel-evaluate nil)
  (setq org-cycle-separator-lines 0)
  (setq org-default-priority ?C)
  ;; (setq org-export-with-section-numbers nil)
  ;; (setq org-export-with-toc nil)
  (setq org-habit-completed-glyph 42)
  (setq org-habit-graph-column 85)
  (setq org-habit-preceding-days 30)
  (setq org-habit-show-all-today nil)
  (setq org-habit-show-habits-only-for-today t)
  (setq org-hide-leading-stars t)
  (setq org-hierarchical-todo-statistics nil)
  (setq org-list-allow-alphabetical t)
  (setq org-log-into-drawer t)
  ;; (setq org-modules
  ;;   (quote
  ;;    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-inlinetask org-irc org-mhe org-mouse org-protocol org-rmail org-w3m org-checklist org-notify)))
  ;; (setq org-src-lang-modes
  ;;   (quote
  ;;    (("ocaml" . tuareg)
  ;;     ("elisp" . emacs-lisp)
  ;;     ("ditaa" . artist)
  ;;     ("asymptote" . asy)
  ;;     ("dot" . fundamental)
  ;;     ("sqlite" . sql)
  ;;     ("calc" . fundamental)
  ;;     ("C" . c)
  ;;     ("cpp" . c++)
  ;;     ("C++" . c++)
  ;;     ("screen" . shell-script)
  ;;     ("shell" . sh)
  ;;     ("bash" . sh)
  ;;     ("zsh" . sh)
  ;;     ("run-in-tmux" . sh))))
  (setq org-startup-truncated nil)
  (setq org-stuck-projects (quote ("+LEVEL=1/-DONE" ("NEXT") nil "")))
  (setq org-use-sub-superscripts (quote {}))

  ;; Publishing notes.
  (setq org-publish-project-alist
        `(("notes"
           :base-directory       ,orgdir
           :base-extension       any
           :publishing-directory "~/pub"
           :recursive            t
           :publishing-function  org-html-publish-to-html
           :auto-sitemap         t
           :sitemap-filename     "index.org"
           :sitemap-title        "Index"
           ;; This doesn't seem to work, disabling for now.
           ;; :sitemap-sort-folders 'last
           :sitemap-ignore-case  t
           :preserve-breaks t
           :section-numbers nil
           )))

  (evil-define-key '(normal visual motion) org-mode-map
    "H" 'outline-up-heading
    "J" 'outline-forward-same-level
    "K" 'outline-backward-same-level
    "L" 'org-down-element
    "Y" 'ox-clip-formatted-copy
    ;; "P" 'sa/paste-formatted-text-as-org
    )
  (define-key org-mode-map (kbd "RET")  #'sa/org-return)

  ;; TODO: Look-up the relevant binding for doom.
  ;; (spacemacs/set-leader-keys-for-major-mode 'org-mode
  ;;   ":"     'org-set-tags-command
  ;;   ";"     'org-set-tags-command)

  ;; Appearance
  (setq org-bullets-bullet-list '(" ")
        org-ellipsis " · "
        org-pretty-entities t
        org-hide-emphasis-markers t
        org-agenda-block-separator ""
        org-fontify-whole-heading-line t
        org-fontify-done-headline nil
        org-fontify-quote-and-verse-blocks t)
  (setf org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))

  ;; Setup refiling.
  (setq org-refile-use-outline-path t)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-targets
        '((org-agenda-files :todo . "PROJECT")))

  ;; Task tags
  (setq org-todo-keywords
        '((sequence "TRIAGE(a)" "PROJECT" "TODO(t)" "ICKY(i)" "NEXT(n!)" "WAIT(w@/!)" "IN-PROGRESS(p!)" "|" "DONE(d!)" "CANCELED(c@)")))
  (setq org-todo-keyword-faces
        '(("TRIAGE" . org-warning)
          ("TODO" . (:foreground "orange" :weight bold))
          ("ICKY" . org-warning)
          ("NEXT" . (:foreground "#c942ff" :weight bold))
          ("WAIT" .(:foreground "purple" :weight bold))
          ("CANCELED" . (:foreground "gray" :weight bold))
          ("PROJECT" . (:weight bold))
          ("DONE" . (:foreground "green" :weight bold))))

  (font-lock-add-keywords
   'org-mode `(("^\\*+ \\(TODO\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "•")
                          nil)))
               ("^\\*+ \\(TRIAGE\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "⚬")
                          nil)))
               ("^\\*+ \\(ICKY\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "☕")
                          nil)))
               ("^\\*+ \\(NEXT\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "⏩")
                          nil)))
               ("^\\*+ \\(WAIT\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "🤚")
                          nil)))
               ("^\\*+ \\(IN-PROGRESS\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "⯈")
                          nil)))
               ("^\\*+ \\(CANCELED\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "✘")
                          nil)))
               ("^\\*+ \\(DONE\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "✔")
                          nil)))
               ("^\\*+ \\(PROJECT\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "🕮")
                          nil)))
               ("^ *\\([-]\\) "
                (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "―"))))
               ))
  (add-hook 'org-mode-hook
            (lambda ()
              (push '("[ ]" .  "🞎") prettify-symbols-alist)
              (push '("[X]" . "🗹" ) prettify-symbols-alist)
              (push '("[-]" . "◫" ) prettify-symbols-alist)
              (prettify-symbols-mode)
              ))

  (defun sa/follow-tag-link (tag)
    "Display a list of TODO headlines with tag TAG.
With prefix argument, also display headlines without a TODO keyword."
    (org-tags-view (null current-prefix-arg) tag))

  (org-add-link-type "tag" 'sa/follow-tag-link)


  (setq doom-font (font-spec :family "Input" :size 18))
  (setq doom-variable-pitch-font (font-spec :family "Literata" :size 20))
  (let* ((headline `(:inherit default :weight normal :family "Literata")))
    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline :height 1.0))))
     `(org-level-7 ((t (,@headline :height 1.0))))
     `(org-level-6 ((t (,@headline :height 1.0))))
     `(org-level-5 ((t (,@headline :height 1.0))))
     `(org-level-4 ((t (,@headline :height 1.1))))
     `(org-level-3 ((t (,@headline :height 1.1))))
     `(org-level-2 ((t (,@headline :height 1.2))))
     `(org-level-1 ((t (,@headline :height 1.3))))
     `(org-document-title ((t (,@headline :height 1.6 :underline nil))))))

  ;; Hooks
  (add-hook 'org-clock-in-hook 'sa/clock-in)
  (add-hook 'org-clock-out-hook 'sa/clock-out)

  (add-to-list '+word-wrap-visual-modes 'org-mode)
  (add-hook 'org-mode-hook #'(lambda ()
                               ;;(adaptive-wrap-prefix-mode 1)
                               (auto-fill-mode -1)
                               (+word-wrap-mode)
                               (auto-revert-mode 1)
                               ;; (hidden-mode-line-mode)
                               (setq line-spacing 0.6)
                               ;; (turn-off-fci-mode)
                               (variable-pitch-mode t)
                               (visual-line-mode 1)
                               ))
  )
(sa/setup-org-mode "~/notes")

(load! "bindings")
