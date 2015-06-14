;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; package.el (with MELPA and local packages)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(setq package-enable-at-startup nil)
(eval-and-compile
  (mapc #'(lambda (path) (push (expand-file-name path user-emacs-directory) load-path))
        '("local" "local/use-package")))
(unless (file-exists-p package-user-dir)
  (package-refresh-contents))
(package-initialize)

;;; use-package init
(eval-when-compile
  (defvar use-package-verbose nil)
  (require 'use-package))
(require 'bind-key)
(require 'diminish nil t)

;;; editing and saving
(setq-default auto-save-default nil)
(setq-default indent-tabs-mode nil)
(setq-default make-backup-files nil)
(setq-default require-final-newline t)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;; interaction
(fset 'yes-or-no-p 'y-or-n-p)

;;; UI
(setq-default inhibit-startup-screen t)
(column-number-mode)

;;; global keybindings
(bind-key "C-\\" 'delete-trailing-whitespace)
(bind-key "C-x C-r" 'revert-buffer)
(bind-key "C-x C-k" 'server-edit)
(bind-key "M-s" 'shell-command)
(bind-key "C--" 'undo)

;; enable
(put 'downcase-region 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL THEMING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'color)

(if (not (window-system))
    ;;; tty mode, colors based on my modified Solarized palatte for iTerm2
    (progn
      (setq mytheme 'solarized-dark)
      (setq-default frame-background-mode 'dark)
      (menu-bar-mode -1)

      (set-face-attribute 'error nil :foreground "red" :weight 'bold)
      (set-face-attribute 'font-lock-builtin-face nil :foreground "blue")
      (set-face-attribute 'font-lock-comment-face nil :foreground "yellow")
      (set-face-attribute 'font-lock-constant-face nil :foreground "green")
      (set-face-attribute 'font-lock-function-name-face nil :foreground "blue")
      (set-face-attribute 'font-lock-keyword-face nil :foreground "cyan")
      (set-face-attribute 'font-lock-string-face nil :foreground "green")
      (set-face-attribute 'font-lock-type-face nil :foreground "cyan")
      (set-face-attribute 'font-lock-variable-name-face nil :foreground "brightred")
      (set-face-attribute 'region nil :background "brightcyan" :foreground "black"))

  ;;; window system mode
  (progn
    (setq mytheme 'default)
    (setq-default frame-background-mode 'light)

    ;; default face
    (set-face-attribute 'default nil
                        :family "Source Code Pro" :foundry "adobe"
                        :width 'normal :height 120
                        :weight 'normal :slant 'normal
                        :foreground "black" :distant-foreground "black" :background "white"
                        :underline nil :overline nil :strike-through nil :box nil :inverse-video nil
                        :stipple nil :inherit nil)
    ;; turn off antialiasing
    ;(setq-default mac-allow-anti-aliasing nil)

    ;; change font for Chinese fontset (han)
    (set-fontset-font "fontset-default" 'han "STSong")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun indent-and-newline-and-indent ()
  "Correct indentation of current line, insert newline, and indent the new line."
  (interactive)
  (indent-for-tab-command)
  (newline-and-indent))

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BASIC MAJOR MODES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package prog-mode
  :preface
  (defun my-prog-mode-hook ()
    (condition-case nil
        (auto-complete-mode 1)
      (error nil))
    (hs-minor-mode 1)
    (setq-default fill-column 79)
    (bind-key "RET" 'indent-and-newline-and-indent prog-mode-map))

  :config
  (add-hook 'prog-mode-hook 'my-prog-mode-hook))

;;; text-mode (which doesn't a feature, so can't use use-package with it)
(defun my-text-mode-hook ()
  (abbrev-mode 1))
(add-hook 'text-mode-hook 'my-text-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BUILTIN PACKAGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package abbrev :commands abbrev-mode :diminish abbrev-mode :config
  (setq abbrev-file-name (expand-file-name "local/abbrev_defs" user-emacs-directory))
  (if (file-exists-p abbrev-file-name) (quietly-read-abbrev-file)))

(use-package cc-mode
  :preface
  (defun my-c-mode-common-hook ()
    (auto-fill-mode 1)
    (setq-default c-basic-offset 4)
    (unless (keymap-parent c-mode-base-map)
      (set-keymap-parent c-mode-base-map prog-mode-map)))

  :config
  (add-hook 'c-mode-common-hook 'my-c-mode-common-hook))

(use-package cperl-mode :mode "\\.pl\\'" :interpreter "perl" :config
  (setq-default cperl-indent-level 4)
  (if (equal mytheme 'solarized-dark)
      (progn
        (set-face-attribute 'cperl-array-face nil :foreground "red" :background "default" :weight 'bold :slant 'normal)
        (set-face-attribute 'cperl-hash-face nil :foreground "red" :background "default" :weight 'bold :slant 'normal)
        (set-face-attribute 'cperl-nonoverridable-face nil :foreground "cyan"))))

(use-package diff-mode :defer t :config
  (if (equal mytheme 'solarized-dark)
      (progn
        (set-face-attribute 'diff-header nil :foreground "default" :background "default")
        (set-face-attribute 'diff-file-header nil :inherit 'diff-header :background 'unspecified))))

(use-package hideshow :commands hs-minor-mode :diminish hs-minor-mode)

(use-package ido-mode :defer 0
  :init
  (ido-mode)
  (ido-everywhere 1)
  (setq ido-enable-flex-matching t)
  (setq ido-enable-last-directory-history nil))

(use-package make-mode :mode ("\\Makefile\\'" . makefile-mode) :config
  (if (equal mytheme 'solarized-dark)
      (set-face-attribute 'makefile-space nil :background "magenta")))

(use-package python :mode ("\\.py\\'" . python-mode) :interpreter ("python" . python-mode)
  :preface
  (defun my-python-mode-hook ()
    (setq-default fill-column 72)
    ;; Python's lack of braces or ends makes it hard to deduce indentation automatically
    (bind-key "RET" 'newline-and-indent python-mode-map)
    ;; jedi
    (setq-default jedi:complete-on-dot t)
    (setq-default jedi:environment-root "default")
    (jedi:setup))

  :config
  (add-hook 'python-mode-hook 'my-python-mode-hook))

(use-package ruby-mode :mode "\\.rb\\'" :interpreter "ruby")

(use-package sh-script :mode ("\\(\\.zsh\\|/_[^/]*\\)\\'" . sh-mode) :config
  (if (equal mytheme 'solarized-dark)
      (progn
        (set-face-attribute 'sh-heredoc nil :foreground "brightyellow" :weight 'regular)
        (set-face-attribute 'sh-quoted-exec nil :foreground "red"))))

(use-package vc-hooks :init (setq vc-follow-symlinks t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PACKAGE.EL PACKAGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ace-jump-mode :ensure t :bind ("M-h" . ace-jump-mode))

(use-package adoc-mode :ensure t :mode "\\.adoc\\'")

(use-package tex-site :ensure auctex :mode ("\\.tex\\'" . LaTeX-mode)
  :preface
  (defun LaTeX-insert-display-math ()
    "Insert a \\=\\[ \\] block for display math."
    (interactive)
    (insert "\\[")
    (indent-for-tab-command)
    (newline-and-indent)
    (newline-and-indent)
    (insert "\\]")
    (indent-for-tab-command)
    (previous-line)
    (indent-for-tab-command))

  (defun my-TeX-mode-hook ()
    (TeX-fold-mode 1)
    (auto-fill-mode 1)
    (setq-default TeX-PDF-mode t)
    (setq-default TeX-auto-local "~/.cache/auctex/auto")
    (setq-default TeX-auto-save t)
    (setq-default TeX-parse-self t)
    (bind-key "RET" 'indent-and-newline-and-indent TeX-mode-map))

  (defun my-LaTeX-mode-hook ()
    (setq-default LaTeX-default-environment "proof")
    ;; http://tex.stackexchange.com/a/124259/24333
    (setq-default LaTeX-command-style '(("" "%(PDF)%(latex) -file-line-error %S%(PDFout)")))
    (bind-key "C-t" 'LaTeX-insert-display-math LaTeX-mode-map)

    ;; preview-latex
    (setq-default preview-auto-cache-preamble t)
    (eval-after-load "preview"
      '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzcd}" t)))

  :config
  (add-hook 'TeX-mode-hook 'my-TeX-mode-hook)
  (add-hook 'LaTeX-mode-hook 'my-LaTeX-mode-hook)
  (if (equal mytheme 'solarized-dark)
      (eval-after-load 'font-latex
        '(progn
           (set-face-attribute 'font-latex-math-face nil :foreground "green")
           (set-face-attribute 'font-latex-sedate-face nil :foreground "cyan")
           (set-face-attribute 'font-latex-verbatim-face nil :foreground "white")))))

(use-package auto-complete :ensure t :commands auto-complete-mode :diminish auto-complete-mode)

(use-package crontab-mode :ensure t :mode "/crontab\\(\\.[^/]*\\)?\\'")

(use-package diminish :ensure t)

(use-package fiplr :ensure t :commands (fiplr-find-file fiplr-find-directory)
  :bind (("C-x f" . fiplr-find-file) ("C-x d" . fiplr-find-directory))
  :preface
  (setq fiplr-ignored-globs
        '((directories (".git" ".svn" ".tox" "build"))
          (files ("*.jpg" "*.o" "*.png" "*.pyc")))))

(use-package git-commit-mode :ensure t :defer t :config
  (if (equal mytheme 'solarized-dark)
      (set-face-attribute 'git-commit-summary-face nil :foreground "blue")))

(use-package go-mode :ensure t :mode "\\.go\\'")

(use-package jedi :ensure t :defer t)

(use-package magit :ensure t :defer 0 :diminish magit-auto-revert-mode
  :bind ("M-m" . magit-status)
  :init
  (setq magit-last-seen-setup-instructions "1.4.0"))

(use-package markdown-mode :ensure t :mode ("\\.md\\'" . gfm-mode) :config
  (add-hook 'gfm-mode-hook 'abbrev-mode))

(use-package markup-faces :ensure t :defer t :config
  (if (equal mytheme 'solarized-dark)
      (progn
        (set-face-attribute 'markup-meta-face nil :foreground "green")
        (set-face-attribute 'markup-meta-hide-face nil :foreground "brightgreen")
        (set-face-attribute 'markup-reference-face nil :foreground "green")
        (set-face-attribute 'markup-secondary-text-face nil :foreground "yellow")
        (set-face-attribute 'markup-strong-face nil :foreground "red" :weight 'bold)
        (set-face-attribute 'markup-title-0-face nil :foreground "blue" :weight 'bold)
        (set-face-attribute 'markup-title-1-face nil :foreground "blue" :weight 'bold)
        (set-face-attribute 'markup-typewriter-face nil :foreground "green"))))

(use-package simple :diminish visual-line-mode)

(use-package web-beautify :ensure t :defer 3)

(use-package yaml-mode :ensure t :mode "\\.yml\\'")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LOCAL PACKAGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package pasteboard :defer 0
  :bind (("C-c C-w" . pasteboard-copy)
         ("C-c C-y" . pasteboard-paste)
         ("C-c C-k" . pasteboard-cut))
  :config
  (if window-system
      (progn
        (isolate-kill-ring)
        (bind-key "s-c" 'pasteboard-copy)
        (bind-key "s-v" 'pasteboard-paste)
        (bind-key "s-x" 'pasteboard-cut))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AUTO INSERT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package autoinsert :defer 0
  :preface
  (auto-insert-mode)
  (setq auto-insert-query nil)
  (setq auto-insert-directory (expand-file-name "local/templates" user-emacs-directory))

  ;; LaTeX
  (setq my-amsart-preamble-file
        (substitute-in-file-name "$HOME/.emacs.d/local/templates/latex/amsart-preamble.tex"))
  (define-auto-insert '("\.tex\\'" . "LaTeX skeleton")
    '(nil
      "% " (file-name-nondirectory (buffer-file-name)) \n
      "%" \n
      "% Created by Zhiming Wang on " (format-time-string "%B %d, %Y.") \n \n
      "\\documentclass{amsart}" \n \n
      "\\input{" my-amsart-preamble-file "}" \n \n
      "\\title{" (read-string "title (if empty, do not make title): ") & ; if title is nonempty
      (nil
       "}" \n
       "\\author{Zhiming Wang}" \n
       "\\date{\\today}" \n \n
       "\\begin{document}" \n \n
       "\\maketitle" \n \n
       _ \n \n
       "\\end{document}"
       )
      | ; if title is empty
      (nil
       '(kill-whole-line -1) \n
       "\\begin{document}" \n \n
       _ \n \n
       "\\end{document}")))

  ;; Perl
  (define-auto-insert '("\\.pl\\'" . "Perl skeleton") '(nil "#!/usr/bin/env perl" \n _ ))

  ;; Python
  (define-auto-insert '("\\.py\\'" . "Python skeleton") '(nil "#!/usr/bin/env python3" \n _ ))

  ;; Ruby
  (define-auto-insert '("\\.rb\\'" . "Ruby skeleton") '(nil "#!/usr/bin/env ruby" \n _ ))

  ;; shell script
  (define-auto-insert '("\\.\\(ba\\)?sh\\'" . "Bash skeleton") '(nil "#!/usr/bin/env bash" \n _ ))
  (define-auto-insert '("\\.zsh\\'" . "Zsh skeleton") '(nil "#!/usr/bin/env zsh" \n _ )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WINDOW SPECIFIC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (window-system)
  (progn
    ;; disable toolbar, tooltip, scrollbar, and window fringe
    (tool-bar-mode -1)
    (tooltip-mode -1)
    (scroll-bar-mode -1)
    (fringe-mode 0)
    ;; set frame size for window-system
    (add-to-list 'default-frame-alist (cons 'width 81))
    (add-to-list 'default-frame-alist
         (cons 'height (/ (- (x-display-pixel-height) 55)
                          (frame-char-height))))))
