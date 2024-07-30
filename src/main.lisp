(in-package :hpkg)

"Perhaps create a repository class to allow projects to define their own local repos in a project build dir?"

(defparameter *home* (uiop:getenv "HOME"))
(defparameter *default-destination* (concatenate 'string *home*
                                               "/.local/share/common-lisp/source/"))

(defun is-dependency-installed (dependency &key (dest *default-destination*))
  (let ((result (uiop:run-program `("find" ,dest "-name" ,(string (car dependency)))
                                  :output :string
                                  :ignore-error-status t)))
    (not (string= result ""))))

(defun get-dependency-dest (parent dependency)
  (concatenate 'string parent (string dependency)))

(defun get-remote (dependency &key (dest *default-destination*) debug)
  "Clone the given remote asdf system. Clones to '~/.local/share/common-lisp/source/' by default."
  (let ((dpd-name (string (car dependency))))
    (if (not (is-dependency-installed dependency))
        (progn
          (uiop:run-program `("git" "clone" ,@(cdr dependency) ,(get-dependency-dest dest (car dependency)))
                            :output :string
                            :ignore-error-status t)
          (format t "Cloned: ~a...~%" dpd-name))
        (if debug
            (format t "Skipped: ~a...~%" dpd-name)))))

(defmacro batch-remote (&rest dependency-list)
  "Batch a list of remote asdf system for cloning. Cloned sequentially."
  `(progn
     ,@(loop :for dpd :in dependency-list
             :collect `(get-remote ',dpd :debug t))))
