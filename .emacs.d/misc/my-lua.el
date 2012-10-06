;; use an indentation width of two spaces
(setq lua-indent-level 2)

;; Add dangling '(', remove '='
(setq lua-cont-eol-regexp
      (eval-when-compile
        (concat
         "\\((\\|\\_<"
         (regexp-opt '("and" "or" "not" "in" "for" "while"
                       "local" "function") t)
         "\\_>\\|"
         "\\(^\\|[^" lua-operator-class "]\\)"
         (regexp-opt '("+" "-" "*" "/" "^" ".." "==" "<" ">" "<=" ">=" "~=") t)
         "\\)"
         "\\s *\\=")))

(defun lua-calculate-indentation (&optional parse-start)
  "Overwrites the default lua-mode function that calculates the
column to which the current line should be indented to."
  (save-excursion
    (when parse-start
      (goto-char parse-start))

    ;; We calculate the indentation column depending on the previous
    ;; non-blank, non-comment code line. Also, when the current line
    ;; is a continuation of that previous line, we add one additional
    ;; unit of indentation.
    (+ (if (lua-is-continuing-statement-p) lua-indent-level 0)
       (if (lua-goto-nonblank-previous-line)
           (+ (current-indentation) (lua-calculate-indentation-right-shift-next))
         0))))

(defun lua-calculate-indentation-right-shift-next (&optional parse-start)
  "Assuming that the next code line is not a block ending line,
this function returns the column offset that line should be
indented to with respect to the current line."
  (let ((eol)
        (token)
        (token-info)
        (shift 0))
    (save-excursion
      (when parse-start
        (goto-char parse-start))

      ; count the balance of block-opening and block-closing tokens
      ; from the beginning to the end of this line.
      (setq eol (line-end-position))
      (beginning-of-line)
      (while (and (lua-find-regexp 'forward lua-indentation-modifier-regexp)
                  (<= (point) eol)
                  (setq token (match-string 0))
                  (setq token-info (assoc token lua-block-token-alist)))
        ; we found a token. Now, is it an opening or closing token?
        (if (eq (nth 2 token-info) 'open)
            (setq shift (+ shift lua-indent-level))
          (when (or (> shift 0)
                    (string= token ")"))
            (setq shift (- shift lua-indent-level))))))
    shift))

(defvar my-lua-indent 2
  "The number of spaces to insert for indentation")

(defun my-lua-enter ()
  "Inserts a newline and indents the line like the previous
non-empty line."
  (interactive)
  (newline)
  (indent-relative-maybe))

(defun my-lua-indent ()
  "Moves point to the first non-whitespace character of the
line if it is left of it. If point is already at that
position, or if it is at the beginning of an empty line,
inserts two spaces at point."
  (interactive)
  (when (looking-back "^\\s *")
    (if (looking-at "[\t ]")
        (progn (back-to-indentation)
               (when (looking-at "$")
                 (kill-line 0)
                 (indent-relative-maybe)
                 (insert (make-string my-lua-indent ? ))))
      (insert (make-string my-lua-indent ? )))))

(defun my-lua-setup ()
  "Binds ENTER to my-lua-enter and configures indentation the way
I want it. Makes sure spaces are used for indentation, not tabs."
  (setq indent-tabs-mode nil)
  (local-set-key "\r" 'my-lua-enter)
  (setq indent-line-function 'my-lua-indent))

;; add `my-lua-setup' as a call-back that is invoked whenever lua-mode
;; is activated.
(add-hook 'lua-mode-hook 'my-lua-setup)