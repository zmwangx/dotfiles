;;; pasteboard.el --- Interact with OS X system pasteboard  -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Zhiming Wang

;; Author: Zhiming Wang <zmwangx@gmail.com>
;; Keywords: osx, pasteboard, clipboard

;;; Commentary:

;; Remember to run `M-x isolate-kill-ring' in a window system to prevent the
;; Emacs kill ring from picking up random stuff copied elsewhere.

;;; Code:

(defun isolate-kill-ring()
  "Isolate Emacs kill ring from OS X system pasteboard.

This function is only useful in window system."
  (interactive)
  (setq interprogram-cut-function nil)
  (setq interprogram-paste-function nil))

(defun pasteboard-copy()
  "Save region to OS X system pasteboard."
  (interactive)
  (shell-command-on-region
   (region-beginning) (region-end) "pbcopy")
  (deactivate-mark))

(defun pasteboard-paste()
  "Paste from OS X system pasteboard via `pbpaste'.

Windows CRLF or classic Mac OS CR are converted to Unix LF."
  (interactive)
  (shell-command-on-region
   (point) (if mark-active (mark) (point))
   "pbpaste | perl -p -e 's/\r$//' | tr '\r' '\n'" nil t))

(defun pasteboard-cut()
  "Kill region and save to OS X system pasteboard."
  (interactive)
  (pasteboard-copy)
  (delete-region (region-beginning) (region-end)))

(defalias 'pbcopy 'pasteboard-copy)
(defalias 'pbpaste 'pasteboard-paste)
(defalias 'pbcut 'pasteboard-cut)

(provide 'pasteboard)
;;; pasteboard.el ends here
