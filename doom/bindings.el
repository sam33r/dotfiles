;;; ~/.doom.d/bindings.el -*- lexical-binding: t; -*-

(setq sa/local-bindings "~/.doom.d/bindings.local.el")
(if (file-readable-p sa/local-bindings)
    (load-file sa/local-bindings)
  (message "No local bindings found."))

;; Shortcuts for oft-used files.
(map! :leader "F i" (lambda()
                      (interactive)
                      (find-file "~/mobile-notes/inbox.org")))
(map! :leader "F m" (lambda()
                      (interactive)
                      (find-file "~/mobile-notes/mobile.org")))
(map! :leader "F e" (lambda()
                      (interactive)
                      (find-file "~/mobile-notes/mail-inbox.org")))

;; Search org files.
(map! :leader "/" #'sa/search-org-agenda-headings)

(provide 'bindings)
;;; bindings.el ends here
