(asdf:defsystem #:hpkg
  :description "hpkg: a hacky package fetcher using the git shell client."
  :version "0.0.1"
  :author "Jalen Moore <moo.jalen@gmail.com>"
  :license "Public Domain"
  :pathname "src"
  :components
  ((:file "package")
   (:file "main" :depends-on ("package"))))

;;; Currently buggy. Testing doesn't work correctly.
;;; I have to load the system *here*, not during a test.
(asdf:defsystem #:hpkg/test
  :description "Tests for hpkg."
  :author "Jalen Moore <moo.jalen@gmail.com>"
  :license "Public Domain"
  :depends-on (:hpkg)
  :pathname "test"
  :components
  ((:file "package")
   (:file "test" :depends-on ("package"))))
