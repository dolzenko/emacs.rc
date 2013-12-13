;;; show-marks-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (show-marks mark-mode-next-mark mark-mode-prev-mark
;;;;;;  mark-mode-delete mark-mode-goto forward-mark backward-mark)
;;;;;;  "show-marks" "show-marks.el" (21120 38825 800500 906000))
;;; Generated autoloads from show-marks.el

(autoload 'backward-mark "show-marks" "\
Moves the point arg points backward in the mark ring.

\(fn ARG)" t nil)

(autoload 'forward-mark "show-marks" "\
Moves the point arg points forward in the mark ring.

\(fn ARG)" t nil)

(autoload 'mark-mode-goto "show-marks" "\
Go to the occurrence the current line describes.

\(fn)" t nil)

(autoload 'mark-mode-delete "show-marks" "\
Delete mark at current line from mark-ring.

\(fn)" t nil)

(autoload 'mark-mode-prev-mark "show-marks" "\
Move to previous mark in *mark* buffer, wrapping if necessary.

\(fn)" t nil)

(autoload 'mark-mode-next-mark "show-marks" "\
Move to next mark in *mark* buffer, wrapping if necessary.

\(fn)" t nil)

(autoload 'show-marks "show-marks" "\
Displays all the lines for each point in the mark ring.  Pressing
RET in the result buffer will send you to corresponding mark point
with out affecting the mark-ring.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("show-marks-pkg.el") (21120 38825 814065
;;;;;;  16000))

;;;***

(provide 'show-marks-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; show-marks-autoloads.el ends here
