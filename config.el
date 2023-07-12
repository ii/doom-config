;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(if (getenv "GIT_AUTHOR_NAME")
  (setq user-full-name (getenv "GIT_AUTHOR_NAME"))
    )
(if (getenv "GIT_AUTHOR_EMAIL")
  (setq user-mail-address (getenv "GIT_AUTHOR_EMAIL"))
    )

(setq doom-localleader-key ",")
(setq fancy-splash-image (concat doom-user-dir "banners/kubemacs.png"))

(setq display-line-numbers-type t)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-city-lights)
;; (setq doom-theme 'doom-xcode)
;; (setq doom-theme 'doom-zenburn)
;; (setq doom-theme 'doom-vibrant)
;; (setq doom-theme 'doom-tomorrow-night)
;; (setq doom-theme 'doom-spacegrey)
;; (setq doom-theme 'doom-solarized-dark)
;; (setq doom-theme 'doom-acario-light)
;; (setq doom-theme 'doom-tomorrow-day)
;; (setq doom-theme 'doom-tokyo-night)
;; (setq doom-theme 'doom-solarized-light)
;; (setq doom-theme 'doom-solarized-dark-high-contrast)
;; (setq doom-theme 'doom-dark+)
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! ii-pair)
(use-package! ox-gfm)
(use-package! ob-async)
(after! ii-pair
  (osc52-set-cut-function)
  (setq
   ;; No prefix wanted, makes it messy
   org-babel-tmux-session-prefix ""
   ;; Default to ii / pair
   org-babel-tmux-default-window-name "ii"
   ;; We don't laurch terminals in the cloud
   org-babel-tmux-terminal "true"
   ;; true dosen't need arguments
   org-babel-tmux-terminal-opts '(
                                  ;; "--hold"
                                  ;; "--single-instance"
                                  ;; "--start-as=normal"
                                  )
   ;; default to targeting the 'right eye'
   org-babel-default-header-args:tmux
    `((:results . "silent")
      (:session . ,(if (getenv "SESSION_NAME")
                    (getenv "SESSION_NAME")
                  "org"))
      (:socket .
             ;; if emacs is run within tmux/tmate
             ;; let's go ahead and use our existing socket
             ;; otherwise we are likely wanting to launch our own
             ,(if (getenv "TMUX")
                 (car (split-string (getenv "TMUX") ","))
               (symbol-value nil)))
      )
    )
  )
(after! ob-tmux
  ;; FIXME: hardcoded "default" session name should be pulled from headr args
  (defun ob-tmux--tmux-session (org-session)
    "Extract tmux session from ORG-SESSION string."
    (let* ((session (car (split-string org-session ":"))))
      (concat org-babel-tmux-session-prefix
        (if (string-equal "" session) (alist-get :session org-babel-default-header-args:tmux) session))))
  )
(after! ob-sql-mode
        ;; make sql statements a one-liner before being sent to sql engine
  (setq org-babel-sql-mode-pre-execute-hook
        (lambda (body params)
          (s-replace "\n" " " body))))
(after! org
  (setq org-babel-default-header-args
      '((:session . "none")
        (:results . "replace")
        (:comments . "org")
        (:exports . "both")
        (:eval . "never-export")
        (:tangle . "no")))
  (setq org-babel-default-header-args:shell
      '((:results . "output code verbatim replace")
        (:wrap . "example")))
  (setq org-babel-default-header-args:sql-mode
      '((:results . "replace verbatim")
        (:product . "postgres")))
 (setq sql-postgres-login-params
      '((user :default "postgres")
        (database :default "postgres")
        (server :default "localhost")
        (port :default 5432)))
  )
;; Add helper functions

(defun ii-ob-clear-all-results ()
  "Clear all result blocks in current org-mode buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (org-babel-next-src-block)
      (org-babel-remove-result))))

 (defun ii-ob-clear-results-region (start end)
   "Clear all result blocks in selection region of org-mode buffer."
   (interactive "r")
   (save-excursion
     (save-restriction
       (narrow-to-region start end)
       (goto-char 1)
       (while (org-babel-next-src-block)
         (org-babel-remove-result)))))

 (defun ii-ob-clear-results-subtree ()
   "Clear all result blocks of subtree at point."
   (interactive)
   (save-excursion
     (goto-char (point))
       (org-mark-subtree)
       (ii-ob-clear-results-region (point) (mark))))

;; Add Org AI src blocks

(use-package! org-ai
  :config
    (add-hook 'org-mode-hook #'org-ai-mode)
    (org-ai-install-yasnippets)
    (setq org-ai-openai-api-token (getenv "OPENAI_API_TOKEN"))
  )

