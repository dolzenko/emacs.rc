;;; mo-git-blame-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "mo-git-blame" "mo-git-blame.el" (21222 42235
;;;;;;  119114 801000))
;;; Generated autoloads from mo-git-blame.el

(autoload 'mo-git-blame-file "mo-git-blame" "\
Calls `git blame' for REVISION of FILE-NAME or `HEAD' if
REVISION is not given. Initializes the two windows that will show
the output of 'git blame' and the content.

If FILE-NAME is missing it will be read with `find-file' in
interactive mode.

ORIGINAL-FILE-NAME defaults to FILE-NAME if not given. This is
used for tracking renaming and moving of files during iterative
re-blaming.

With a numeric prefix argument or with NUM-LINES-TO-BLAME only
the NUM-LINES-TO-BLAME lines before and after point are blamed by
using git blame's `-L' option. Otherwise the whole file is
blamed.

\(fn &optional FILE-NAME REVISION ORIGINAL-FILE-NAME NUM-LINES-TO-BLAME)" t nil)

(autoload 'mo-git-blame-current "mo-git-blame" "\
Calls `mo-git-blame-file' for HEAD for the current buffer.

\(fn)" t nil)

(autoload 'mo-git-blame-current-for-revision "mo-git-blame" "\
Calls `mo-git-blame-file' for `revision' for the current buffer.

\(fn REVISION)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; mo-git-blame-autoloads.el ends here