(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(bmkp-last-as-first-bookmark-file "c:\\Users\\evgeniy\\AppData\\Roaming\\.emacs.bmk")
 '(fill-column 120)
 '(grep-find-ignored-directories (quote (".git")))
 '(grep-find-ignored-files (quote ("*.bak")))
 '(ido-enable-flex-matching t)
 '(ido-max-work-file-list 50)
 '(safe-local-variable-values (quote ((folded-file . t) (encoding . utf-8))))
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-mode t)
 '(smtpmail-smtp-server "smtp.googlemail.com")
 '(smtpmail-smtp-service 25)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(default ((t (:inherit nil :stipple nil :background "SystemWindow" :foreground "SystemWindowText" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "outline" :family "Consolas"))))
 '(compilation-info ((((class color) (min-colors 16) (background light)) nil)))
 '(dired-directory ((t (:foreground "blue"))))
 '(font-lock-comment-face ((((class color) (min-colors 16) (background light)) (:foreground "green4"))))
 '(font-lock-constant-face ((((class color) (min-colors 16) (background light)) (:foreground "red2"))))
 '(font-lock-function-name-face ((((class color) (min-colors 16) (background light)) (:foreground "Blue" :slant italic))))
 '(font-lock-keyword-face ((((class color) (min-colors 16) (background light)) (:foreground "blue4" :weight bold))))
 '(font-lock-string-face ((((class color) (min-colors 16) (background light)) (:foreground "tomato4" :weight bold))))
 '(font-lock-type-face ((t nil)))
 '(font-lock-variable-name-face ((((class color) (min-colors 16) (background light)) (:foreground "maroon4" :weight bold))))
 '(js2-external-variable ((t (:weight bold)))))
(put 'narrow-to-region 'disabled nil)

;;;;;;;;;;;;;
;; Essentials

;;;;;;;
;; Keys

;; Readline compatibility
;; C-h - delete char backwards
;; C-M-h - delete word backwards
(keyboard-translate ?\C-h ?\C-?)

;; http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs/5340797#5340797
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map (kbd "C-c C-r") 'recentf-open-files) ;; Quick access to recently opened files, questionable
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

(global-set-key (kbd "C-M-h") 'backward-kill-word)

;; Focus buffers list on C-x C-b (no idea why this is not default)
(defun list-buffers-and-other-window () (interactive) (call-interactively 'list-buffers) (call-interactively 'other-window))
(global-set-key (kbd "C-x C-b") 'list-buffers-and-other-window)

;; Quick buffer kill
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

;; Need to try that for a while
(global-set-key (kbd "C-c b") 'bury-buffer)

(global-set-key (kbd "C-c t") 'rspec-toggle-spec-and-target) ;; C-c t instead of C-c ,t
(global-set-key (kbd "C-c C-t") 'rspec-toggle-spec-and-target) ;; C-c t instead of C-c ,t

;; Juicy fingers make me press C-x f instead of C-x C-f
(global-set-key (kbd "C-x f") 'ido-find-file)

;; C-a goes to the first non space symbol first
(defun back-to-indentation-or-beginning ()
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line)
    (back-to-indentation)))
(global-set-key (kbd "C-a") 'back-to-indentation-or-beginning)

;;;;;;;
;; Else
;; "Standard selection" - replace the region just by typing , and kill the selected just with Backspace key
(delete-selection-mode 1)

;; Cygwin for find/grep
(setenv "PATH" (concat "C:\\cygwin\\bin;" (getenv "PATH")))

;; package.el (loads packages)
;; (when (load (expand-file-name (concat user-emacs-directory "elpa/package.el"))) (package-initialize))
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Allow loading manually installed extensions
(add-to-list 'load-path (concat user-emacs-directory "misc"))

(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))


;; IDO
(ido-mode t)
(ido-ubiquitous t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-auto-merge-work-directories-length nil
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-use-virtual-buffers t
      ido-handle-duplicate-virtual-buffers 2
      ido-max-prospects 10)

;; IDO for commands
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

(defalias 'yes-or-no-p 'y-or-n-p)

;; Show file path in window title
(when window-system (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

;; Vi "." (repeat) command
;; TODO 24 compat
;; (autoload 'dot-mode "dot-mode" nil t) ; vi `.' command emulation
;; (global-set-key [(control ?.)] (lambda () (interactive) (dot-mode 1) (message "Dot mode activated.")))
;; (require 'dot-mode)
;; (add-hook 'find-file-hooks 'dot-mode-on)

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(setq save-place-file (concat user-emacs-directory "places")
      inhibit-startup-message t)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

;; Files are reloaded automatically when changed
(global-auto-revert-mode t)



;; Add ruby file types
(progn
  (eval-after-load 'ruby-mode
     '(progn
  ;;      ;; work around possible elpa bug
  ;;      (ignore-errors (require 'ruby-compilation))
  ;;      (setq ruby-use-encoding-map nil)
  ;;      (add-hook 'ruby-mode-hook 'inf-ruby-keys)
  ;;      (define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
       (define-key ruby-mode-map (kbd "C-M-h") 'backward-kill-word)))

  ;; Rake files are ruby, too, as are gemspecs, rackup files, etc.
  (add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.thor$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Thorfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))

  )

;; symbol to string, string to symbol, single quote string to double quote string, Clear string, String interpolation
(require 'ruby-tools)
(add-hook 'haml-mode-hook 'ruby-tools-mode)

;; inserts end after do/class/module
(require 'ruby-end)

;; Load Markdown on *.md files
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; Jabber
(add-to-list 'load-path (concat user-emacs-directory "misc/emacs-jabber-0.8.91"))
(require 'jabber-autoloads)
(setq jabber-history-enabled t)
(setq jabber-history-enable-rotation t) ;; rotate every 1Mb
(setq jabber-use-global-history nil) ;; store history per contact
(add-hook 'jabber-alert-message-hooks 'jabber-message-beep) ;; Ding on received message
(setq jabber-chat-buffer-show-avatar nil)

;; Completion that uses many different methods to find options.
(global-set-key (kbd "M-/") 'hippie-expand)
;; Hippie expand: at times perhaps too hip
(dolist (f '(try-expand-line try-expand-list try-complete-file-name-partially))
  (delete f hippie-expand-try-functions-list))
;; Add this back in at the end of the list.
(add-to-list 'hippie-expand-try-functions-list 'try-complete-file-name-partially t)

;; (require 'pretty-mode)
;; (global-pretty-mode 1)

;; Use regex searches by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-%") 'query-replace-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-M-%") 'query-replace)

(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(add-hook 'javascript-mode-hook 'javascript-custom-setup)
(defun javascript-custom-setup () (moz-minor-mode 1))

;; Keep history of recently opened filse
(require 'recentf) (recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 60)

;; ;; Beter unique buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(setq dired-recursive-copies t)

(require 'autopair)
;; TODO breaks in LESS files
;; TODO add '|' to autopair for ruby
(autopair-global-mode) ;; enable autopair in all buffers
;; (add-hook 'ruby-mode-common-hook #'(lambda () (autopair-mode)))


(require 'haml-mode)

;; E'erybody wanna fuck my indent
(setq js-indent-level 2)
(setq c-basic-offset 2)

;;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)

;; Watch for trailing whitespace
(setq show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
;; Always remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Goodies like: copy-buffer-file-name-as-kill, rename-file-and-buffer, kill-all-buffers-except-current, move-buffer-file, etc.
(require 'buffer-extension)
(defun delete-file-and-buffer ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

;; rename-file-and-buffer version compatible with (setq uniquify-buffer-name-style 'forward)
;; (from http://www.stringify.com/2006/apr/24/rename/)
(defun rename-file-and-buffer ()
  (interactive)
  (if (not (buffer-file-name))
      (call-interactively 'rename-buffer)
    (let ((file (buffer-file-name)))
      (with-temp-buffer
        (set-buffer (dired-noselect file))
        (dired-do-rename)
        (kill-buffer nil))))
  nil)

(savehist-mode 1) ; to save minibuffer history
(setq echo-keystrokes 0.1) ; Show unfinished keystrokes early.
(size-indication-mode) ;; Show approx buffer size in modeline
(column-number-mode 1)

;; indicate the current state of case-fold-search in your ModeLine
(add-to-list 'minor-mode-alist '(case-fold-search " case-fold"))

;; turn off vc-git
;; (eval-after-load "vc" '(remove-hook 'find-file-hooks 'vc-find-file-hook))
(setq vc-handled-backends ())

;; classic
(defun google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Query: ")))))

;; ffap tries to ping something that looks like domain when trying to open files - turn that off
(setq ffap-machine-p-known 'reject)


;; automatically indenting yanked text if in programming-modes
(defvar yank-indent-modes '(emacs-lisp-mode
                            c-mode c++-mode ruby-mode
                            tcl-mode sql-mode
                            perl-mode cperl-mode
                            java-mode jde-mode
                            lisp-interaction-mode
                            LaTeX-mode TeX-mode)
  "Modes in which to indent regions that are yanked (or yank-popped)")

(defvar yank-advised-indent-threshold 1000
  "Threshold (# chars) over which indentation does not automatically occur.")

(defun yank-advised-indent-function (beg end)
  "Do indentation, as long as the region isn't too large."
  (if (<= (- end beg) yank-advised-indent-threshold)
      (indent-region beg end nil)))

(defadvice yank (after yank-indent activate)
  "If current mode is one of 'yank-indent-modes, indent yanked text (with prefix arg don't indent)."
  (if (and (not (ad-get-arg 0))
           (member major-mode yank-indent-modes))
      (let ((transient-mark-mode nil))
    (yank-advised-indent-function (region-beginning) (region-end)))))

(defadvice yank-pop (after yank-pop-indent activate)
  "If current mode is one of 'yank-indent-modes, indent yanked text (with prefix arg don't indent)."
  (if (and (not (ad-get-arg 0))
           (member major-mode yank-indent-modes))
    (let ((transient-mark-mode nil))
    (yank-advised-indent-function (region-beginning) (region-end)))))

;; ;;;;;;;
;; ;; Misc

;; ; Delete up to char (not including)
;; (autoload 'zap-up-to-char "misc"
;;   "Kill up to, but not including ARGth occurrence of CHAR.
;;   \(fn arg char)"
;;   'interactive)
;; (global-set-key "\M-z" 'zap-up-to-char)

;; ; Make copy operate on the current line when selection is empty
;; ; http://www.emacswiki.org/emacs/?action=browse;oldid=SlickCopy;id=WholeLineOrRegion
;; ; TODO sucks since doesn't work when there is no mark
;; ;; (defadvice kill-ring-save (around slick-copy activate)
;; ;;   "When called interactively with no active region, copy a single line instead."
;; ;;   (if (or (use-region-p) (not (called-interactively-p)))
;; ;;       ad-do-it
;; ;;     (kill-new (buffer-substring (line-beginning-position)
;; ;; 				(line-beginning-position 2))
;; ;; 	      nil '(yank-line))
;; ;;     (message "Copied line")))
;; ;; (defadvice kill-region (around slick-copy activate)
;; ;;   "When called interactively with no active region, kill a single line instead."
;; ;;   (if (or (use-region-p) (not (called-interactively-p)))
;; ;;       ad-do-it
;; ;;     (kill-new (filter-buffer-substring (line-beginning-position)
;; ;; 				       (line-beginning-position 2) t)
;; ;; 	      nil '(yank-line))))
;; ;; (defun yank-line (string)
;; ;;   "Insert STRING above the current line."
;; ;;   (beginning-of-line)
;; ;;   (unless (= (elt string (1- (length string))) ?\n)
;; ;;     (save-excursion (insert "\n")))
;; ;;   (insert string))
;; (put 'kill-ring-save 'interactive-form
;;      '(interactive
;;        (if (use-region-p)
;;            (list (region-beginning) (region-end))
;;          (list (line-beginning-position) (line-beginning-position 2)))))
;; (put 'kill-region 'interactive-form
;;      '(interactive
;;        (if (use-region-p)
;;            (list (region-beginning) (region-end))
;;          (list (line-beginning-position) (line-beginning-position 2)))))

;; http://stackoverflow.com/a/890279/54247
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position)
           (line-beginning-position 2)))))
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(setq lua-indent-level 2)

(defun my-lua-undef-keys () ((define-key lua-mode-map "}" nil)
                             (define-key lua-mode-map "]" nil)
                             (define-key lua-mode-map ")" nil)))
          ;;            ;;
          ;;            ;; )))

;; (add-hook 'lua-mode-hook
;;           (lambda () (unless (fboundp 'lua-calculate-indentation-right-shift-next)
;;                        (load-file (locate-file "my-lua.el" load-path)))))


;; ;; easy face customization
;; ; (add-to-list 'load-path "C:/Users/evgeniy/AppData/Roaming/.emacs.d/misc")
;; ; (require 'facemenu+)

;; ; better grep results
;; ;; (require 'compile-)
;; ;; (require 'compile+)
;; ;; (require 'grep+)

;; ;; (iswitchb-mode 1)
;; ;; (setq iswitchb-buffer-ignore '("^ " "*Buffer"))

;; ;; Provides auto brackets, collides with textmate.el
;; (require 'textmate-br-mode)
;; (add-hook 'find-file-hooks 'textmate-br-mode)

;; ;; Provides find in file, broken
;; ;; (add-to-list 'load-path "~/.emacs.d/misc/textmate.el")
;; ;; (require 'textmate)
;; ;; (textmate-mode)


;; (defun kill-all-dired-buffers()
;;   "Kill all dired buffers."
;;   (interactive)
;;   (save-excursion
;;     (let((count 0))
;;       (dolist(buffer (buffer-list))
;; 	(set-buffer buffer)
;; 	(when (equal major-mode 'dired-mode)
;; 	  (setq count (1+ count))
;; 	  (kill-buffer buffer)))
;;       (message "Killed %i dired buffer(s)." count ))))

;; ;; Fancy buffers buffer
;; (global-set-key (kbd "C-x C-b") 'bs-show)
;; ;; bs-configurations not found
;; ;;(add-to-list 'bs-configurations
;; ;;	     '("dired" nil nil nil
;; ;;	       (lambda (buf)
;; ;;		 (with-current-buffer buf
;; ;;		   (not (eq major-mode 'dired-mode)))) nil))
;; ;; (define-key bs-mode-map (kbd "D D") 'kill-all-dired-buffers)




;; ;; Purpose: When you visit a file, point goes to the last place where it was when you previously visited the same file.
;; (require 'saveplace)
;; (setq-default save-place t)

;; ;; Highlight TODOs everywhere
;; (defun esk-add-watchwords ()
;;   (font-lock-add-keywords
;;    nil '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\|NOCOMMIT\\)"
;;           1 font-lock-warning-face t))))
;; (add-hook 'prog-mode-hook 'esk-add-watchwords)
;; (defun esk-prog-mode-hook ()
;;   (run-hooks 'prog-mode-hook))
;; (add-hook 'find-file-hooks 'esk-prog-mode-hook)

;; ;; TODO make find-file-in-project work

;; (set-default 'indent-tabs-mode nil)
;; (set-default 'indicate-empty-lines t)
;; (defalias 'auto-tail-revert-mode 'tail-mode)

;; ;; Jump to a definition in the current file. (Protip: this is awesome.)
;; (global-set-key (kbd "C-x C-i") 'imenu)

;; (global-set-key (kbd "C-c g") 'magit-status)

;; ;; Set to t for debugging
;; (add-hook 'after-init-hook
;;           '(lambda () (setq debug-on-error t)))

;; (defun esk-eval-and-replace ()
;;   "Replace the preceding sexp with its value."
;;   (interactive)
;;   (backward-kill-sexp)
;;   (condition-case nil
;;       (prin1 (eval (read (current-kill 0)))
;;              (current-buffer))
;;     (error (message "Invalid expression")
;;            (insert (current-kill 0)))))
;; ;; Should be able to eval-and-replace anywhere.
;; (global-set-key (kbd "C-c e") 'esk-eval-and-replace)

;; ;; Activate occur easily inside isearch
;; (define-key isearch-mode-map (kbd "C-o")
;;   (lambda () (interactive)
;;     (let ((case-fold-search isearch-case-fold-search))
;;       (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))



;; ;; It's all about the project.
;; (global-set-key (kbd "C-c f") 'find-file-in-project)

;; ;; JS tweaks from starter kit
;; (add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
;; (eval-after-load 'js
;;   '(progn (define-key js-mode-map "{" 'paredit-open-curly)
;;           (define-key js-mode-map "}" 'paredit-close-curly-and-newline)
;;           (add-hook 'js-mode-hook 'esk-paredit-nonlisp)
;;           (setq js-indent-level 2)
;;           ;; fixes problem with pretty function font-lock
;;           (define-key js-mode-map (kbd ",") 'self-insert-command)
;;           (font-lock-add-keywords
;;            'js-mode `(("\\(function *\\)("
;;                        (0 (progn (compose-region (match-beginning 1)
;;                                                  (match-end 1) "\u0192")
;;                                  nil)))))))

;; ;; Vi like go to char
;; ;; TODO haven't ever used
;; (require 'jump-char)
;; (global-set-key [(meta m)] 'jump-char-forward)
;; (global-set-key [(shift meta m)] 'jump-char-backward)


;; ;; Maximize window + hack from http://stackoverflow.com/q/815239/54247
;; (w32-send-sys-command 61488)
;; ;; TODO make new-frame create maximized windows

;; ;; TODO make term-mode work

;; ;; Single dired buffer
;; ;; TODO doesn't seem to work
;; ;; (require 'dired-single)
;; ;; (defun my-dired-init ()
;; ;;   "Bunch of stuff to run for dired, either immediately or when it's
;; ;;         loaded."
;; ;;   ;; <add other stuff here>
;; ;;   (define-key dired-mode-map [return] 'dired-single-buffer)
;; ;;   (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
;; ;;   (define-key dired-mode-map "^"
;; ;;     (function
;; ;;      (lambda nil (interactive) (dired-single-buffer "..")))))
;; ;; ;; if dired's already loaded, then the keymap will be bound
;; ;; (if (boundp 'dired-mode-map)
;; ;;     ;; we're good to go; just add our bindings
;; ;;     (my-dired-init)
;; ;;   ;; it's not loaded yet, so add our bindings to the load-hook
;; ;;   (add-hook 'dired-load-hook 'my-dired-init))

;; ;; TODO doesn't work
;; (defun switch-to-previous-buffer ()
;;   (interactive)
;;   (switch-to-buffer (other-buffer (current-buffer) 1)))
;; (global-set-key (kbd "C-o") 'switch-to-previous-buffer)

;; ;; Kill buffer with simpler shortcute instead of C-x b RET
;; (global-set-key (kbd "C-x C-k") (lambda () (interactive) (kill-buffer-and-window)))

;; (require 'sass-mode)


;; ;; TODO doesn't work and breaks tab switching intermittently
;; ;; (require 'tty-format)
;; ;; (add-hook 'find-file-hooks 'tty-format-guess)

;; ;; it's crazy
;; (require 'bookmark+)

(require 'buffer-move)
(defun win-swap () "Swap windows using buffer-move.el" (interactive) (if (null (windmove-find-other-window 'right)) (buf-move-left) (buf-move-right)))

;; (require 'install-elisp)
;; (setq install-elisp-repository-directory "~/.emacs.d/misc")

(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'ido-exit-minibuffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(menu-bar-mode 0)


(defun explorer ()
  "Launch the windows explorer in the current directory and selects current file"
  (interactive)
  (w32-shell-execute
   "open"
   "explorer"
   (concat "/e,/select," (convert-standard-filename buffer-file-name))))
(put 'gomoku 'disabled t)

(kill-buffer "*scratch*")

(defun goto-lua-spec ()
  "toggles between Lua spec and tested code"
  (interactive)
  (find-file (replace-regexp-in-string ".lua$" "_spec.lua" (replace-regexp-in-string "/bidder/" "/spec/bidder/" (buffer-file-name)))))

;; (require 'ess-site)

;; TODO Teach speller about camel-cased, underscored identifiers
;; (setq ispell-program-name "C:/Program Files (x86)/Aspell/bin/aspell.exe"
;;       ispell-extra-args '("--sug-mode=ultra"))
;; (add-hook 'ruby-mode-hook
;;           (lambda()
;;             (flyspell-mode 1)))


;;;;;;;;;;;;;;;;;;;;
;; set up unicode
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; This from a japanese individual.  I hope it works.
(setq default-buffer-file-coding-system 'utf-8)
;; From Emacs wiki
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; MS Windows clipboard is UTF-16LE
(set-clipboard-coding-system 'utf-16le-dos)


;; I don't need overwrite mode
(define-key global-map [(insert)] nil) ;; Didn't work, see below
;; (define-key global-map [(control insert)] 'overwrite-mode)
(put 'overwrite-mode 'disabled t)
(setq disabled-command-hook 'beep)

;; Don't put encoding header automatically
(setq ruby-insert-encoding-magic-comment nil)


;; http://emacswiki.org/emacs/WindowResize
;; Arrow keys are OKish for this
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)


(require 'list-register)
(global-set-key (kbd "C-x r v") 'list-register)

(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'comment-dwim-line)

(load "~/.emacs.private")
