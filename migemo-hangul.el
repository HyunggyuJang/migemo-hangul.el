;;; migemo-hangul.el --- Search both hangul characters in both encoding system, NFC and NFD, especially helpful for macOS

;; Copyright (C) 2021-2021 Hyunggyu Jang <murasakipurplez5@gmail.com>.

;; Author: Hyunggyu Jang <murasakipruplez5@gmail.com>
;; Keywords: emacs, hangul, mac
;; Package: migemo-hangul
;; Version: 1.0
;; Package-Requires: ((emacs "24.4") (migemo "1.9.2"))
;; URL: https://github.com/HyunggyuJang/migemo-hangul.el

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Source code
;;
;; migemo-hangul's code can be found here:
;;   https://github.com/HyunggyuJang/migemo-hangul.el

;;; Commentary:
;; It resolves macOS's hangul encoding discrepancy of NFD from more conventional NFC.
;; That is, known as 한글 파일명 자소 분리 problem.

;;; Code:

(require 'ucs-normalize)
(require 'migemo)

(defun migemo-hangul--convert-NFC (word pattern)
    (with-current-buffer (get-buffer-create " *migemo hangul*")
      (delete-region (point-min) (point-max))
      (insert pattern)
      (goto-char (point-min))
      (while (re-search-forward "[가-힣]" nil t)
        (goto-char (1- (point)))
        (insert (concat "\\(" (match-string 0) "\\|"))
        (let* ((pt (point))
               (offset (translate-region pt (1+ pt) 'ucs-normalize-nfd-table)))
          (goto-char (+ pt offset))
          (insert "\\)")))
      ;; migemo-replace-in-string
      (goto-char (point-min))
      (let ((migemo-do-isearch nil))
        (while (search-forward "\a" nil t)
          (replace-match migemo-white-space-regexp nil t)))
      (buffer-substring (point-min) (point-max)))
    )

(setq migemo-after-conv-function #'migemo-hangul--convert-NFC)

(provide 'migemo-hangul)
;;; migemo-hangul.el ends here
