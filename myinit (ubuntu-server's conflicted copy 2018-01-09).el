;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super) ; Left Windows key

(setq w32-pass-rwindow-to-system nil)
(setq w32-rwindow-modifier 'super) ; Right Windows key

(setq w32-pass-apps-to-system nil)
(setq w32-apps-modifier 'hyper) ; Menu/App key

(require 'server)

(unless (server-running-p)
  (server-start))

(use-package dash
  :ensure t)

(use-package dash-functional
  :ensure t)

;;;; interface
(setq inhibit-startup-message t)
(global-linum-mode t)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f5>") 'revert-buffer)

(setq delete-old-versions -1 )		; delete excess backup versions silently
(setq version-control t )		; use version control
(setq vc-make-backup-files t )		; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
(setq vc-follow-symlinks t )				       ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
(setq ring-bell-function 'ignore )	; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8 )	; use utf-8 by default
(setq coding-system-for-write 'utf-8 )
(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
(setq default-fill-column 80)		; toggle wrapping text at the 80th character

;;;; org 
(use-package org
  :ensure org-plus-contrib
  )
;;; org bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  )

;;; org capture settings
(custom-set-variables
 '(org-directory "~/Dropbox/org")
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-startup-folded (quote overview))
 '(org-startup-indented t)
 )

(setq org-file-apps
      (append '(
                ("\\.pdf\\'" . "evince %s")
                ) org-file-apps ))

(use-package org-ac
  :ensure t
  :init (progn
          (require 'org-ac)
          (org-ac/config-default)
          ))

(setq org-agenda-files (list
                        "~/Dropbox/org/gcal.org"
                        "~/Dropbox/org/i.org"
                        "~/Dropbox/org/schedule.org"
                        ))


(setq org-capture-templates
      '(("a" "Appointment" entry (file  "~/Dropbox/org/gcal.org")
         "* TODO %?\n:PROPERTIES:\n\n:END:\nDEADLINE: %^T \n %i\n")
        ("n" "Note" entry (file+headline "~/Dropbox/org/notes.org" "Notes")
         "* Note %?\n%T")
        ("l" "Link" entry (file+headline "~/Dropbox/org/links.org" "Links")
         "* %? %^L %^g \n%T" :prepend t)
        ("b" "Blog idea" entry (file+headline "~/Dropbox/org/i.org" "Blog Topics:")
         "* %?\n%T" :prepend t)
        ("t" "To Do Item" entry (file+headline "~/Dropbox/org/i.org" "To Do Items")
         "* %?\n%T" :prepend t)
        ("j" "Journal" entry (file+datetree "~/Dropbox/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("s" "Screencast" entry (file "~/Dropbox/org/screencastnotes.org")
         "* %?\n%i\n")))


(defadvice org-capture-finalize 
    (after delete-capture-frame activate)  
  "Advise capture-finalize to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
      (delete-frame)))

(defadvice org-capture-destroy 
    (after delete-capture-frame activate)  
  "Advise capture-destroy to close the frame"  
  (if (equal "capture" (frame-parameter nil 'name))  
      (delete-frame)))  

(use-package noflet
  :ensure t )
(defun make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")))
  (select-frame-by-name "capture")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
    (org-capture)))


(setq package-check-signature nil)


(use-package org-gcal
  :ensure t
  :config
  (setq org-gcal-client-id "32309848563-d4deg8d596atsmr8l019s6g1kabpko2b.apps.googleusercontent.com"
        org-gcal-client-secret "n5ky0Yh-1xOj9hfFN3hcChbv"
        org-gcal-file-alist '(("marfos19@gmail.com" .  "~/Dropbox/org/gcal.org"))))


(add-hook 'org-agenda-mode-hook (lambda () (org-gcal-sync) ))
(add-hook 'org-capture-after-finalize-hook (lambda () (org-gcal-sync) ))


(use-package calfw
  :ensure ;TODO: 
  :config
  (require 'calfw) 
  (require 'calfw-org)
  (setq cfw:org-overwrite-default-keybinding t)
  (require 'calfw-ical)

  (defun mycalendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      ;; (cfw:org-create-source "Green")  ; orgmode source
      (cfw:ical-create-source "gcal" "https://somecalnedaraddress" "IndianRed") ; devorah calender
      (cfw:ical-create-source "gcal" "https://anothercalendaraddress" "IndianRed") ; google calendar ICS
      ))) 
  (setq cfw:org-overwrite-default-keybinding t))

(use-package calfw-org
  :ensure t
  )
(use-package calfw-ical
  :ensure t
  )
(use-package calfw-gcal
  :ensure t
  :config
  (require 'calfw-gcal))

;;;; general lets you easily add keybinds


    ;;; This is where i define my keybinds
(use-package general
  :ensure t
  :config (progn
            ;; keybinds with no prefix
            (general-define-key
             "<f5>" 'revert-buffer
             "C-'" 'avy-goto-word-1
             "C-s" 'swiper             ; search for string in current buffer
             "M-x" 'counsel-M-x        ; replace default M-x with ivy backend
             "M-S" 'avy-goto-char      ; jumps to the char
             "M-y" 'counsel-yank-pop
             "C-=" 'er/expand-region
             "C--" 'er/contract-region
             "C-c m c" 'mc/edit-lines
             "C->" 'mc/mark-next-like-this
             "C-<" 'mc/mark-previous-like-this
             "C-'" 'better-shell-shell
             "C-|" 'better-shell-remote-open

             ;; evil related
             ;; "s-h" 'evil-window-left
             ;; "s-j" 'evil-window-down
             ;; "s-k" 'evil-window-left
             ;; "s-l" 'evil-window-right


             )

            ;; keymaps
            (general-define-key :keymaps 'ivy-minibuffer-map
                                "M-y" 'ivy-next-line
                                )

            (general-define-key :keymaps 'elfeed-search-mode-map
                                "q" 'bmj/elfeed-save-db-and-bury
                                "Q" 'bmj/elfeed-save-db-and-bury
                                "m" 'elfeed-toogle-star
                                "M" 'elfeed-toogle-star
                                "j" 'mz/make-and-run-elfeed-hydra
                                "J" 'mz/make-and-run-elfeed-hydra
                                )

            ;; C-c prefix commands
            (general-define-key :prefix "C-c"
                                ;; org mode related
                                "c"   'org-capture
                                "a"   'org-agenda

                                )
            ;; C-x prefix commands
            (general-define-key :prefix "C-x"
                                "b" 'ivy-switch-buffer
                                "C-b" 'ibuffer
                                )

            ;; SPACE prefix commands
            (general-define-key :states '(normal visual insert emacs)
                                :prefix "SPC"
                                :non-normal-prefix "C-SPC"

                                ;; simple command
                                "'"   '(iterm-focus :which-key "iterm")
                                "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
                                "/"   'counsel-ag
                                "TAB" '(switch-to-other-buffer :which-key "prev buffer")
                                "SPC" '(counsel-M-x  :which-key "M-x")

                                ;; bind to simple key press
                                "b"   'ivy-switch-buffer  ; change buffer, chose using ivy
                                "B"   'ibuffer'
                                "/"   'counsel-git-grep   ; find string in git project
                                ;; bind to double key press
                                "f"   '(:ignore t :which-key "files")
                                "ff"  'counsel-find-file
                                "fr"  'counsel-recentf
                                "p"   '(:ignore t :which-key "project")
                                "pf"  '(counsel-git :which-key "find file in git dir")

                                ;; Applications
                                "a" '(:ignore t :which-key "Applications")
                                "ar" 'ranger
                                "ad" 'dired

                                ;; evil related

                                )

            ;; normal extensions
            (general-define-key :states '(normal)
                                "=" 'evil-numbers/inc-at-pt
                                "-" 'evil-numbers/dec-at-pt

                                )

            ;; visual extensions
            (general-define-key :states '(visual)
                                "=" 'er/expand-region
                                "-" 'er/contract-region

                                ;; rectangles
                                ;; "gr" '(:ignore t :which-key "Rectangle")
                                ;; "grd" 'kill-rectangle
                                ;; "gry" 'copy-region-as-kill
                                ;; "grp" 'yank-rectangle
                                ;; "gr\"_d" 'delete-rectangle
                                ;; "gro" 'open-rectangle
                                ;; "grn" 'rectangle-number-lines
                                ;; "grca" 'clear-rectangle
                                ;; "grcw" 'delete-whitespace-rectangle
                                ;; "grci" 'string-rectangle
                                ;; "grI" 'string-insert-rectangle
                                ;; "grm" 'rectangle-mark-mode

                                )
            ))

;;;; evil


;; using evil-commentary instead 
     ;;; evil-nerd-commenter
;; (use-package evil-nerd-commenter
;;   :ensure t
;;   :config (progn
;; 	    ;; (evilnc-default-hotkeys)
;; 	    )
;;   )

;; using general instead of evil-leader
     ;;; evil-leader
;; (use-package evil-leader
;;   :ensure t
;;   :config (progn
;; 	    (global-evil-leader-mode)
;; 	    (evil-leader/set-leader "<SPC>")
;; 	    (evil-leader/set-key
;; 		   ;;; evil nerd commenter keys
;; 	      ;; "ci" 'evilnc-comment-or-uncomment-lines
;; 	      ;; "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
;; 	      ;; "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
;; 	      ;; "cc" 'evilnc-copy-and-comment-lines
;; 	      ;; "cp" 'evilnc-comment-or-uncomment-paragraphs
;; 	      ;; "cr" 'comment-or-uncomment-region
;; 	      ;; "cv" 'evilnc-toggle-invert-comment-line-by-line
;; 	      ;; "."  'evilnc-copy-and-comment-operator
;; 	      ;; "\\" 'evilnc-comment-operator ; if you prefer backslash key
;; 		 ;;; splitting windows keys
;; 	      "vs" 'split-window-right
;; 	      "hs" 'split-window-below
;; 	      )
;; 	    )  
;;   )

     ;;; evil commentary
(use-package evil-commentary
  :ensure t
  :config (progn
            (evil-commentary-mode)

            )
  )

  ;;; installing evil
(use-package evil
  :ensure t
  :init (progn
          )
  :config (progn
            (evil-mode 1)
            )
  )
     ;;; evil-surround
;; deletes, replace or adds surrounding characters
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

     ;;; evil-replace-with-register
;; allows replacing from the register
(use-package evil-replace-with-register
  :ensure t
  :init (progn
          ;; change default key bindings (if you want) HERE
          (setq evil-replace-with-register-key (kbd "gr"))
          (evil-replace-with-register-install)
          )
  )

(use-package evil-exchange
  :ensure t
  :config (progn
            (evil-exchange-install)
            )
  )

(use-package evil-anzu
  :ensure t
  )

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme))))

(use-package evil-numbers
  :ensure t
  )

(use-package evil-visualstar
  :ensure t
  :config (progn
            (global-evil-visualstar-mode)
            ;; (evil-visualstar/persistent t)
            )
  )


(use-package evil-indent-plus
  :ensure t
  :config (progn
            (define-key evil-inner-text-objects-map "i" 'evil-indent-plus-i-indent)
            (define-key evil-outer-text-objects-map "i" 'evil-indent-plus-a-indent)
            (define-key evil-inner-text-objects-map "I" 'evil-indent-plus-i-indent-up)
            (define-key evil-outer-text-objects-map "I" 'evil-indent-plus-a-indent-up)
            (define-key evil-inner-text-objects-map "J" 'evil-indent-plus-i-indent-up-down)
            (define-key evil-outer-text-objects-map "J" 'evil-indent-plus-a-indent-up-down)
            )
  )

(use-package evil-matchit
  :ensure t
  :config (progn
            (global-evil-matchit-mode 1)
            )
  )

(use-package evil-easymotion
  :ensure t
  :config (progn
            (evilem-default-keybindings ",")
            )
  )

(use-package evil-ediff
  :ensure t
  )

(use-package evil-magit
  :ensure t
  )

;; (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
;; (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
;; (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
;; (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)


;; (setq evil-search-module 'evil-search)
;; (setq evil-magic 'very-magic)

(setq evil-emacs-state-cursor '("blue" box))
(setq evil-motion-state-cursor '("orange" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

;;; which key describes keys after your press them
(use-package which-key
  :ensure t
  :config (progn
	    (which-key-mode)
	    )
  )

;;; try
(use-package try
  :ensure t
  )

;;; ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
;;(defalias 'list-buffer 'ibuffer)
(defalias 'list-buffer 'ibuffer-other-window)

;; ;;; tabbar
;; (use-package tabbar
;;   :ensure t
;;   :config
;;   (tabbar-mode 1))

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
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-style 'fancy)
  )

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
    ;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
    ;; (global-set-key (kbd "<f6>") 'ivy-resume)
    ;; (global-set-key (kbd "M-x") 'counsel-M-x)
    ;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    ;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    ;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    ;; (global-set-key (kbd "<f1> l") 'counsel-load-library)
    ;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    ;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    ;; (global-set-key (kbd "C-c g") 'counsel-git)
    ;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
    ;; (global-set-key (kbd "C-c k") 'counsel-ag)
    ;; (global-set-key (kbd "C-x l") 'counsel-locate)
    ;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    ;; (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

;;; avy
(use-package avy
  :ensure t
  :commands (avy-goto-word-1)
  :bind (
         ;; ("M-s" . avy-goto-char)
         ;;("C-'" . avy-goto-char-2)
         ;;("M-g f" . avy-goto-line)
         ;;("M-g w" . avy-goto-word-1)
         ;;("M-g e" . avy-goto-word-0)
         )
  )

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
  :config (progn
            ;; (setq solarized-scale-org-headlines nil)
            )
  )

    ;;; monokai
(use-package monokai-theme
  :ensure t
  )

    ;;; sanityinc-tomorrow
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  )


(use-package gruvbox-theme
  :ensure t
  )

(use-package moe-theme
  :ensure t
  )

(use-package noctilux-theme
  :ensure t
  )
  ;;; theme options
(load-theme 'moe-dark t)

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

;; tags for code navigation
(use-package ggtags
  :ensure t
  :config 
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
                (ggtags-mode 1))))
  (eval-after-load 'ggtags
    '(progn
       (evil-make-overriding-map ggtags-mode-map 'normal)
       ;; force update evil keymaps after ggtags-mode loaded
       (add-hook 'ggtags-mode-hook #'evil-normalize-keymaps)))
  )

(use-package smartparens
  :ensure t
  :config (progn
            (use-package smartparens-config)
            (use-package smartparens-html)
            (use-package smartparens-python)
            (use-package smartparens-latex)
            (smartparens-global-mode 1)
            (show-smartparens-global-mode t)
            )
  )

(use-package projectile
  :ensure t
  :config (progn
            (projectile-global-mode)
            (setq projectile-completion-system 'ivy)
            )
  )


(use-package counsel-projectile 
  :ensure t
  :config (progn
            counsel-projectile-mode
            )
  )  

(use-package ag
  :ensure t
  )

(use-package dumb-jump
  :ensure t
  :config (progn
            (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
            (dumb-jump-mode)

            )
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  )

;;;; python

  ;;; jedi
(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup)
  )

  ;;; elpy
(use-package elpy
  :ensure t
  :config
  (elpy-enable)
  )

(use-package virtualenvwrapper
  :ensure t
  :config
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell))

;;; yasnippet
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  )

(use-package undo-tree
  :ensure t
  :init
  (progn (global-undo-tree-mode t)
	 )
  )

(global-hl-line-mode t)

          ;;; beacon
;; highlights the cursor when scrolling
(use-package beacon
  :ensure t
  :config (progn
            (beacon-mode 1)
            ;;(setq beacon-color "#666600")
            )
  )

          ;;; hungry delete
;; deletes all the whitespace between text
(use-package hungry-delete
  :ensure t
  :config (progn
            (global-hungry-delete-mode)
            )
  )

          ;;; aggresive indent
(use-package aggressive-indent
  :ensure t
  :config (progn
            (global-aggressive-indent-mode 1)
            )
  )

          ;;; expand region
(use-package expand-region
  :ensure t
  )

;; saves the clipboard from other programs and combines them with emacs
(setq save-interprogram-paste-before-kill t) 

;; auto-reverting options
(global-auto-revert-mode 1) ; automatically revert the buffer if your lazy about loading changed  buffers
(setq auto-revert-verbose nil) ; don't display any messages when doing so

;;; iedit
(use-package iedit
  :ensure t
  )

    ;;; multiple cursors
;; multiple cursors let's you add more cursors
(use-package multiple-cursors
  :ensure t
  :config (progn
            ;; (global-set-key (kbd "C-c m c") 'mc/edit-lines)
            ;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
            ;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
            ;;(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
            )
  )

;;; changes keybinds from regular narrowing keybinds to just c-x n to narrow
;;; and widen
(defun narrow-or-widen-dwim (p)
  "widen if buffer is narrowed, narrow-dwim otherwise.
 dwim means: region, org-src-block, org-subtree, or
 defun, whichever applies first. narrowing to
 org-src-block actually calls `org-edit-src-code'.
 with prefix p, don't widen, just narrow even if buffer
 is already narrowed."
  (interactive "p")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (latex-narrow-to-environment))
        (t (narrow-to-defun))))

(define-key endless/toggle-map "n"
  #'narrow-or-widen-dwim)
;; This line actually replaces Emacs' entire narrowing
;; keymap, that's how much I like this command. Only
;; copy it if that's what you want.
(define-key ctl-x-map "n" #'narrow-or-widen-dwim)
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (define-key LaTeX-mode-map "\C-xn"
              nil))

(use-package web-mode
  :ensure t
:config
(add-to-list 'auto-mode-alist '("\\.html?\\" . web-mode))
(setq web-mode-engines-alist
      '(("django" . "\\.html\\'")))
(setq web-mode-ac-sources-alist
      '(("css" . (ac-source-css-property))
	("html" . (ac-source-words-in-buffer ac-source-abbrev))))
(setq web-mode-enable-auto-closing t)
(setq web-mode-enable-auto-quoting t)
)

(use-package better-shell
  :ensure t
  ;; :bind (("C-'" . better-shell-shell)
  ;; 	 ("C-;" . better-shell-remote-open))
  )

(setq elfeed-db-directory "~/Dropbox/shared/elfeeddb")

(use-package elfeed
  :ensure t
  )

(use-package elfeed-org
  :ensure t
  :config (progn
            (elfeed-org)
            (setq rmh-elfeed-org-files (list "~/Dropbox/shared/elfeed.org"))
            )
  )


(defun elfeed-mark-all-as-read ()
  (interactive)
  (mark-whole-buffer)
  (elfeed-search-untag-all-unread))

;;functions to support syncing .elfeed between machines
;;makes sure elfeed reads index from disk before launching
(defun bjm/elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed-db-load)
  (elfeed)
  (elfeed-search-update--force))

;;write to disk when quiting
(defun bjm/elfeed-save-db-and-bury ()
  "Wrapper to save the elfeed db to disk before burying buffer"
  (interactive)
  (elfeed-db-save)
  (quit-window))



(defalias 'elfeed-toggle-star
  (elfeed-expose #'elfeed-search-toggle-all 'star))

(use-package elfeed-goodies
  :ensure t
  :config
  (elfeed-goodies/setup))

(defhydra mz/hydra-elfeed ()
  "filter"
  ("c" (elfeed-search-set-filter "@6-months-ago +cs") "cs")
  ("e" (elfeed-search-set-filter "@6-months-ago +emacs") "emacs")
  ("d" (elfeed-search-set-filter "@6-months-ago +education") "education")
  ("*" (elfeed-search-set-filter "@6-months-ago +star") "Starred")
  ("M" elfeed-toggle-star "Mark")
  ("A" (elfeed-search-set-filter "@6-months-ago") "All")
  ("T" (elfeed-search-set-filter "@1-day-ago") "Today")
  ("Q" bjm/elfeed-save-db-and-bury "Quit Elfeed" :color blue)
  ("q" nil "quit" :color blue)
  )

(use-package hydra 
  :ensure t)

;; Hydra for modes that toggle on and off
(global-set-key
 (kbd "C-x t")
 (defhydra toggle (:color blue)
   "toggle"
   ("a" abbrev-mode "abbrev")
   ("s" flyspell-mode "flyspell")
   ("d" toggle-debug-on-error "debug")
   ("c" fci-mode "fCi")
   ("f" auto-fill-mode "fill")
   ("t" toggle-truncate-lines "truncate")
   ("w" whitespace-mode "whitespace")
   ("q" nil "cancel")))

;; Hydra for navigation
(global-set-key
 (kbd "C-x j")
 (defhydra gotoline 
   ( :pre (linum-mode 1)
          :post (linum-mode -1))
   "goto"
   ("t" (lambda () (interactive)(move-to-window-line-top-bottom 0)) "top")
   ("b" (lambda () (interactive)(move-to-window-line-top-bottom -1)) "bottom")
   ("m" (lambda () (interactive)(move-to-window-line-top-bottom)) "middle")
   ("e" (lambda () (interactive)(end-of-buffer)) "end")
   ("c" recenter-top-bottom "recenter")
   ("n" next-line "down")
   ("p" (lambda () (interactive) (forward-line -1))  "up")
   ("g" goto-line "goto-line")
   ))

;; Hydra for some org-mode stuff
(global-set-key
 (kbd "C-c t")
 (defhydra hydra-global-org (:color blue)
   "Org"
   ("t" org-timer-start "Start Timer")
   ("s" org-timer-stop "Stop Timer")
   ("r" org-timer-set-timer "Set Timer") ; This one requires you be in an orgmode doc, as it sets the timer for the header
   ("p" org-timer "Print Timer") ; output timer value to buffer
   ("w" (org-clock-in '(4)) "Clock-In") ; used with (org-clock-persistence-insinuate) (setq org-clock-persist t)
   ("o" org-clock-out "Clock-Out") ; you might also want (setq org-log-note-clock-out t)
   ("j" org-clock-goto "Clock Goto") ; global visit the clocked task
   ("c" org-capture "Capture") ; Don't forget to define the captures you want http://orgmode.org/manual/Capture.html
   ("l" (or )rg-capture-goto-last-stored "Last Capture")))

(defun z/hasCap (s) ""
       (let ((case-fold-search nil))
         (string-match-p "[[:upper:]]" s)
         ))


(defun z/get-hydra-option-key (s)
  "returns single upper case letter (converted to lower) or first"
  (interactive)
  (let ( (loc (z/hasCap s)))
    (if loc
        (downcase (substring s loc (+ loc 1)))
      (substring s 0 1)
      )))

(defun mz/make-elfeed-cats (tags)
  "Returns a list of lists. Each one is line for the hydra configuratio in the form
     (c function hint)"
  (interactive)
  (mapcar (lambda (tag)
            (let* (
                   (tagstring (symbol-name tag))
                   (c (z/get-hydra-option-key tagstring))
                   )
              (list c (append '(elfeed-search-set-filter) (list (format "@6-months-ago +%s" tagstring) ))tagstring  )))
          tags))

(defmacro mz/make-elfeed-hydra ()
  `(defhydra mz/hydra-elfeed ()
     "filter"
     ,@(mz/make-elfeed-cats (elfeed-db-get-all-tags))
     ("*" (elfeed-search-set-filter "@6-months-ago +star") "Starred")
     ("M" elfeed-toggle-star "Mark")
     ("A" (elfeed-search-set-filter "@6-months-ago") "All")
     ("T" (elfeed-search-set-filter "@1-day-ago") "Today")
     ("Q" bjm/elfeed-save-db-and-bury "Quit Elfeed" :color blue)
     ("q" nil "quit" :color blue)
     ))


(defun mz/make-and-run-elfeed-hydra ()
  ""
  (interactive)
  (mz/make-elfeed-hydra)
  (mz/hydra-elfeed/body))

;; (global-set-key (kbd "C-x C-b") 'ibuffer) ;; Use Ibuffer for Buffer List

(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("org" (name . "^.*org$"))
               ("web" (or (mode . web-mode) (mode . js2-mode)))
               ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
               ("mu4e" (name . "\*mu4e\*"))
               ("programming" (or
                               (mode . python-mode)
                               (mode . c++-mode)))
               ("emacs" (or
                         (name . "^\\*scratch\\*$")
                         (name . "^\\*Messages\\*$")))
               ))))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "default")))

;; don't show these
                                        ;(add-to-list 'ibuffer-never-show-predicates "zowie")
;; Don't show filter groups if there are no buffers in that group
(setq ibuffer-show-empty-filter-groups nil)

;; Don't ask for confirmation to delete marked buffers
(setq ibuffer-expert t)

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'web-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
  )

(use-package prodigy
  :ensure t
  :config (progn
            (prodigy-define-service
             :name "nikola"
             :command "nikola"
             :args '("auto")
             :cwd "/home/martin/github/martinfosby.github.io"
             :tags '(blog nikola)
             :stop-signal 'sigint
             :kill-process-buffer-on-stop t
             )))
