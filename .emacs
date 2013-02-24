(setq-default show-trailing-whitespace t)

;; C Configurations
(setq c-default-style "bsd")
(c-set-offset 'case-label '+)
(c-set-offset 'statement-case-open 0)
(setq-default tab-width 8) ; or any other preferred value
(setq cua-auto-tabify-rectangles nil)
(defadvice align (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice align-regexp (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice indent-relative (around smart-tabs activate)
  (let ((indent-tabs-mode nil)) ad-do-it))
(defadvice indent-according-to-mode (around smart-tabs activate)
  (let ((indent-tabs-mode indent-tabs-mode))
    (if (memq indent-line-function
              '(indent-relative
                indent-relative-maybe))
        (setq indent-tabs-mode nil))
    ad-do-it))
(defmacro smart-tabs-advice (function offset)
  (defvaralias offset 'tab-width)
  `(defadvice ,function (around smart-tabs activate)
     (cond
      (indent-tabs-mode
       (save-excursion
         (beginning-of-line)
         (while (looking-at "\t*\\( +\\)\t+")
           (replace-match "" nil nil nil 1)))
       (setq tab-width tab-width)
       (let ((tab-width fill-column)
             (,offset fill-column))
         ad-do-it))
      (t
       ad-do-it))))
(smart-tabs-advice c-indent-line c-basic-offset)
(smart-tabs-advice c-indent-region c-basic-offset)

;; Load path
(add-to-list 'load-path "~/.elisp")

;; Whitespace Mode
(load "whitespace")

;; PHP Mode
(load "php-mode")
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
(custom-set-variables
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil))
(add-hook 'php-mode-hook
	  (lambda ()
	    (whitespace-mode 1)))

;; Ruby Mode
(load "ruby-mode")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (whitespace-mode 1)
	    (local-set-key "\r" 'newline-and-indent)))

;; YAML Mode
(load "yaml-mode")
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; jslint
(when (load "flymake" t)
  (defun flymake-jslint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "jslint.js" (list "--terse" local-file))))
  (setq flymake-err-line-patterns
	(cons '("^\\(.*\\)(\\([[:digit:]]+\\)):\\(.*\\)$"
		1 2 nil 3)
	      flymake-err-line-patterns))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js\\'" flymake-jslint-init))
  (require 'flymake-cursor))

;; JS Mode
(setq js-indent-level 4) ;; Set to 4 else jslint shows errors about whitespace
(setq-default indent-tabs-mode nil)
(add-hook 'js-mode-hook
	  (lambda ()
	    (flymake-mode 1)
	    (whitespace-mode 1)
	    (define-key js-mode-map "\C-c\C-n" 'flymake-goto-next-error)))

;; Whitespace Configurations
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. ℯℊ (insert-char 182 1)
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
        (newline-mark 10 [182 10]) ; 10 LINE FEED
        (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
        ))
(custom-set-faces
 '(whitespace-space ((t nil))))
