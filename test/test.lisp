(load "../hpkg.asd")
(asdf:load-system :hpkg)

(hpkg:batch-remote
 (:alexandria "https://gitlab.common-lisp.net/alexandria/alexandria"))

;;; Testing alexandria
(asdf:load-system :alexandria)
(assert #'alexandria:curry)
