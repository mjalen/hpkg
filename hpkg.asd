(in-package :asdf-user)

(defsystem "hpkg"
  :description "hpkg: a hacky package fetcher using the git shell client."
  :version "0.0.1"
  :author "Jalen Moore <moo.jalen@gmail.com>"
  :license "Public Domain"
  :components ((:file "package")
               (:file "main" :depends-on ("package"))))
