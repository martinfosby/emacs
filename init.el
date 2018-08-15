(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-safe-themes
   (quote
    ("8ed752276957903a270c797c4ab52931199806ccd9f0c3bb77f6f4b9e71b9272" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "5e52ce58f51827619d27131be3e3936593c9c7f9f9f9d6b33227be6331bf9881" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ede-project-directories
   (quote
    ("/home/martin/programming/c/The_C_Programming_Language/chapter1" "/home/martin/Dropbox/programming/c/The_C_Programming_Language/chapter1")))
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-directory "~/Dropbox/org")
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-startup-folded (quote overview))
 '(org-startup-indented t)
 '(package-selected-packages
   (quote
    (yasnippet-snippets prodigy emmet-mode elfeed-goodies elfeed better-shell virtualenvwrapper dumb-jump ag counsel-projectile projectile smartparens ggtags conkeror-minor-mode multiple-cursors iedit expand-region aggressive-indent aggresive-indent hungry-delete beacon evil-nerd-commenter evil-leader color-theme-sanityinc-tomorrow elpy chess python-mode jedi flycheck htmlize emacs-htmlize ox-reveal monokai-theme monokai elfeed-org org-edna org org-plus-contrib solarized-theme solarized-dark solarized zenburn-theme color-theme company auto-complete tabbar counsel swiper ace-window org-bullets which-key use-package try))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))


;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
  (setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			   ("gnu"       . "http://elpa.gnu.org/packages/")
			   ("melpa"     . "https://melpa.org/packages/")
			   ("marmalade" . "http://marmalade-repo.org/packages/"))))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;;; org babel
(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))
