;;;
;;; C:RELOCATE
;;;
;;; Will move all the entities in the drawing (editable layers only !) from the base 
;;;    to the destination points and will set the INSBASE to the destination point.
;;;  Usefull for ill-formed DWG files, where geometry is far away from the destination point.
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;


(defun c:relocate()
 (setq ptB (getpoint "Select base point to relocate: ")
       ptO (getpoint "Select point relocate to: "))
 (command "move" "all" "" ptB ptO)
  (setvar "INSBASE" ptO)

)