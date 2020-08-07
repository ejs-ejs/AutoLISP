;;;
;;; 
;;;
;;; Startup commands
;;;
;;; 
;;; Will set layer "A----NPP" to 'No plot"
;;; 
;;; Probabbly was created to deal fast with Autodesk Revit exports
;;; 
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;

(defun s::startup()
  (setq lname "A----NPP")
  (command "-layer" "make" lname "co" "40" lname "plot" "no" lname "")
  )

(s::startup)