;;; jump-char-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (jump-char-backward jump-char-forward) "jump-char"
;;;;;;  "jump-char.el" (21684 61885 472715 898000))
;;; Generated autoloads from jump-char.el

(autoload 'jump-char-forward "jump-char" "\
Prompt for a character, and jump to the next occurrence of that character.
Invokes `ace-jump-line-mode' when called with prefix.

When jump-char is active:

| key     | does                                                                           |
|---------+--------------------------------------------------------------------------------|
| <char>  | move to the next match in the current direction.                               |
| ;       | next match forward (towards end of buffer) see `jump-char-forward-key'         |
| ,       | next match backward (towards beginning of buffer) see `jump-char-backward-key' |
| C-c C-c | invoke `ace-jump-mode' if available                                            |

Any other key stops jump-char and edits as normal.

\(fn ARG &optional BACKWARD)" t nil)

(autoload 'jump-char-backward "jump-char" "\
backward movement version of `jump-char-forward'

\(fn ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("jump-char-pkg.el") (21684 61885 493495
;;;;;;  134000))

;;;***

(provide 'jump-char-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; jump-char-autoloads.el ends here
