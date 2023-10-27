(eval-when-compile
  (require 'use-package))

(use-package bind-key)

(dolist (face '(fixed-pitch fixed-pitch-serif))
  (set-face-font face "Monospace"))
(set-face-attribute 'default nil :height 100)

(setq frame-title-format '("%b (%q) - Emacs " emacs-version))
(size-indication-mode)
(column-number-mode)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(setq inhibit-startup-screen t
      initial-major-mode 'org-mode
      initial-scratch-message nil)

(desktop-save-mode)
(setq desktop-load-locked-desktop 'check-pid
      desktop-save t)

(global-display-line-numbers-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq next-line-add-newlines t)
(setq require-final-newline t)
(setq-default tab-width 4
              indent-tabs-mode nil)

(put 'suspend-frame 'disabled t)
(put 'scroll-left 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq browse-url-browser-function 'browse-url-firefox)

(set-language-environment "UTF-8")
(setq default-input-method 'TeX
      calendar-week-start-day 1)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'visual-line-mode)
(setq blink-matching-paren nil)

(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-i") 'imenu)
(global-set-key (kbd "M-Z") 'zap-up-to-char)
(global-set-key [remap list-buffers] 'ibuffer)

(fido-mode 1)

;; When finding file in non-existing directory, offer to create the
;; parent directory.
(defun with-buffer-name-prompt-and-make-subdirs ()
  (let ((parent-directory (file-name-directory buffer-file-name)))
    (when (and (not (file-exists-p parent-directory))
               (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
      (make-directory parent-directory t))))

(add-to-list 'find-file-not-found-functions #'with-buffer-name-prompt-and-make-subdirs)

(setq-default xref-search-program 'ugrep
              grep-template "ugrep --color=always -0Iinr -e <R>")

(use-package calendar
  :config
  ;; taken from http://www.gnomon.org.uk/diary.html
  (setq calendar-latitude 54.0
        calendar-longitude -2.8
        calendar-location-name "Lancaster")
  (defun holiday-new-year-bank-holiday ()
    (let ((d (calendar-day-of-week (list 1 1 displayed-year))))
      (cond ((= d 0)
             `(((1 2 ,displayed-year) "New Year's Day Bank Holiday")))
            ((= d 6)
             `(((1 3 ,displayed-year) "New Year's Day Bank Holiday"))))))
  (defun holiday-christmas-bank-holidays ()
    (let ((d (calendar-day-of-week (list 12 25 displayed-year))))
      (cond ((= d 0)
             `(((12 27 ,displayed-year) "Christmas Day Bank Holiday")))
            ((= d 5)
             `(((12 28 ,displayed-year) "Boxing Day Bank Holiday")))
            ((= d 6)
             `(((12 27 ,displayed-year) "Boxing Day Bank Holiday")
               ((12 28 ,displayed-year) "Christmas Day Bank Holiday"))))))
  (dolist (type '(bahai christian general hebrew islamic oriental))
    (set (intern (format "holiday-%s-holidays" type)) nil))
  (setq holiday-other-holidays
        '((holiday-fixed 1 1 "New Year's Day")
          (holiday-new-year-bank-holiday)
          (holiday-fixed 1 25 "Burns Night")
          (holiday-easter-etc -47 "Shrove Tuesday")
          (holiday-easter-etc -21 "Mother's Day")
          (holiday-easter-etc -2 "Good Friday")
          (holiday-easter-etc 0 "Easter Sunday")
          (holiday-easter-etc 1 "Easter Monday")
          (holiday-float 5 1 1 "Early May Bank Holiday")
          (holiday-float 5 1 -1 "Spring Bank Holiday")
          (holiday-float 6 0 3 "Father's Day")
          (holiday-float 8 1 -1 "Summer Bank Holiday")
          (holiday-fixed 12 25 "Christmas Day")
          (holiday-fixed 12 26 "Boxing Day")
          (holiday-christmas-bank-holidays))))

(use-package server
  :unless noninteractive
  :no-require)

(use-package ido
  :init (setq ido-everywhere t
              ido-enable-flex-matching t
              ido-ignore-extensions t
              ido-use-filename-at-point 'guess
              ido-use-url-at-point t)
  :config (ido-mode))

(use-package smartparens
  :demand t
  :config
  (add-to-list 'sp-ignore-modes-list 'minibuffer-mode)
  (smartparens-global-strict-mode)
  (sp-use-smartparens-bindings)
  (sp-with-modes sp-lisp-modes
    (sp-local-pair "'" nil :actions nil)
    (sp-local-pair "`" nil :actions nil))
  :bind
  (:map smartparens-mode-map
        (")" . sp-up-sexp)
        ("]" . sp-up-sexp)
        ("}" . sp-up-sexp)))


(use-package toml-mode
  :mode "\\.toml\\'")

(use-package company
  :commands (company-mode company-indent-or-complete-common global-company-mode)
  :config (global-company-mode 1))
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))
(use-package eldoc
  :hook (prog-mode . eldoc-mode))

(use-package eglot
  :commands (eglot eglot-ensure)
  :config (defun disable-eglot-inlay-hints ()
            (when (eglot-managed-p) (eglot-inlay-hints-mode -1)))
  :hook (eglot-managed-mode . disable-eglot-inlay-hints)
  :bind ("C-c f" . eglot-format))

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(use-package markdown-mode
  :config (setq markdown-command '("pandoc" "--from=markdown" "--to=html5")))

(use-package tramp
  :config
  (add-to-list 'tramp-default-proxies-alist
               '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist
               '((regexp-quote (system-name)) nil nil)))

(use-package highlight-indentation
  :commands (highlight-indentation-mode highlight-indentation-current-column-mode))

(use-package yaml-mode
  :mode "\\.ya?ml\\'"
  :hook (yaml-mode . highlight-indentation-current-column-mode))

(use-package direnv
  :config (direnv-mode))

(use-package nix-mode
  :hook (nix-mode . eglot-ensure))

(use-package raku-mode)

(use-package bqn-mode)

(use-package zig-mode)

(use-package zoxide
  :config
  (defun add-dir-to-zoxide ()
    (when (file-directory-p default-directory) ; skip TRAMP directories
      (zoxide-add default-directory))))

(use-package eshell
  :after zoxide
  :config
  (add-hook 'eshell-directory-change-hook 'add-dir-to-zoxide)
  (defun eshell/z (query)
    (eshell/cd
     (if (file-accessible-directory-p query)
         query
       (car (zoxide-query-with query))))))

(defun disable-display-line-numbers ()
  (display-line-numbers-mode -1))

(use-package go-mode)

(use-package deadgrep
  :bind ("C-c r" . deadgrep))

(use-package elixir-mode)

(use-package haskell-mode)

(use-package slime
  :mode ("\\.lisp\\'" . lisp-mode)
  :config (setq inferior-lisp-program "sbcl"))

(use-package puppet-mode)

(defun kubeseal/get-metadata (meta)
  (with-output-to-string
    (call-process "yq" (buffer-file-name (current-buffer)) nil nil "--raw" (concat ".spec.template.metadata." meta))))
(defun kubeseal (start end name namespace scope)
  (interactive (list (region-beginning) (region-end)
                     (read-string "Secret name: ")
                     (read-string "Namespace: " "" nil (shell-command-to-string "yq"))
                     (completing-read "Scope: " '("strict" "namespace-wide" "cluster-wide") nil t nil nil "strict")))
  (call-process-region start end "kubeseal" 'delete t nil
                       "--raw"
                       "--name" (shell-quote-argument name)
                       "--namespace" (shell-quote-argument namespace)
                       "--scope" (shell-quote-argument scope)))


(use-package devil
  :config
  (dolist (seq (list "%k v" "%k m m v"))
    (add-to-list 'devil-repeatable-keys seq))
  :bind ("C-," . global-devil-mode))
(global-devil-mode 1)

(use-package fuel
  :commands (fuel-mode run-factor)
  :init (setq fuel-factor-root-dir "~/c/factor"))

(use-package tex
  :init
  (setq-default
   TeX-parse-self t
   TeX-engine 'luatex
   TeX-view-program-selection '((output-pdf "PDF Tools"))
   TeX-source-correlate-start-server t)
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

