(in-package :hpkg)

"Perhaps create a repository class to allow projects to define their own local repos in a project build dir?"

(defgeneric print-repo (repository)
  (:documentation "Helper function for viewing dependency package list."))

(defgeneric force-clean-clone (repository)
  (:documentation "Forcefully remove target directory and clone all dependencies in repository."))

(defclass hpkg-repository ()
  ((dependency-list :initarg :dependency-list :accessor hpkg-repository-dependency-list)
   (target-dir :initarg :target-dir :accessor hpkg-repository-target-dir)))

(defmethod print-repo ((repository hpkg-repository))
  (loop :for dpd :in (hpkg-repository-dependency-list repository)
        :do (format t "~a: ~a~%" (first dpd) (second dpd))))

(defmethod force-clean-clone ((repository hpkg-repository))
  (format t "Another hi~%"))

(defparameter *default-destination* (uiop:merge-pathnames* #p".local/share/common-lisp/source/" #p"~/" ))

(defun is-dependency-installed (dependency &key (dest *default-destination*))
  (let ((result (uiop:run-program `("find" ,dest "-name" ,(string (car dependency)))
                                  :output :string
                                  :ignore-error-status t)))
    (not (string= result ""))))

(defun remove-target (target-dir)
  (uiop:delete-directory-tree
   (uiop:merge-pathnames* target-dir) :validate t))

(defun create-target (target-dir)
  (uiop:ensure-pathname
   (uiop:merge-pathnames* target-dir)
   :ensure-directories-exist t))

(defun get-dependency-dest (parent dependency)
  (concatenate 'string parent (string dependency)))

(defun get-remote (dependency &key (dest *default-destination*) debug)
  "Clone the given remote asdf system. Clones to '~/.local/share/common-lisp/source/' by default."
  (let ((dpd-path (uiop:merge-pathnames* (car dependency) dest)))
    (format t "~a~%" dpd-path)
    (if (not (uiop:directory-exists-p dpd-path))
        (progn
          (uiop:run-program `("git" "clone" ,@(cdr dependency) ,(namestring dpd-path))
                            :output :string
                            :ignore-error-status t)
          (format t "Cloned: ~a...~%" (namestring dpd-path)))
        (if debug
            (format t "Skipped: ~a...~%" (namestring dpd-path))))))

(defmacro batch-remote (&rest dependency-list)
  "Batch a list of remote asdf system for cloning. Cloned sequentially."
  `(progn
     ,@(loop :for dpd :in dependency-list
             :collect `(get-remote ',dpd :debug t))))

; (get-remote '("alexandria/" "https://gitlab.common-lisp.net/alexandria/alexandria") :debug t)
;
;
;             :dest (uiop:merge-pathnames* #p"foo/"))
;
; (uiop:merge-pathnames* #p"foo/")
