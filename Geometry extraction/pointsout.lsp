;;;
;;; C:POINTSOUT
;;;
;;; Will extract the height information from the 1) specified bloks ( as incertion Z) 
;;;   or 2) their predefined attributes (as text) or 3) nearby text fields, 
;;;   will update the blocks Z coordinate and dump them to a CSV file as X, Y and Z values. 
;;; 1st and 2nd cases are common for survey data, while 3rd case is common for GIS data
;;;
;;;   The CVS file can be used in Autodesk Revit to create topography.
;;; Basepoint can be used in Autodesk Revt to position the toposurface in the predefined location
;;;   to eliminate 'Extreme model" warning, while it was not tested.
;;;
;;; Block names are defined in BLK:Name
;;; Attribute nameas are defined in ATT:Name
;;; 
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;

(defun c:pointsout ( / a b c fd)
  (setq BLK:Name (list "PIKETAS" "1300" "2131"))
  (setq ATT:Name (list "AUKSTIS" "OBJEKT_H"))
  (setq n_points 0)
  (setq BP_ (getpoint "Select reference point [0, 0]: "))
  (if BP_
    (setq BP BP_)
    (setq BP '(0 0))
    )

  (setq a (entnext)
	fn (getfiled "Select CVS file" "" "csv" 9))
  (setq fd (open fn "w"))
  (setq c (strcat "; " fn "\n; Blocks: '" (car BLK:Name) "', '" (cadr BLK:Name) "', '" (caddr BLK:Name) "'\n; Attributes: '" (car ATT:Name) "', '" (cadr ATT:Name) "'\n; Reference point: (" (rtos (car BP)) ", " (rtos (cadr BP)) ")\n")
	)
   (princ c fd)
  (while a
    (setq ent (entget a))
    (setq x nil
	  y nil
	  z nil)
;    (if (and (eq "INSERT" (cdr (assoc 0 ent))) (member (list (cdr (assoc 2 ent))) BLK:Name) )
    (if (eq "INSERT" (cdr (assoc 0 ent)))
      (if (member (cdr (assoc 2 ent)) BLK:Name)
      
;      (if (eq BLK:Name (cdr (assoc 2 ent)) )
       (progn (setq xyz (cdr (assoc 10 ent))
	     x (car xyz)
	     y (cadr xyz)
	     z (caddr xyz)
	     )
	 (if (= 0 z)
	   (setq z nil)
	   )

	 (while (not z)
	     (setq att (entget (entnext a)))
	     (if (eq "ATTRIB" (cdr (assoc 0 att)))
	       (progn
		 (while (not (member (cdr (assoc 2 att)) ATT:Name))
		   (setq att (entget (entnext (cdr (assoc -1 att)))))
		   ) ; found right attribute
		 (setq tmp_z (cdr (assoc 1 att))
		       z (distof tmp_z 2) ; use decimal converson to string
		       )
		 (if (not z)
		   (setq z 0)
		   )
		 )
	       (setq a (cdr (assoc -1 att))) ;; forward to next entity
	       
	       ) ; found attdef
		   
	   ) ; z=0
	 ;(setq c (strcat (cdr (assoc 2 ent)) "|" (cdr (assoc 2 att)) ": " (rtos x) ", " (rtos y) ", " (rtos z) "\n"))

	 ; last chance if Z=0
	 ; height may be recorded as text at a predefined distance, currently 0.4 m
	 (if (= z 0)
	   
	     (setq z_tmp (get_pt_txt ent 0.4)
		   z (distof z_tmp 2))
	     
	   )
	 
	 (setq c (strcat (rtos (- x (car BP))) ", " (rtos (- y (cadr BP))) ", " (rtos z) "\n"))
	 (princ c fd)
	 (setq n_points (1+ n_points))

	 ;; modify point

	 (setq xyz (list x y z)
	       xyz (cons '10 xyz)
	       old_pt (assoc 10 ent)
	       ent_new (subst xyz old_pt ent)
	       )
	 (entmod ent_new)
	 

	 
	 ) 
      ;(setq a (entnext a)) ;; forward to next entity
      )
      )
    
    (setq a (entnext a)) ;; forward to next entity
    )
  
  (close fd)
  (princ (strcat "POINTSOUT:" (itoa n_points) " points processed\n"))
  (princ)
  )
;(c:pointsout)