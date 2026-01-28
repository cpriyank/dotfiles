;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; -----------------------
;; UI / fonts
;; -----------------------
(setq doom-font (font-spec :family "0xProto Nerd Font Mono" :size 20 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Avenir Next" :size 24 :weight 'regular)
      nerd-icons-font-family "0xProto Nerd Font Mono"
      doom-theme 'doom-monokai-pro
      fancy-splash-image (concat doom-user-dir "splash.png")
      display-line-numbers-type 'relative)

;; -----------------------
;; Org paths (set before org loads)
;; -----------------------
(setq org-directory "~/Documents/org/"
      org-agenda-files '("~/Documents/org/gtd/")
      org-roam-directory "~/Documents/org/roam/")

;; -----------------------
;; Org look & feel
;; -----------------------
(after! org-modern
  (setq org-modern-star 'replace
        org-modern-replace-stars '("🌺" "🌸" "☸︎" "🌱")
        org-modern-list '((?+ . "❱") (?- . "●") (?* . "·"))
        org-modern-checkbox '((?\s . "○") (?X . "⦿") (?- . "◑"))))

(custom-set-faces!
  '(org-quote :slant italic :inherit variable-pitch))

(defun orca/org-setup ()
  (mixed-pitch-mode 1)
  (visual-line-mode 1)
  (visual-fill-column-mode 1))

(add-hook! org-mode #'orca/org-setup)

(after! org
  (add-hook! org-mode (setq-local line-spacing 0.15))
  (custom-set-faces!
    '(org-document-title :weight regular :height 1.15)
    '(org-level-1 :inherit outline-1 :weight regular :height 1.10)
    '(org-level-2 :inherit outline-2 :weight regular :height 1.06)
    '(org-level-3 :inherit outline-3 :weight regular :height 1.03)
    '(org-level-4 :inherit outline-4 :weight regular :height 1.00))
  (setq org-log-done 'time
        org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)"))
        org-capture-templates
        '(("t" "Todo" entry
           (file+headline "inbox.org" "Inbox")
           "* TODO %?"
           :prepend t
           :kill-buffer t
           :empty-lines 0))
        org-refile-allow-creating-parent-nodes 'confirm
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil))

;; -----------------------
;; Pandoc helpers (clipboard conversions)
;; -----------------------
(defun orca/paste-markdown-as-org ()
  "Convert clipboard markdown to org and insert at point."
  (interactive)
  (let ((markdown (current-kill 0)))
    (insert
     (with-temp-buffer
       (insert markdown)
       (shell-command-on-region (point-min) (point-max)
                                "pandoc -f markdown -t org" t t)
       (buffer-string)))))

(defun orca/copy-org-as-markdown ()
  "Convert region from org to markdown and copy to clipboard."
  (interactive)
  (when (use-region-p)
    (let ((org-text (buffer-substring-no-properties (region-beginning) (region-end))))
      (with-temp-buffer
        (insert org-text)
        (shell-command-on-region (point-min) (point-max)
                                 "pandoc -f org -t markdown" t t)
        (kill-ring-save (point-min) (point-max)))
      (deactivate-mark)
      (message "Copied as Markdown"))))

;; -----------------------
;; GPTel
;; -----------------------
(use-package! gptel
  :commands (gptel gptel-send gptel-menu gptel-rewrite gptel-add)
  :config
  (setq gptel-max-tokens 65535
        gptel-model "claude-sonnet-4-5-20250929-v1:rsn"
        gptel-backend
        (gptel-make-anthropic "OrgClaude"
          :host "engine.pair.gov.sg"
          :protocol "https"
          :stream t
          :endpoint "/v1/messages"
          :models '("claude-sonnet-4-5-20250929-v1:rsn")
          :header (lambda ()
                    `(("x-api-key" . ,(getenv "SONNET_45_API_KEY"))
                      ("anthropic-version" . "2023-06-01")))))

  (map! :leader
        (:prefix ("l" . "llm")
         :desc "GPTel Chat"        "c" #'gptel
         :desc "GPTel Send"        "s" #'gptel-send
         :desc "GPTel Menu"        "m" #'gptel-menu
         :desc "GPTel Rewrite"     "r" #'gptel-rewrite
         :desc "GPTel Add Context" "a" #'gptel-add)
        (:prefix ("y" . "yank/paste convert")
         :desc "Paste MD as Org" "p" #'orca/paste-markdown-as-org
         :desc "Copy Org as MD"  "y" #'orca/copy-org-as-markdown)))

;; -----------------------
;; Copilot
;; -----------------------
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . copilot-accept-completion)
              ("TAB" . copilot-accept-completion)
              ("C-<tab>" . copilot-accept-completion-by-word)
              ("C-TAB" . copilot-accept-completion-by-word)
              ("M-n" . copilot-next-completion)
              ("M-p" . copilot-previous-completion))
  :config
  (dolist (pair '((prog-mode . 2)
                  (org-mode . 2)
                  (text-mode . 2)
                  (clojure-mode . 2)
                  (emacs-lisp-mode . 2)))
    (add-to-list 'copilot-indentation-alist pair)))
