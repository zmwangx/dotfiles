;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; package.el (with MELPA and local packages)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(setq package-enable-at-startup nil)
(eval-and-compile
  (mapc #'(lambda (path) (push (expand-file-name path user-emacs-directory) load-path))
        '("site-lisp" "lisp" "site-lisp/use-package")))
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

;;; enable
(put 'downcase-region 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL THEMING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'color)

(if (not (window-system))
    ;; tty mode, colors based on my modified Solarized palatte for iTerm2
    (progn
      ;; custom
      (setq custom-file (expand-file-name "custom-tty.el" user-emacs-directory))
      (load custom-file 'noerror))

  ;; window system mode
  (progn
    ;; custom
    (setq custom-file (expand-file-name "custom-window.el" user-emacs-directory))
    (load custom-file 'noerror)

    ;; load solarized-dark theme
    (use-package solarized :ensure solarized-theme :config (load-theme 'solarized-dark))

    ;; maximize frame height
    ;;
    ;; (nth 4 (car (frame-monitor-attributes))) extracts the pixel height of
    ;; the monitor of the current frame; see
    ;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Multiple-Terminals.html#index-frame_002dmonitor_002dattributes
    (add-to-list 'default-frame-alist
                 (cons 'height (/ (- (nth 4 (car (frame-monitor-attributes))) 30) (frame-char-height))))

    ;; change font for Chinese fontset (han)
    (set-fontset-font "fontset-default" 'han "STSong")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cancel-edit ()
  "Immediately exit Emacsclient with nonzero exit status."
  (interactive)
  (server-send-string (car server-buffer-clients) "-error die"))

(defun indent-and-newline-and-indent ()
  "Correct indentation of current line, insert newline, and indent the new line."
  (interactive)
  (indent-for-tab-command)
  (newline-and-indent))

(defun smart-revert-buffer ()
  "Like revert-buffer, but do not ask for confirmation if buffer is not modified."
  (interactive)
  (if (buffer-modified-p)
      (revert-buffer)
    (revert-buffer :ignore-auto :noconfirm)))

(defun system-open ()
  "Open the file in the current buffer with the system `open' command."
  (interactive)
  (if buffer-file-name
      (shell-command-to-string (concat "open " (shell-quote-argument buffer-file-name) " &"))))

(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max)))
    (fill-paragraph nil region)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GLOBAL KEYBINDINGS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(bind-key "C-c C-k" 'cancel-edit)
(bind-key "C-c ;" 'comment-or-uncomment-region)
(bind-key "C-\\" 'delete-trailing-whitespace)
(bind-key "C-x C-r" 'smart-revert-buffer)
(bind-key "C-x C-k" 'server-edit)
(bind-key "M-s" 'shell-command)
(bind-key "C-o" 'system-open)
(bind-key "C--" 'undo)

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
  (setq abbrev-file-name (expand-file-name "abbrev_defs" user-emacs-directory))
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
  (setq-default cperl-indent-level 4))

(use-package diff-mode :defer t)

(use-package hideshow :commands hs-minor-mode :diminish hs-minor-mode)

(use-package sgml-mode :mode ("\\.html\\'" . html-mode)
  :preface
  (defun my-html-mode-hook ()
    (yas-minor-mode 1))

  :config
  (message "hello world")
  (add-hook 'html-mode-hook 'my-html-mode-hook))

(use-package ido-mode :defer 0
  :init
  (ido-mode)
  (ido-everywhere 1)
  (setq ido-enable-flex-matching t)
  (setq ido-enable-last-directory-history nil))

(use-package make-mode :mode ("\\Makefile\\'" . makefile-mode))

(use-package minibuffer :init (setq completion-cycle-threshold 3))

(use-package python :mode ("\\.py\\'" . python-mode) :interpreter ("python" . python-mode)
  :preface
  (defun my-python-mode-hook ()
    (setq-default fill-column 72)
    ;; Python's lack of braces or ends makes it hard to deduce indentation automatically
    (bind-key "RET" 'newline-and-indent python-mode-map)
    ;; jedi
    (setq-default jedi:complete-on-dot t)
    (setq-default jedi:environment-root "default")
    (jedi:setup)
    (yas-minor-mode 1))

  :config
  (add-hook 'python-mode-hook 'my-python-mode-hook))

(use-package ruby-mode :mode "\\.rb\\'" :interpreter "ruby")

(use-package sh-script :mode ("\\(\\.zsh\\|/_[^/]*\\|/.env\\)\\'" . sh-mode)
  :preface
  (defun my-sh-mode-hook ()
    (yas-minor-mode 1))

  :config
  (add-hook 'sh-mode-hook 'my-sh-mode-hook))

(use-package vc-hooks :init (setq vc-follow-symlinks t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PACKAGE.EL PACKAGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ace-jump-mode :ensure t :bind ("M-h" . ace-jump-mode))

(use-package adoc-mode :ensure t :mode "\\.adoc\\'")

(use-package apples-mode :ensure t :interpreter "osascript")

(use-package tex-site :ensure auctex :mode ("\\.tex\\'" . LaTeX-mode)
  :preface
  (defun LaTeX-insert-display-math ()
    "Insert a \\=\\[ \\] block for display math."
    (interactive)
    (insert "\\[")
    (indent-for-tab-command)
    (newline)
    (newline)
    (insert "\\]")
    (indent-for-tab-command)
    (forward-line -1))

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
  (add-hook 'LaTeX-mode-hook 'my-LaTeX-mode-hook))

(use-package auto-complete :ensure t :commands auto-complete-mode :diminish auto-complete-mode)

(use-package crontab-mode :ensure t :mode "/crontab\\(\\.[^/]*\\)?\\'")

(use-package diminish :ensure t)

(use-package fiplr :ensure t :commands (fiplr-find-file fiplr-find-directory)
  :bind (("C-x f" . fiplr-find-file) ("C-x d" . fiplr-find-directory))
  :preface
  (setq fiplr-ignored-globs
        '((directories (".git" ".svn" ".tox" "build"))
          (files ("*.jpg" "*.o" "*.png" "*.pyc")))))

(use-package flycheck :ensure t :defer t)

(use-package git-commit :ensure t :defer t)

(use-package gitattributes-mode :ensure t :defer t)

(use-package gitconfig-mode :ensure t :defer t)

(use-package gitignore-mode :ensure t :defer t)

(use-package go-mode :ensure t :mode "\\.go\\'")

(use-package haskell-mode :ensure t :mode "\\.hs\\'"
  :preface
  (defun my-haskell-mode-hook ()
    (setq haskell-indentation-layout-offset 4
          haskell-indentation-starter-offset 4
          haskell-indentation-left-offset 4
          haskell-indentation-ifte-offset 4
          haskell-indentation-where-pre-offset 2
          haskell-indentation-where-post-offset 2))

  :config
  (add-hook 'haskell-mode-hook 'my-haskell-mode-hook))

(use-package jedi :ensure t :defer t)

(use-package js2-mode :ensure t :mode "\\.js\\'" :interpreter "node"
  :init
  (setq-default js2-basic-offset 2)
  (setq-default js2-strict-missing-semi-warning nil)
  (setq-default js2-skip-preprocessor-directives t))

(use-package json-mode :ensure t :mode "\\.json\\'" :init
  (setq-default js-indent-level 2)
  (setq-default json-reformat:indent-width 2))

(use-package magit :ensure t :defer 0 :bind ("M-m" . magit-status) :config
  (add-hook 'magit-mode-hook 'visual-line-mode)
  (setq-default magit-diff-refine-hunk t)
  (setq-default magit-revert-buffers t)
  (setq magit-push-always-verify nil)

  ;; add --gpg-sign switch to magit-commit by default, and provide the --no-gpg-sign switch in popup
  (defun magit-commit-insert-gpg-sign-switch (args)
    "Insert the --gpg-sign switch as the first option to `magit-commit'."
    (setcar args (cons "--gpg-sign" (car args)))
    args)
  (advice-add 'magit-commit :filter-args #'magit-commit-insert-gpg-sign-switch)
  (advice-add 'magit-commit-amend :filter-args #'magit-commit-insert-gpg-sign-switch)
  (advice-add 'magit-commit-extend :filter-args #'magit-commit-insert-gpg-sign-switch)
  (advice-add 'magit-commit-reword :filter-args #'magit-commit-insert-gpg-sign-switch)

  (magit-define-popup-switch 'magit-commit-popup ?N "Do NOT GPG-sign commit" "--no-gpg-sign"))

(use-package markdown-mode :ensure t :mode "\\.md\\'" :config
  (add-hook 'markdown-mode-hook 'abbrev-mode))

(use-package markup-faces :ensure t :defer t)

(use-package simple :diminish visual-line-mode)

(use-package web-beautify :ensure t :defer 3)

(use-package yaml-mode :ensure t :mode "\\.yml\\'")

(use-package yasnippet :ensure t :diminish yas-minor-mode
  :commands (yas-minor-mode)
  :mode ("/\\.emacs\\.d/snippets/" . snippet-mode)
  :bind (("C-c y s" . yas-insert-snippet) ("C-c y n" . yas-new-snippet) ("C-c y v" . yas-visit-snippet-file))
  :preface
  (setq yas-snippet-dirs (expand-file-name "snippets" user-emacs-directory))
  (setq yas-new-snippet-default "\
# -*- mode: snippet; require-final-newline: nil -*-
# name: $1
# key: ${2:${1:$(yas--key-from-desc yas-text)}}
# contributor: `user-full-name` <`user-mail-address`>
# --
$0")

  :config
  (yas-load-directory (expand-file-name "snippets" user-emacs-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LOCAL PACKAGES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package pasteboard :defer 0
  :bind (("C-x w" . pasteboard-copy)
         ("C-x y" . pasteboard-paste)
         ("C-x x" . pasteboard-cut))
  :config
  (if window-system
      (progn
        (isolate-kill-ring)
        (bind-key "s-c" 'pasteboard-copy)
        (bind-key "s-v" 'pasteboard-paste)
        (bind-key "s-x" 'pasteboard-cut))))

(use-package misc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AUTO INSERT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package autoinsert :defer 0
  :preface
  (auto-insert-mode)
  (setq auto-insert-query nil)
  (setq auto-insert-directory (expand-file-name "templates" user-emacs-directory))

  ;; Declare all values safe for auto-insert-alist so that we can auto-insert
  ;; project specific license/authorship boilerplates without being bugged upon
  ;; opening any file.
  ;;
  ;; Probably a little bit risky though.
  (put 'auto-insert-alist 'safe-local-variable (lambda (var) t))

  ;; HTML5
  (define-auto-insert "\\.html\\'" "html5.html")

  ;; Javascript
  (define-auto-insert "\\.user.js\\'" "userscript.user.js")

  ;; LaTeX
  (setq my-amsart-preamble-file
        (substitute-in-file-name "$HOME/.emacs.d/templates/latex/amsart-preamble.tex"))
  (define-auto-insert '("\.tex\\'" . "LaTeX skeleton")
    '(nil
      "% " (file-name-nondirectory (buffer-file-name)) \n
      "%" \n
      "% Created by " (user-full-name) " on " (format-time-string "%B %d, %Y.") \n \n
      "\\documentclass{amsart}" \n \n
      "\\input{" my-amsart-preamble-file "}" \n \n
      "\\title{" (read-string "title (if empty, do not make title): ") & ; if title is nonempty
      (nil
       "}" \n
       "\\author{" (user-full-name) "}" \n
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
  (define-auto-insert "\\.pl\\'" "perl.pl")

  ;; Python
  (define-auto-insert "\\.py\\'" "python.py")

  ;; Ruby
  (define-auto-insert "\\.rb\\'" "ruby.rb")

  ;; shell script
  (define-auto-insert "\\.z?sh\\'" "zsh.sh")
  (define-auto-insert "\\.bash\\'" "bash.sh"))
