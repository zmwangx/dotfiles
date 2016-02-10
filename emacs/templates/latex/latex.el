'(nil
  ;; CAUTION: Copy templates/latex/amsart-preamble.tex to the working directory
  (if (buffer-file-name)
    (funcall (lambda (src dst)
               "Copy SRC to DST if DST does not exist already."
               (if (not (file-exists-p dst))
                   (copy-file src dst)))
             (concat (file-name-as-directory auto-insert-directory) "latex/amsart-preamble.tex")
             (concat (file-name-directory (buffer-file-name)) "amsart-preamble.tex")))

  "% " (file-name-nondirectory (buffer-file-name)) \n
  "%" \n
  "% Created by " (user-full-name) " on " (format-time-string "%B %d, %Y.") \n \n
  "\\documentclass{amsart}" \n \n
  "\\input{amsart-preamble.tex}" \n \n
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
   "\\end{document}"))
