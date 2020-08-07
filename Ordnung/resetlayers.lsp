;;;
;;; C:resetlayers
;;;
;;; Will thaw, unlock, and switch on all the layers, while settin layer "0" as active
;;;  Usefull for troubleshooting the drawing
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;

(defun c:resetlayers()
 (command "-layer" "thaw" "*" "unlock" "*" "on" "*" "set" "0" "")
  )