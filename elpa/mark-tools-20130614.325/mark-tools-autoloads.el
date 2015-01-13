;;; mark-tools-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (list-marks-other-window list-marks mark-list-mode)
;;;;;;  "mark-tools" "mark-tools.el" (21684 61859 804397 578000))
;;; Generated autoloads from mark-tools.el

(autoload 'mark-list-mode "mark-tools" "\
Major mode for listing the historical Mark List.
The Buffer Menu is invoked by the commands \\[list-marks].

Letters do not insert themselves; instead, they are commands.
\\<mark-list-mode-map>
\\{mark-list-mode-map}

\(fn)" t nil)

(autoload 'list-marks "mark-tools" "\
Display the mark ring.
The list is displayed in a buffer named \"*Mark List*\".

By default it displays the global-mark-ring.
With prefix argument ARG, show local buffer mark-ring.

\(fn &optional ARG)" t nil)

(autoload 'list-marks-other-window "mark-tools" "\
Display the mark ring in a different window.
The list is displayed in a buffer named \"*Mark List*\".

By default it displays the global-mark-ring.
With prefix argument ARG, show local buffer mark-ring.

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("mark-tools-pkg.el") (21684 61859 821708
;;;;;;  528000))

;;;***

(provide 'mark-tools-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mark-tools-autoloads.el ends here
