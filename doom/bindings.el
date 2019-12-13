;;; ~/.doom.d/bindings.el -*- lexical-binding: t; -*-

(setq sa/local-bindings "~/.doom.d/bindings.local.el")
(if (file-readable-p sa/local-bindings)
    (load-file sa/local-bindings)
  (message "No local bindings found."))

;; Shortcuts for oft-used files.
(map! :leader :prefix ("F" . "File Bookmarks (Custom)."))
(map! :leader "F i" (lambda()
                      (interactive)
                      (find-file "~/mobile-notes/inbox.org")))
(map! :leader "F m" (lambda()
                      (interactive)
                      (find-file "~/mobile-notes/mobile.org")))
(map! :leader "F e" (lambda()
                      (interactive)
                      (find-file "~/mobile-notes/mail-inbox.org")))

;; add shortcut to search email.
(map! :leader "s e" #'counsel-notmuch)

(map! :leader :prefix ("e" . "email"))
(map! :leader "e e" #'notmuch)
(map! :leader "e j" #'notmuch-jump-search)

;; Search org files.
(map! :leader "/" #'sa/search-org-agenda-headings)

(provide 'bindings)
;;; bindings.el ends here
