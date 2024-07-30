(in-package :hpkg/test)

;;; Write a proper test to check that deletes the current alexandria clone,
;;; clones a new one, and verify with "find" that it has successfully re-cloned.
(defun alexandria-load-test () t)
