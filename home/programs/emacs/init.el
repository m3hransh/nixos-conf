(eval-when-compile
  (require 'use-package))


(dolist (face '(fixed-pitch fixed-pitch-serif))
  (set-face-font face "Monospace"))
(set-face-attribute 'default nil :height 100)

(setq frame-title-format '("%b (%q) - Emacs " emacs-version))
(size-indication-mode)
(column-number-mode)
;; (scroll-bar-mode -1)
;; (horizontal-scroll-bar-mode -1)
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (tooltip-mode -1)


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


(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-i") 'imenu)
(global-set-key (kbd "M-Z") 'zap-up-to-char)
(global-set-key [remap list-buffers] 'ibuffer)

(fido-mode 1)

;; When finding file in non-existing directory, offer to create the
;; parent directory.

(use-package agda2-mode)





(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))


