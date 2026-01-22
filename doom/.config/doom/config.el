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
(setq doom-font (font-spec :family "0xProto Nerd Font Mono" :size 20 :weight 'regular)
     doom-variable-pitch-font (font-spec :family "Hoefler Text" :size 24 :weight 'regular))

(after! org-modern
  ;; Force these settings to apply
  (setq org-modern-star 'replace)
  (setq org-modern-replace-stars '("🌺" "🌸" "" "🌱"))
  (setq org-modern-list '((?+ . "❱") (?- . "●") (?* . "·")))
  (setq org-modern-checkbox '((?\s . "○") (?X . "⦿") (?- . "◑"))))

;; Enable mixed-pitch-mode to actually USE Hoefler Text in Org
(add-hook! 'org-mode-hook #'mixed-pitch-mode)
;; Disable indent guides in Org mode to fix the "random dashes" artifact
(remove-hook! 'org-mode-hook #'highlight-indent-guides-mode)
;; Enable visual-line-mode automatically for org files
(add-hook! 'org-mode-hook #'visual-line-mode)
(setq nerd-icons-font-family "0xProto Nerd Font Mono")
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-pro)

;; Splash screen/dashboard image
(setq fancy-splash-image (concat doom-user-dir "splash.png"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")
(setq org-agenda-files '("~/Documents/org/gtd/"))
(setq org-roam-directory "~/Documents/org/roam/")
(setq org-log-done 'time)

;; workflow states (Sequence of Todo -> Done)
(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)")))

  (setq org-capture-templates
        '(("t" "Todo" entry 
           (file+headline "inbox.org" "Inbox") 
           "* TODO %?" 
           :prepend t        ;; Add to top of Inbox
           :kill-buffer t    ;; Close file after capturing
           :empty-lines 0)   ;; No extra empty lines
          ))

        ;; Allow creating new nodes during refile by appending "/New Headline"
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  
  ;; Use full outline paths (e.g., "projects.org/Project Alpha/Task")
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  ;; Log the time when you finish a task (like Things logbook)
  (setq org-log-done 'time)
  )

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
(use-package! gptel
  :config
  (map! :leader
        :prefix ("l" . "llm")
        :desc "GPTel Chat"        "c" #'gptel
        :desc "GPTel Send"        "s" #'gptel-send
        :desc "GPTel Menu"        "m" #'gptel-menu
        :desc "GPTel Rewrite"     "r" #'gptel-rewrite
        :desc "GPTel Add Context" "a" #'gptel-add)
  
  (setq gptel-max-tokens 65535)
  
  (setq gptel-model "claude-sonnet-4-5-20250929-v1:rsn"
        gptel-backend
        (gptel-make-anthropic "OrgClaude"
          :host "engine.pair.gov.sg"
          :protocol "https"
          :stream t
          :endpoint "/v1/messages"
          :models '("claude-sonnet-4-5-20250929-v1:rsn")
          :header (lambda () `(("x-api-key" . ,(getenv "SONNET_45_API_KEY"))
                               ("anthropic-version" . "2023-06-01"))))))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("M-n" . 'copilot-next-completion)
              ("M-p" . 'copilot-previous-completion))

  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(clojure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))
