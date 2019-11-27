;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)


(setq sa-local-packages "~/.doom.d/packages.local.el")
(if (file-readable-p sa-local-packages)
    (load-file sa-local-packages)
  (message "No local packages found."))

(package! org-web-tools)
(package! helm-org-rifle)
(package! memento-mori)

(provide 'packages)
;;; packages.el ends here
