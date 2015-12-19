;;; pasteboard.el --- Interact with OS X system pasteboard  -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Zhiming Wang

;; Author: Zhiming Wang <zmwangx@gmail.com>
;; Keywords: osx, pasteboard, clipboard

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
