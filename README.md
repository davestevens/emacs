#Emacs Config Files#

My .emacs file and other emacs config files I use.

##Notes##

###jslint###
This takes from a few different posts as I couldn't get it working following them exactly

1. Install node ```brew install node```
2. Get node jslint ```sudo npm install -g jslint```
3. Add jslint to PATH ````PATH=$PATH:/usr/local/share/npm/lib/node_modules/jslint/bin```
4. Get flymake-cursor.el ```curl http://www.emacswiki.org/emacs/download/flymake-cursor.el > ~/.elisp/flymake-mode.el```
5. Edit .emacs file
```
;; Make sure your load path is setup
(add-to-list 'load-path "~/.elisp")

;; Setup Jslint flymake-mode
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

;; js-mode hook configurations
;; jslint does not like tabs
(setq js-indent-level 4) ;; Set to 4 else jslint shows errors about whitespace
(setq-default indent-tabs-mode nil)
;; add hook to start flymake-mode with js-mode
(add-hook 'js-mode-hook
	  (lambda ()
	    (flymake-mode 1)
	    (define-key js-mode-map "\C-c\C-n" 'flymake-goto-next-error)))
```
