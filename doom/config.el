;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Cartograph CF"
                           :size 14
                           :weight 'semi-light) doom-variable-pitch-font (font-spec :family "Menlo"
                           :size 14))

(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(setq gc-cons-threshold most-positive-fixnum)  ;; Disable GC during startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 100000000)  ;; Set a higher threshold for GC after startup
            (setq gc-cons-percentage 0.1)))  ;; Set the percentage of memory for GC triggering
(setq scroll-conservatively 101)
(setq scroll-preserve-screen-position t)
(setq redisplay-dont-pause t)  ;; Don't pause redisplay during input
(setq redisplay-skip-fontification-on-input t)  ;; Skip fontification during typing
(setq mac-allow-anti-aliasing t)
(setq native-comp-deferred-compilation t)  ;; Enable deferred native compilation
(setq native-comp-async-report-warnings-errors 'silent)  ;; Disable warnings during async compilation


;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely wasn't installed correctly. Font issues are rarely Doom issues! (use-package! base16-theme

(use-package! apheleia 
  :config (apheleia-global-mode +1))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-flatwhite)


;;(after! org-habit
  ;;;; Use doom-color to get the correct color for each habit state
;;(set-face-attribute org-habit-clear-face nil :background (doom-color 'green))
;;(set-face-attribute org-habit-overdue-face nil :background (doom-color 'red))
;;(set-face-attribute org-habit-today-face nil :background (doom-color 'blue))
;;(set-face-attribute org-habit-ready-face nil :background (doom-color 'yellow))
;;(set-face-attribute org-habit-alert-face nil :background (doom-color 'orange))
;;(set-face-attribute org-habit-alert-future-face nil :background (doom-color 'purple))
;;(set-face-attribute org-habit-clear-future-face nil :background (doom-color 'cyan))
;;(set-face-attribute org-habit-ready-future-face nil :background (doom-color 'pink))
;;(set-face-attribute org-habit-overdue-future-face nil :background (doom-color 'gray)))

;; Org mode configuration
(after! org

  (setq

   org-hierarchical-todo-statistics nil
   org-agenda-time-grid '((require-timed remove-match)
                          ()
                          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")

   org-agenda-remove-tags t
   org-agenda-include-diary t
   org-agenda-custom-commands
   '(("c" "Agenda for 2 days in the past and 2 days in the future"
      ((agenda "" ((org-agenda-start-day "-2d")
                   (org-agenda-span 5)
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-show-all-dates nil))))))

   org-habit-preceding-days 12
   org-habit-following-days 3
   +org-habit-graph-window-ratio 0.2
   ;;org-habit-graph-column 20
   org-habit-show-habits-only-for-today nil

   org-agenda-start-with-log-mode t   ;; Start agenda with log mode enabled
   org-agenda-log-mode-items '(state) ;; Show state changes (including DONE)
   org-hide-emphasis-markers nil
   ;;org-agenda-dim-blocked-tasks nil
   org-agenda-ignore-properties '(stats)
   org-pretty-entities t
   ;;org-log-done 'time
   org-agenda-show-future-repeats 'all
   org-modules '(org-habit)))


(defun my/org-agenda-set-margins ()
  "Center the Org Agenda buffer by adjusting margins."
  (when (derived-mode-p 'org-agenda-mode)
    (let* ((margin-size (/ (- (frame-width) 60) 2)))  ;; Adjust 80 for preferred content width
      (setq left-margin-width margin-size
            right-margin-width margin-size)
      (set-window-buffer (selected-window) (current-buffer))))) ;; Force update
(add-hook 'org-agenda-mode-hook #'my/org-agenda-set-margins)
(add-hook 'window-configuration-change-hook #'my/org-agenda-set-margins)




;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")







(after! evil-snipe
  (setq evil-snipe-mode +1)
  (setq evil-snipe-override-mode +1))


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
