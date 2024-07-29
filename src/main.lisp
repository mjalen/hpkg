(in-package :hpkg)

"Perhaps create a repository class to allow projects to define their own local repos in a project build dir?"

(defparameter *home* (uiop:getenv "HOME"))
(defparameter *default-destination* (concatenate 'string *home*
                                               "/.local/share/common-lisp/source/"))

(defun get-pkg-dest (parent package)
  (concatenate 'string parent (string package)))

(defun get-remote (package &key (dest *default-destination*) debug)
  "Clone the given remote asdf system. Clones to '~/.local/share/common-lisp/source/' by default."
  (multiple-value-bind (output error status)
      (uiop:run-program `("git" "clone" ,@(cdr package) ,(get-pkg-dest dest (car package)))
                        :output :string
                        :ignore-error-status t)
    (if debug
        (cond ((= status 0)
               (format t "Cloned: ~a.~%" (car package)))
              ((= status 128)
               (format t "Package exists: ~a.~%" (car package)))))
    (values output error status)))

(defmacro batch-remote (&rest package-list)
  "Batch a list of remote asdf system for cloning. Cloned sequentially."
  `(progn
     ,@(loop :for pkg :in package-list
             :collect `(get-remote ',pkg :debug t))))
