;;;; interface
(setq inhibit-startup-message t)
(global-linum-mode t)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)

(use-package org
  :ensure org-plus-contrib
  )
;;; org bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

;;; try
(use-package try
  :ensure t
  )

;;; which
(use-package which-key
  :ensure t
  :config (which-key-mode)
  )

;;; ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
;;(defalias 'list-buffer 'ibuffer)
(defalias 'list-buffer 'ibuffer-other-window)

;;; tabbar
(use-package tabbar
  :ensure t
  :config
  (tabbar-mode 1))

;;;; window navigation
(winner-mode 1)
(windmove-default-keybindings)

;;; ace window
(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces ;; adjust the size of the  number tags
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

;;; ivy
(use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-style 'fancy))

;;; counsel
(use-package counsel
  :ensure t
  )

;;; swiper
(use-package swiper
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-load-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

;;; avy
(use-package avy
  :ensure t
  :bind (("M-s" . avy-goto-char)
	;;("C-'" . avy-goto-char-2)
	 ;;("M-g f" . avy-goto-line)
	 ;;("M-g w" . avy-goto-word-1)
	 ;;("M-g e" . avy-goto-word-0)
	 ))

;;; auto complete
(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

;;; company
  ;;(use-package company
  ;;  :ensure t
  ;;  :init
  ;;  (progn
  ;;    (global-company-mode t)
  ;;    ))
  ;;;; auto completion packages

;;;; themes

;;; color-theme
(use-package color-theme
  :ensure t
  )

;;; solarized
(use-package solarized
  :ensure solarized-theme
  :config ;;(load-theme 'solarized-dark t)
  )

;;; monokai
(use-package monokai-theme
  :ensure t
  :config (load-theme 'monokai t)
  )

;;;; htmlize  
(use-package htmlize
    :ensure t
    )

(use-package ox-reveal
  :ensure ox-reveal
  )

(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
(setq org-reveal-mathjax t)

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  )

(use-package jedi
  :ensure t
  :init
  (add-hook 'Python-mode-hook 'jedi::setup)
  (add-hook 'Python-mode-hook 'jedi::ac-setup)
  )
