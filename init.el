;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;;
;; init.el

;;;;;;;;;;;;;;;;;;
;;  Load-path  ;;
;;;;;;;;;;;;;;;;;;

;;; add-to-load-path
;;; load-pathを追加する関数
;;; 引数のディレクトリ内のサブディレクトリもロードパスに追加することが可能
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "auto-install" "elisp" "elpa" "insert")

;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Basic Settings  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
; 言語環境を日本語に設定
(set-language-environment 'Japanese)
; テキストエンコーディングをutf-8に指定
(prefer-coding-system 'utf-8)
; ツールバー、メニューバー、スクロールバーを表示しない
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
; バッファの左側に行数を表示する
(global-linum-mode 1)
; 現在行に着色
(global-hl-line-mode 1)
; 対応する括弧を強調
(show-paren-mode 1)
; モードラインに行数・桁数を表示
(line-number-mode 1)

(column-number-mode 1)
; 選択範囲の色
(set-face-background 'region "#128")
; 選択範囲を強調
(transient-mark-mode 1)
; 履歴を保存
(savehist-mode 1)
; 保存時のカーソル位置を記憶する
(require 'saveplace)
(setq-default save-place t)
(setq use-dialog-box nil)
; ダイアログボックスを使わない
(defalias 'message-box 'message)
; 起動時に '*About GNU Emacs' バッファを表示しない
(setq inhibit-startup-screen t)
; タブ文字を使わない
(setq-default indent-tabs-mode nil)
; タブはスペース2つぶんにする
(custom-set-variables '(tab-width 2))
; 行末の空白を強調
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")
; フレームのタイトルを 'Emacs' にする
(setq frame-title-format "Emacs@%b")
; フォントをRictyにする
(add-to-list 'default-frame-alist '(font . "ricty-9"))
; バックアップファイルを作成しない
(setq make-backup-files nil)
; '*scratch*' バッファの内容を変更(ここでは何も書かれてない状態)
(setq initial-scratch-message "")
; サイズが25MB以上のファイルを読み込むときには警告する
(setq large-filek-warning-threshold (* 25 1024 1024))
; 'yes-or-no-p' の代わりに 'y-or-n-p' を使う
(fset 'yes-or-no-p 'y-or-n-p)
; C-RETで矩形選択
; 詳しいキーバインド操作: http://dev.ariel-networks.com/articles/emacs/part5/
(when (cua-mode t)
  (setq cua-enable-cua-keys nil)
  ;;キルリングとクリップボードの内容を共有する
  (cond (window-system
         (setq x-select-enable-clipboard t)
         ))
  (global-set-key (kbd "C-y") 'clipboard-yank)
  (setq x-select-enable-clipboard t))
;; autoinsert.el
(auto-insert-mode)
(setq auto-insert-directory "~/.emacs.d/insert/")
(define-auto-insert "\\.el$" "elisp-template.el")
(define-auto-insert "\\.rb$" "ruby-template.rb")
(define-auto-insert "\\.pl$" "perl-template.pl")
; keybindings set
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x C-j") 'skk-mode)
;; C-up,down,left,right でバッファサイズを変更
(global-set-key [C-up]   'shrink-window)
(global-set-key [C-down] 'enlarge-window)
(global-set-key [C-left]  'shrink-window-horizontally)
(global-set-key [C-right] 'enlarge-window-horizontally)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-o") 'other-window)
;; keybindings unset
(global-unset-key (kbd "C-x C-c"))
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x o"))
;;; EShell
;; PATHの設定
(setq eshell-path-env '(lambda () (getenv "$PATH")))
; 補完時に大文字と小文字を区別しない
(setq eshell-cmpl-ignore-case t)
; 確認なしでヒストリー保存
(setq eshell-ask-to-save-history (quote always))
; 補完時にサイクルする
(setq eshell-cmpl-cycle-completions t)
; 補完候補がこの数値以下だとサイクルせずに候補表示
(setq eshell-cmpl-cycle-cutoff-length 5)
;  履歴で重複を無視する
(setq eshell-hist-ignoredups t)
;; プロンプト文字列の変更
(setq eshell-prompt-function
      (lambda ()
        (concat "[shinraks@x61s-gentoo "
                (eshell/pwd)
                (if (= (user-uid) 0) "]\n# " "]\n$ "))))
; 変更したprompt文字列に合う形でpromptの初まりを指定(C-aで"$ "の次にカーソルがくるようにする)
; これの設定を上手くしとかないとタブ補完も効かなくなるっぽい(らしい)
(setq eshell-prompt-regexp "^[^#$]*[$#] ")
;; キーバインドの変更
(add-hook 'eshell-mode-hook
          '(lambda ()
             (progn
               (define-key eshell-mode-map "\C-a" 'eshell-bol)
               (define-key eshell-mode-map "\C-p" 'eshell-previous-matching-input-from-input)
               (define-key eshell-mode-map "\C-n" 'eshell-next-matching-input-from-input)
               )
             ))
; EShell起動時は行末の空白を強調表示しない
(add-hook 'eshell-mode-hook (lambda () (setq show-trailing-whitespace nil)))
; Emacs起動時にEShellを起動する
(add-hook 'after-init-hook (lambda () (eshell)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  External Package Settings  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto-install.el
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/auto-install")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; auto-async-byte-compile.el
(when (require 'auto-async-byte-compile nil t)
  (setq auto-async-byte-compile-exclude-files-regexp "init.el")
  (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode))

;; anything.el
(when (require 'anything-startup nil t)
  (define-key anything-map "\C-\M-p" 'anything-previous-source)
  (define-key anything-map "\C-\M-n" 'anything-next-source)
  (global-set-key (kbd "C-x b") 'anything-for-files)
  (define-key anything-map "\C-j" 'anything-exit-minibuffer)
  (setq anything-candidate-number-limit 10)
  (setq anything-input-idle-delay 0.1)
  (setq anything-idle-delay 0.5)
  (setq anything-quick-update t)
  (global-set-key (kbd "M-y") 'anything-show-kill-ring))

;; anything-c-moccur
(when (require 'color-moccur nil t)
  (when (require 'anything-c-moccur)
    (setq moccur-split-word t)
    (global-set-key (kbd "M-s") 'anything-c-moccur-occur-by-moccur)
    (define-key isearch-mode-map (kbd "C-o") 'anything-c-moccur-from-isearch)
    (define-key isearch-mode-map (kbd "C-M-o") 'isearch-occur)))

;;; color-theme.el
;;気に入ったカラーテーマがあればその名前を上記のコードのcolor-theme-clarityと名前を入れ替える
;;正式な名前でないと反映されないので、~/.emacs.d/elisp/color-theme-6.6.0/color-theme.elの321行目を見て対応する名前を設定すると良い
; (find-file "~/.emacs.d/elisp/color-theme-6.6.0/color-theme.el")
(when (require 'color-theme nil t)
  (color-theme-initialize)
;(color-theme-arjen)
  (color-theme-taming-mr-arneson))

;; redo+.el
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-_") 'redo))

;; ddskk
(when (require 'skk nil t)
  (global-set-key "\C-x\C-j" 'skk-mode)
  (global-set-key "\C-xj" 'skk-auto-fill-mode)
  (global-set-key "\C-xt" 'skk-tutorial)
  (autoload 'skk-mode "skk" nil t)
  (autoload 'skk-auto-vfill-mode "skk" nil t)
  (autoload 'skk-tutorial "skk-tut" nil t)
  (autoload 'skk-isearch-mode-setup "skk-isearch" nil t)
  (autoload 'skk-isearch-mode-cleanup "skk-isearch" nil t))
;(setq skk-use-azik t)            ;AZIKを使う
;(setq skk-azik-keyboard-type 'jp106)
;(add-hook 'isearch-mode-hook
;          (function (lambda ()
;                      (and (boundp 'skk-mode) skk-mode
;                           (skk-isearch-mode-setup) ))))
;
;(add-hook 'isearch-mode-end-hook
;          (function (lambda ()
;                      (and (boundp 'skk-mode) skk-mode
;                           (skk-isearch-mode-cleanup)
;                           (skk-set-cursor-properly) ))))
;
;(add-hook 'dired-load-hook
;          (lambda ()
;            (load "dired-x")
;            (global-set-key "\C-x\C-j" 'skk-mode)))

;; auto-complete.el
(when (require 'auto-complete-config nil t) 
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/ac-dict")
  (ac-config-default)
  (global-set-key (kbd "M-/") 'ac-start))

;; eldoc-extension.el
(when (require 'eldoc-extension nil t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
  (setq eldoc-idle-delay 0.2)
  (setq eldoc-minor-mode-stirng ""))

;;; sticky.el
(when (require 'sticky nil t)
  (use-sticky-key 'muhenkan sticky-alist:en)
  (use-sticky-key 'henkan sticky-alist:en))

;; twittering-mode.el
(when (require 'twittering-mode nil t)
  (setq twittering-use-master-password t)
                                        ; アイコンを表示
  (setq twittering-icon-mode t)             ;アイコンを表示
                                        ; 1分毎にタイムラインを更新する
  (setq twittering-timer-interval 60)       ;60秒ごとにタイムラインを更新する
  (setq twittering-retweet-format "RT @%s %t")
  (setq twittering-status-format "%i %s,%S, %@:\n%FILL{%T // from %f%L%r%R}")
                                        ; twittering-mode起動時に自動で開くバッファ
  (setq twittering-initial-timeline-spec-string
        '(":favorites"
          ":replies"
          ":home"))
  ;; リンクを開くブラウザをChromeにする
  (setq browse-url-browser-function 'browse-url-generic  browse-url-generic-program "chromium"))

;;; popwin.el
(when (require 'popwin nil t)
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:special-display-config '(
                                        ("*anything*")
                                        ("*eshell*")
                                        ("*auto-async-byte-compile*")
                                        ("*twittering-edit*")
                                        ("*Help*")
                                        ("*Completions*" :noselect t)
                                        ("*compilation*" :noselect t)
                                        ("*Occur*")
                                        ("*Kill Ring*")
                                        ("*sldb sbcl/1*")
                                        ("*sldb ccl/11*")
                                        ("*Buffer List*")
                                        ("*SLIME Compilation*")
                                        ("*slime-repl sbcl*")
                                        ("*slime-repl ccl*")
                                        ("*sldb ccl/21*")
                                        ("*ruby*")
                                        ("*anything for files*")
                                        ("*anything moccur*")
                                        )))

;; emacs-client
(when (require 'server nil t)
  (unless (server-running-p)
    (server-start)))

;; SLIME
(setq inferior-lisp-program "ccl")
(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(add-to-list 'load-path "~/.emacs.d/elisp/ac-slime")
(require 'ac-slime)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(add-hook 'slime-mode-hook 'set-up-slime-ac)

;; package.el(ELPA)
; This was installed by package-install.el.
; This provides support for the package system and
; interfacing with ELPA, the package archive.
; Move this code earlier if you want to reference
; packages in your .emacs.



;(when (require 'package nil t)
;  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
;  (package-initialize))
;;; ruby-mode & etc
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))

;; ruby-electric.el
;(require 'ruby-electric)
;(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode t)))

;; ruby-block.el
(when (require 'ruby-block nil t )
  (add-hook 'ruby-mode-hook (lambda () (ruby-block-mode t))))

;; inf-ruby
(define-key ruby-mode-map (kbd "C-c C-z") 'inf-ruby)

;; gist.el
(require 'gist)

;; elscreen.el
(when (require 'elscreen nil t)
  (setq elscreen-display-tab 1))    ; タブを表示するか否か...

;;; init-loaderは使わずにたようなことをする。