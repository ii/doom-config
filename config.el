;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

(setq doom-localleader-key ",")
(setq fancy-splash-image "~/.config/doom/banners/kubemacs.png")

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
(setq doom-theme 'doom-one)

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
      (:session . ,(if (getenv "HOSTNAME")
                    (getenv "HOSTNAME")
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
  ;; FIXME: hardcoded "default" session name should be pulled from headr args
  (defun ob-tmux--tmux-session (org-session)
    "Extract tmux session from ORG-SESSION string."
    (let* ((session (car (split-string org-session ":"))))
      (concat org-babel-tmux-session-prefix
        (if (string-equal "" session) (assq :session org-babel-default-header-args:tmux) session))))
  )

(after! org
  (setq org-babel-default-header-args
      '((:session . "none")
        (:results . "replace code")
        (:comments . "org")
        (:exports . "both")
        (:eval . "never-export")
        (:tangle . "no")))

(setq org-babel-default-header-args:shell
      '((:results . "output code verbatim replace")
        (:wrap . "example")))
  )
