(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(blink-cursor-mode nil)
;;  '(bmkp-last-as-first-bookmark-file "c:\\Users\\evgeniy\\AppData\\Roaming\\.emacs.bmk")
;;  '(fill-column 120)
;;  '(grep-find-ignored-directories (quote (".git")))
;;  '(grep-find-ignored-files (quote ("*.bak")))
;;  '(safe-local-variable-values (quote ((folded-file . t) (encoding . utf-8))))
;;  '(send-mail-function (quote smtpmail-send-it))
;;  '(show-paren-mode t)
;;  '(smtpmail-smtp-server "smtp.googlemail.com")
;;  '(smtpmail-smtp-service 25)
;;  '(tool-bar-mode nil))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :background "#eeeee0" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "outline"))))
;;  '(compilation-info ((((class color) (min-colors 16) (background light)) nil)))
;;  '(dired-directory ((t (:foreground "blue"))))
;;  '(font-lock-comment-face ((((class color) (min-colors 16) (background light)) (:foreground "green4"))))
;;  '(font-lock-constant-face ((((class color) (min-colors 16) (background light)) (:foreground "red2"))))
;;  '(font-lock-function-name-face ((((class color) (min-colors 16) (background light)) (:foreground "Blue" :slant italic))))
;;  '(font-lock-keyword-face ((((class color) (min-colors 16) (background light)) (:foreground "blue4" :weight bold))))
;;  '(font-lock-string-face ((((class color) (min-colors 16) (background light)) (:foreground "tomato4" :weight bold))))
;;  '(font-lock-type-face ((t nil)))
;;  '(font-lock-variable-name-face ((((class color) (min-colors 16) (background light)) (:foreground "maroon4" :weight bold))))
;;  '(js2-external-variable ((t (:weight bold)))))
;; (put 'narrow-to-region 'disabled nil)

(when (eq system-type 'windows-nt)
    (add-to-list 'default-frame-alist '(font . "Consolas"))
  (set-face-attribute 'default nil :height 130)
  ;; Cygwin for find/grep
  (setenv "PATH" (concat "C:\\cygwin\\bin;" (getenv "PATH")))

  )
(if (eq system-type "gnu/linux")
    (add-to-list 'default-frame-alist '(font . "Ubuntu Mono"))
  (set-face-attribute 'default nil :height 130)
  (setq ring-bell-function (lambda ()
                             (call-process "play" nil 0 nil
                                           "/usr/share/sounds/gnome/default/alerts/glass.ogg")))

  )

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
;; (define-key my-keys-minor-mode-map (kbd "C-c C-r") 'recentf-open-files) ;; Quick access to recently opened files, questionable
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;; (global-set-key (kbd "C-M-h") 'backward-kill-word)

;; Focus buffers list on C-x C-b (no idea why this is not default)
(defun list-buffers-and-other-window () (interactive) (call-interactively 'list-buffers) (call-interactively 'other-window))
;; (global-set-key (kbd "C-x C-b") 'ido-switch-buffer)

;; Quick buffer kill
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

(global-set-key (kbd "C-c b") 'bury-buffer)

;; Juicy fingers make me press C-x f instead of C-x C-f
;; (global-set-key (kbd "C-x f") 'ido-find-file)

;; C-a goes to the first non space symbol first
(defun back-to-indentation-or-beginning ()
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line)
    (back-to-indentation)))
(global-set-key (kbd "C-a") 'back-to-indentation-or-beginning)

;; package.el (loads packages)
;; (when (load (expand-file-name (concat user-emacs-directory "elpa/package.el"))) (package-initialize))
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; Rinari
(add-to-list 'load-path "~/emacs.rc/rinari")
(require 'rinari)
(setq rinari-tags-file-name "TAGS")

(global-set-key (kbd "C-c t") 'projectile-toggle-between-implementation-and-test) ;; C-c t instead of C-c ,t
(global-set-key (kbd "C-c C-t") 'projectile-toggle-between-implementation-and-test) ;; C-c t instead of C-c ,t
(custom-set-variables '(rspec-use-bundler-when-possible nil)
                      '(rspec-use-rake-flag t)
                      )

;; (defun rspec-default-options ()
;;   (if (rspec2-p)
;;       ""
;;     (concat "--format specdoc " "--reverse")))


;; Allow loading manually installed extensions
(add-to-list 'load-path (concat user-emacs-directory "misc"))

(autoload 'ruby-mode "ruby-mode" "Major mode for ruby files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))


;; ;; IDO
;; (ido-mode t)
;; (ido-ubiquitous t)
;; (setq ido-enable-prefix nil
;;       ido-enable-flex-matching t
;;       ido-auto-merge-work-directories-length nil
;;       ido-create-new-buffer 'always
;;       ido-use-filename-at-point 'guess
;;       ido-use-virtual-buffers t
;;       ido-handle-duplicate-virtual-buffers 2
;;       ido-max-prospects 7
;;       ido-max-directory-size 100000
;;       ido-max-work-file-list 50)

;; ;; IDO for commands
;; (require 'smex)
;; (smex-initialize)
;; (global-set-key (kbd "M-x") 'smex)

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
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; Add ruby file types
(progn
  (eval-after-load 'ruby-mode
     '(progn
  ;;      ;; work around possible elpa bug
  ;;      (ignore-errors (require 'ruby-compilation))
  ;;      (setq ruby-use-encoding-map nil)
  ;;      (add-hook 'ruby-mode-hook 'inf-ruby-keys)
  ;;      (define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
;;       (define-key ruby-mode-map (kbd "C-M-h") 'backward-kill-word)
	)
	)

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
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; (require 'dired-x)
;; (setq-default dired-omit-files-p t) ;; this is buffer-local variable
;; (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(setq dired-listing-switches "-lXGhA --group-directories-first") ;; C-u s while in a Dired buffer will prompt you for new `ls` switches

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
(require 'recentf)
(recentf-mode 1)
;; (setq recentf-max-saved-items 500)
;; (setq recentf-max-menu-items 60)

;; Beter unique buffer names
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(setq dired-recursive-copies t)

(require 'haml-mode)

;; E'erybody wanna fuck my indent
(setq js-indent-level 2)
(setq c-basic-offset 2)

;;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)

;; Watch for trailing whitespace
(setq show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
;; Remove trailing whitespace (unless in Markdown when it is significant)
(defun my-delete-trailing-whitespace ()
  (unless (and (stringp buffer-file-name)
               (string-match "\\.md\\'" buffer-file-name))
    (delete-trailing-whitespace)
    ))
(add-hook 'before-save-hook 'my-delete-trailing-whitespace)

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
(setq lua-electric-flag nil)
(setq lua-indent-level 2)

;; (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
;; (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
;; (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
;; (setq lua-indent-level 2)

;; (defun my-lua-undef-keys () ((define-key lua-mode-map "}" nil)
;;                              (define-key lua-mode-map "]" nil)
;;                              (define-key lua-mode-map ")" nil)))
;;           ;;            ;;
;;           ;;            ;; )))

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

;; Set to t for debugging
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
;; (require 'tty-format)
;; ;; (add-hook 'find-file-hooks 'tty-format-guess)

;; ;; it's crazy
;; (require 'bookmark+)

(require 'buffer-move)
(defun win-swap () "Swap windows using buffer-move.el" (interactive) (if (null (windmove-find-other-window 'right)) (buf-move-left) (buf-move-right)))

;; (require 'install-elisp)
;; (setq install-elisp-repository-directory "~/.emacs.d/misc")

(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
;; (put 'ido-exit-minibuffer 'disabled nil)
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


;; set up Unicode
;; http://stackoverflow.com/questions/1674481/how-to-configure-gnu-emacs-to-write-unix-or-dos-formatted-files-by-default
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; This from a japanese individual.  I hope it works.
(set-default buffer-file-coding-system 'utf-8-unix)
;; From Emacs wiki
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
;; MS Windows clipboard is UTF-16LE
;; (if (eq system-type 'windows-nt)
;;   (set-clipboard-coding-system 'utf-16le-dos)
;; )
(set-default default-buffer-file-coding-system 'utf-8-unix)

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
;; TODO also want (back-to-indentation) (next-line) after applied on single line, so that
;; multiple lines can be commented by pressing M-; repeatedly
;; TODO Very Very terrible choice
(global-set-key "\M-;" 'comment-dwim-line)

;; (require 'rvm)
;; (rvm-use-default) ;; use rvm's default ruby for the current Emacs session
;; (ignore-errors
;; (global-rbenv-mode)
;; (setq rbenv-show-active-ruby-in-modeline nil)
;; )

(defun clear-shell ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))


(setq comint-buffer-maximum-size 10240)
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

(require 'thingatpt)
(require 'thing-cmds)

;; When working with tabular data
;; (global-hl-line-mode 1)

;; (setq visible-bell 1)

;; (ctags-update-minor-mode 1)

;; Increase selected region by semantic units
(global-set-key (kbd "C-=") 'er/expand-region)

;; (require 'flymake-ruby)
;; (add-hook 'ruby-mode-hook 'flymake-ruby-load)
(require 'flymake-lua)
(add-hook 'lua-mode-hook 'flymake-lua-load)
(require 'http-twiddle)

(require 'restclient)

(load-library "markerpen")

;; Could be better
(defun esk-sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


;; TODO
;; (setq clean-buffer-list-delay-general 0.2)
;; Supposedly should clear buffers older than 24 hours every 'midnight' (4:30am)
(setq clean-buffer-list-delay-special (* 24 3600))
(require 'midnight)
(midnight-delay-set 'midnight-delay "4:30am")

;; http://ergoemacs.org/emacs/elisp_run_current_file.html
(defun run-current-file ()
  "Execute the current file.
For example, if the current buffer is the file xx.py,
then it'll call “python xx.py” in a shell.
The file can be php, perl, python, ruby, javascript, bash, ocaml, vb, elisp.
File suffix is used to determine what program to run.

If the file is modified, ask if you want to save first.

If the file is emacs lisp, run the byte compiled version if exist."
  (interactive)
  (let* (
         (suffixMap
          `(
            ("php" . "php")
            ("pl" . "perl")
            ("py" . "python")
            ("py3" . ,(if (string-equal system-type "windows-nt") "c:/Python32/python.exe" "python3"))
            ("rb" . "ruby")
            ("js" . "node")             ; node.js
            ("sh" . "bash")
            ("ml" . "ocaml")
            ("vbs" . "cscript")
            ("go" . "go run")
            ("html" . "")
            )
          )
         (fName (buffer-file-name))
         (fSuffix (file-name-extension fName))
         (progName (cdr (assoc fSuffix suffixMap)))
         (cmdStr (concat progName " \""   fName "\""))
         )

    (when (buffer-modified-p)
      (when (y-or-n-p "Buffer modified. Do you want to save first?")
          (save-buffer) ) )
    (cond
     ((string-equal fSuffix "el") (load (file-name-sans-extension fName)))
     ((string-equal fSuffix "html") (browse-url fName))
     (progName (progn
                   (message "Running %s" cmdStr)
                   (shell-command cmdStr "*run-current-file output*" )
                   (message "%s finished" cmdStr)
                   (pop-to-buffer "*run-current-file output*")
                   ))
     (t "No recognized program file suffix for this file."))
     ))

;; Turn off mini window autoresize so that output appear in the separate buffer
;; even if short (and not discarded immediately)
(setq resize-mini-windows nil)

;; change magit diff colors
;; (eval-after-load 'magit
;;   '(progn
;;      (set-face-foreground 'magit-diff-add "green3")
;;      (set-face-foreground 'magit-diff-del "red3")
;;      (when (not window-system)
;;        (set-face-background 'magit-item-highlight "black"))))

(defun find-file-at-point-with-line()
  "if file has an attached line num goto that line, ie boom.rb:12"
  (interactive)
  (setq line-num 0)
  (save-excursion
    (search-forward-regexp "[^ ]:" (point-max) t)
    (if (looking-at "[0-9]+")
        (setq line-num (string-to-number (buffer-substring (match-beginning 0) (match-end 0))))))
  (find-file-at-point)
  (if (not (equal line-num 0))
      (goto-line line-num)))

(defun my-clear ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))


;; Make Jabber messages popup standard notification
(defvar libnotify-program "/usr/bin/notify-send")
(defun notify-send (title message)
  (start-process "notify" " notify"
		 libnotify-program "--expire-time=4000" title message))
(defun libnotify-jabber-notify (from buf text proposed-alert)
  "(jabber.el hook) Notify of new Jabber chat messages via libnotify"
  (when (or jabber-message-alert-same-buffer
            (not (memq (selected-window) (get-buffer-window-list buf))))
    (if (jabber-muc-sender-p from)
        (notify-send (format "(PM) %s"
                             (jabber-jid-displayname (jabber-jid-user from)))
                     (format "%s: %s" (jabber-jid-resource from) text)))
    (notify-send (format "%s" (jabber-jid-displayname from))
                 text)))
(add-hook 'jabber-alert-message-hooks 'libnotify-jabber-notify)

;; 'Fix' 'WARNING: terminal is not fully functional' from less/etc.
(setenv "PAGER" "cat")

;; Focus follows mouse
(setq mouse-autoselect-window t)

;; Clean broken cache :(
;; rm -rf ~/.emacs.d/var/pcache/gh/gh-gist-api/dolzenko
(require 'gist)
(setq gist-view-gist t)

(defun toggle-fullscreen ()
  "Toggle full screen on X11"
  (interactive)
  (when (eq window-system 'x)
    (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth))))
(global-set-key [f11] 'toggle-fullscreen)

;; Show current directory in modeline in shell mode
(defun add-mode-line-dirtrack ()
  (add-to-list 'mode-line-buffer-identification
               '(:propertize (" " default-directory " ") face dired-directory)))
(add-hook 'shell-mode-hook 'add-mode-line-dirtrack)



;; Show last two directories to the current file in modeline
(defun add-ff-mode-line-dirtrack ()
  "When editing a file, show the last 2 directories of the current path in the mode line."
  (add-to-list 'mode-line-buffer-identification
               '(:eval (substring default-directory
                                  (+ 1 (string-match "/[^/]+/[^/]+/$" default-directory)) nil))))
(add-hook 'find-file-hook 'add-ff-mode-line-dirtrack)

;; to get face: c-u c-x =

(set-background-color "cornsilk")

(require 're-builder)
(setq reb-re-syntax 'string)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x C-a") 'ack-and-a-half)

(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode 99)

(ignore-errors (load "~/.emacs.private"))


(setq gnus-select-method '(nnimap "gmail"
                                  (nnimap-address "imap.gmail.com")
                                  (nnimap-server-port 993)
                                  (nnimap-stream ssl)))


(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)


(require 'tramp)
(defun tramp-set-auto-save ()
  (auto-save-mode -1))


(defun url-decode-region (start end)
  "Replace a region with the same contents, only URL decoded."
  (interactive "r")
  (let ((text (url-unhex-string (buffer-substring start end))))
    (delete-region start end)
    (insert text)))

(defun multi-occur-in-all-buffers (regexp)
  (interactive "sRegexp: ")
  (multi-occur-in-matching-buffers "." regexp t))

(require 'shell-switcher)
(setq shell-switcher-new-shell-function 'shell-switcher-make-shell)
(setq shell-switcher-mode t)

(setq wdired-allow-to-change-permissions t)



(loop
  for from across "йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖ\ЭЯЧСМИТЬБЮ№"
  for to   across "qwertyuiop[]asdfghjkl;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>#"
  do
  (eval `(define-key key-translation-map (kbd ,(concat "C-" (string from))) (kbd ,(concat "C-" (string to)))))
  (eval `(define-key key-translation-map (kbd ,(concat "M-" (string from))) (kbd ,(concat "M-" (string to))))))

(defun save-all-and-recompile ()
  (save-some-buffers 1)
  (recompile))

;; (require 'key-chord)
;; (key-chord-define-global "qt" 'rspec-toggle-spec-and-target)
;; (key-chord-define-global "qr" 'recompile)
;; (key-chord-define-global "qs" 'save-buffer)
;; (key-chord-define-global "qc" 'rspec-verify)
;; (key-chord-define-global "qk" 'kill-this-buffer)
;; (key-chord-define-global "qj" 'prelude-switch-to-previous-buffer)
;; (key-chord-define-global "qf" 'find-file)
;; (key-chord-define-global "qb" 'ido-switch-buffer)
;; (key-chord-define-global "qg" 'magit-status)
;; (key-chord-define-global "qe" 'jabber-activity-switch-to)
;; (key-chord-define-global "qo" 'other-window)

;; (defun prelude-switch-to-previous-buffer ()
;;      "Switch to previously open buffer.
;; Repeated invocations toggle between the two most recently open buffers."
;;      (interactive)
;;      (switch-to-buffer (other-buffer (current-buffer) 1)))
;; (key-chord-mode +1)

(load "edit-utils.el")

(setq default-tab-width 2)

(global-set-key (kbd "C-c i") 'inf-ruby)
(global-set-key (kbd "C-c a") 'ack)
(global-set-key (kbd "C-c r") 'toggle-truncate-lines)

(defun align-repeat (start end regexp)
  "Repeat alignment with respect to
     the given regular expression."
  (interactive "r\nsAlign regexp: ")
  (align-regexp start end
                (concat "\\(\\s-*\\)" regexp) 1 1 t))

(require 'highlight-symbol)
;; Search at point (aka super star from Vim)
(global-set-key (kbd "C-*") 'highlight-symbol-next)

;; "Standard selection" - replace the region just by typing , and kill the selected just with Backspace key
(delete-selection-mode 1)

;; (eval-after-load
;;     "filecache"
;;   '(progn
;;      (message "Loading file cache...")
;;      (file-cache-add-directory-using-find "~/n")
;;      (file-cache-add-directory-list load-path)
;;      (file-cache-add-directory "~/")
;;      (file-cache-add-file-list (list "~/foo/bar" "~/baz/bar"))
;;  	   ))

;; M-x file-cache-display

;; Add to file-cache on `kill-buffer'
(defun file-cache-add-this-file ()
  (and buffer-file-name
       (file-exists-p buffer-file-name)
       (file-cache-add-file buffer-file-name)))
(add-hook 'kill-buffer-hook 'file-cache-add-this-file)

;; ;; Display ido completions vertically
;; (setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
;; (defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
;; (add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
;; (defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
;;   (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
;;   (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
;; (add-hook 'ido-setup-hook 'ido-define-keys)

;; Messes with undo
;; (global-undo-tree-mode)


;; 'Visual' window switching (meh)
(require 'switch-window)

;; Remember/switch window layouts with C-c left/right
(winner-mode 1)

(global-set-key [M-left]  'windmove-left)  ; move to left windnow
(global-set-key [M-right] 'windmove-right) ; move to right window
(global-set-key [M-up]    'windmove-up)    ; move to upper window
(global-set-key [M-down]  'windmove-down)  ; move to downer window

(defun move-cursor-next-pane ()
  "Move cursor to the next pane."
  (interactive)
  (other-window 1))

(defun move-cursor-previous-pane ()
  "Move cursor to the previous pane."
  (interactive)
  (other-window -1))

;; Ctrl+x r w/j to remember/switch layout to/from register
(add-hook 'ruby-mode-hook 'yard-mode)
(add-hook 'ruby-mode-hook 'eldoc-mode)

(require 'flymake-jslint)
;; (add-hook 'js-mode-hook 'flymake-jslint-load)

;; make whitespace-mode use just basic coloring
;; (setq whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))

;; Zsh in Shell mode - prevent truncated echoed commands from being printed
(defun my-comint-init ()
  (setenv "COLUMNS" "999")
  (setq comint-process-echoes t))
(add-hook 'shell-mode-hook 'my-comint-init)
(add-hook 'inf-ruby-mode-hook 'my-comint-init)

(global-set-key "\M-l" 'ffap-next)

;; (session-initialize)

;; "Standard selection" - replace the region just by typing , and kill the selected just with Backspace key
(delete-selection-mode 1)

(setq ansi-color-names-vector ["black" "red4" "green4" "yellow4" "blue3" "magenta4" "black" "navy"])
(setq ansi-color-map (ansi-color-make-color-map))
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(require 're-builder)
(setq reb-re-syntax 'string)

;; (define-key global-map [?\s-f] 'ido-find-file)
;; (define-key global-map [?\s-b] 'ido-switch-buffer)
;; (define-key global-map [?\s-s] 'save-buffer)
;; (define-key global-map [?\s-k] 'kill-this-buffer)
;; (define-key global-map [?\s-s] 'save-buffer)

;; (define-key global-map [?\s-e] 'next-buffer)
;; (define-key global-map [?\s-a] 'previous-buffer)
;; (define-key global-map [?\s-t] 'rspec-toggle-spec-and-target)
;; (define-key global-map [?\s-g] 'google)

(defun transpose-buffers (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))
(global-set-key (kbd "C-x 4 t") 'transpose-buffers)


(defun frame-bck()
  (interactive)
  (other-window -1)
  )
(define-key (current-global-map) (kbd "M-o") 'other-window)
(define-key (current-global-map) (kbd "M-t") 'transpose-buffers)
(define-key (current-global-map) (kbd "M-O") 'frame-bck)
(global-set-key (kbd "C-c f") 'projectile-find-file)

(defun insert-single-quotes (&optional arg)
  "Enclose following ARG sexps in quotation marks. Leave point after open-paren."
  (interactive "*P")
  (insert-pair arg ?\' ?\'))

(defun insert-double-quotes (&optional arg)
  "Enclose following ARG sexps in quotes. Leave point after open-quote."
  (interactive "*P")
  (insert-pair arg ?\" ?\"))

;; Remove highlight of current section in magit diff
;; https://github.com/magit/magit/pull/994/commits
(set-face-background 'secondary-selection "cornsilk")

;; (require 'visible-mark)
;; (require 'auto-mark)

(setq bookmark-save-flag 1)

;; ruby-send-line
;; (fset 'x
;;    (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 67108896 5 3 18] 0 "%d")) arg)))

(projectile-global-mode)
;; (flx-ido-mode 1)
;; disable ido faces to see flx highlights.
;; (setq ido-use-faces nil)

(require 'align)
;; Make M-x align know what to do
(add-to-list 'align-rules-list
             '(ruby-comma-delimiter
               (regexp . ",\\(\\s-*\\)[^# \t\n]")
               (repeat . t)
               (modes  . '(enh-ruby-mode))))
(add-to-list 'align-rules-list
             '(ruby-hash-literal
               (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
               (repeat . t)
               (modes  . '(enh-ruby-mode))))

(add-to-list 'align-rules-list
             '(ruby-assignment-literal
               (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
               (repeat . t)
               (modes  . '(enh-ruby-mode))))
(add-to-list 'align-rules-list          ;TODO add to rcodetools.el
             '(ruby-xmpfilter-mark
               (regexp . "\\(\\s-*\\)# => [^#\t\n]")
               (repeat . nil)
               (modes  . '(enh-ruby-mode))))

(require 'yasnippet)
(yas-global-mode 1)

(defun ruby-send-line (&optional arg)
  (interactive "p")
  (ruby-send-region (point-at-bol 1) (point-at-eol arg))
  )
(define-key ruby-mode-map (kbd "C-c C-e") 'ruby-send-line)

(eval-after-load 'image-mode '(require 'image-dimensions-minor-mode))

;; (require 'auto-complete)
;; (require 'go-autocomplete)
;; (require 'auto-complete-config)
;; (define-key ac-mode-map (kbd "M-?") 'auto-complete)

(require 'xfrp_find_replace_pairs)

(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; Go
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(add-to-list 'load-path (concat (getenv "GOPATH") "/src/github.com/golang/lint/misc/emacs"))
(ignore-errors (require 'golint))

(ignore-errors
(load (concat (getenv "GOPATH") "/src/code.google.com/p/go.tools/cmd/oracle/oracle.el"))
)
(setq go-oracle-command (concat (getenv "GOPATH") "/bin/oracle"))

(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "M-.") #'godef-jump)))

(add-hook 'go-mode-hook 'go-eldoc-setup)

;; Monkey-patch to default to "_test" suffix for Go support
(defun projectile-test-suffix (project-type)
  "Find test files suffix based on PROJECT-TYPE."
  (cond
   ((member project-type '(rails-rspec ruby-rspec)) "_spec")
   ((member project-type '(rails-test ruby-test lein)) "_test")
   ((member project-type '(maven symfony)) "Test")
   (t "_test")))

(require 'git-link)

(require 'rcodetools)
(require 'bundler)

(when window-system (global-unset-key "\C-z"))

(setq-default fill-column 80)
(ignore-errors
(require 'flymake-cursor)
)

;; ;; Highlight long lines
;; (require 'whitespace)
;; (global-whitespace-mode t)
;; (setq whitespace-line-column 100)
;; (setq whitespace-style '(face lines-tail))

(ignore-errors
(require 'dired-subtree)
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "i") 'dired-subtree-insert)
            ))
)

;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
;; (ac-config-default)

;; http://stackoverflow.com/questions/3072648/cucumbers-ansi-colors-messing-up-emacs-compilation-buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(global-set-key (kbd "C-c r") 'recompile)
(setq compilation-ask-about-save nil)

(ignore-errors
(require 'discover)
(global-discover-mode 1)
)

(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-c" "C-x"))
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/idle-delay 0.8)
(setq guide-key/popup-window-position 'bottom)
(guide-key-mode 1) ; Enable guide-key-mode

(load "comint-kill-output-to-kill-ring")
(add-hook 'comint-mode-hook
  (lambda()
   (define-key comint-mode-map [(control c) (control o)] 'comint-kill-output-to-kill-ring)))

;; Unbind C-x o and use M-o exclusively
(define-key ctl-x-map "o" 'other-window)

(global-set-key (kbd "C-c k") 'browse-kill-ring)

;; Complete snippets with ido
;; (setq yas-prompt-functions '(yas-ido-prompt))

;; Unbind conflicting dired-omit-mode binding from dired-x.el
(defun my-dired-hook ()
  (define-key dired-mode-map "\M-o" nil))
(add-hook 'dired-mode-hook 'my-dired-hook)

(load "~/.emacs.d/helm.el")

(setq git-link-open-in-browser t)

;; (require 'dirtrack)
(add-hook 'shell-mode-hook
          (lambda ()
            (shell-dirtrack-mode 1)
            ;; (dirtrack-mode 1)
            ))
;; (setq-default dirtrack-list '("^\\(.+?\\) \\$" 1))
(require 'auto-complete)
(global-auto-complete-mode t)

(add-hook 'ruby-mode-hook
          (lambda ()
            (smartscan-mode 1)
            ))

(add-hook 'go-mode-hook
          (lambda ()
            (smartscan-mode 1)
            ))

(add-hook 'coffee-mode-hook
          (lambda ()
            (smartscan-mode 1)
            ))


;; (require 'misc)
;; (global-set-key (kbd "M-f") 'forward-to-word)
;; (global-set-key (kbd "M-b") 'backward-to-word)

(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
  (when mark-ring
    (let ((pos (marker-position (car (last mark-ring)))))
      (if (not (= (point) pos))
          (goto-char pos)
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) pos)
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (marker-position (car (last mark-ring))))))))
(global-set-key (kbd "C-c C-SPC") 'unpop-to-mark-command)


(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
(define-key yas-minor-mode-map (kbd "C-o") 'yas-expand)

(totd-start)
(setq magit-last-seen-setup-instructions "1.4.0")

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(defun ruby-eval-region()
  "Prints the evaluation of Ruby statements in region to a new output buffer"
  (interactive)
  (let ((output-buffer "Ruby Output"))
    (shell-command-on-region (mark) (point) "ruby" output-buffer)
    (switch-to-buffer output-buffer)))

(defun ruby-pretty-print()
  "Pretty prints the evaluation of a Ruby expression in region to a new output buffer"
  (interactive)
  (save-excursion
    (let ((code (buffer-substring (mark) (point)))
          (code-buffer (generate-new-buffer "ruby-code")))
      (switch-to-buffer code-buffer)
      (insert (concat "require 'pp'\nputs (" code ")\n"))
      (mark-whole-buffer)
      (ruby-eval-region)
      (kill-buffer code-buffer))))

(defun increment-number-at-point ()
  (interactive)
  (skip-chars-backward "0123456789")
  (or (looking-at "[0123456789]+")
      (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))
(global-set-key (kbd "C-c +") 'increment-number-at-point)

;; Make shure shell-switcher knows about all shell buffers
(add-hook 'shell-mode-hook 'shell-switcher-manually-register-shell)

;; Show current folder in window title
(setq frame-title-format '((:eval default-directory)))

(require 'editorconfig)
(editorconfig-mode 1)

;; Allows to replace UNIX timestamps with formatted date.
;; Use \,(format-timestamp) as a replacement string.
(defun format-timestamp ()
  "replaces timestamp with formatted date (use [0-9]\{10\} as query)"
  (format-time-string "%Y-%m-%d %T UTC" (seconds-to-time (string-to-number (match-string 0))))
  )

(require 'epoch-view)

(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-2") 'split-window-below)
(global-set-key (kbd "C-3") 'split-window-right)
(global-set-key (kbd "C-0") 'delete-window)


(defun sudo-edit-current-file ()
  (interactive)
  (let ((my-file-name) ; fill this with the file to open
        (position))    ; if the file is already open save position
    (if (equal major-mode 'dired-mode) ; test if we are in dired-mode
        (progn
          (setq my-file-name (dired-get-file-for-visit))
          (find-alternate-file (prepare-tramp-sudo-string my-file-name)))
      (setq my-file-name (buffer-file-name); hopefully anything else is an already opened file
            position (point))
      (find-alternate-file (prepare-tramp-sudo-string my-file-name))
      (goto-char position))))


(defun prepare-tramp-sudo-string (tempfile)
  (if (file-remote-p tempfile)
      (let ((vec (tramp-dissect-file-name tempfile)))

        (tramp-make-tramp-file-name
         "sudo"
         (tramp-file-name-user nil)
         (tramp-file-name-host vec)
         (tramp-file-name-localname vec)
         (format "ssh:%s@%s|"
                 (tramp-file-name-user vec)
                 (tramp-file-name-host vec))))
    (concat "/sudo:root@localhost:" tempfile)))

(define-key dired-mode-map [s-return] 'sudo-edit-current-file)

(load "~/.emacs.private.el")
(beacon-mode 1)
(setq beacon-push-mark 35)
(setq beacon-color "#666600")

(require 'protobuf-mode)
(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . t)))

(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))

(toggle-scroll-bar -1)
(sml-modeline-mode)
