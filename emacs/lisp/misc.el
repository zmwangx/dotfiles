;;; misc.el --- Miscellaneous helpers                -*- lexical-binding: t; -*-

;; Copyright (C) 2015  Zhiming Wang

;; Author: Zhiming Wang <zmwangx@gmail.com>

;;; Commentary:

;; No comment.

;;; Code:

(defun kill-other-buffers ()
  "Kill all buffers except the current one."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(provide 'misc)
;;; misc.el ends here
