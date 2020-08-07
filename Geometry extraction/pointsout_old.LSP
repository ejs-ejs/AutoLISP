(defun c:pointsout ( / a b c fd)
  (setq BLK:Name (list "PIKETAS" "1300"))
  (setq ATT:Name (list "AUKSTIS" "OBJEKT_H"))
  (setq a (entnext)
	fn (getfiled "Nurodykite CVS failà" "" "csv" 9))
  (setq fd (open fn "w"))
  (setq c (strcat "; " fn "\n; Blokai: '" (car BLK:Name) "', '" (cadr BLK:Name) "', Atributai: '" (car ATT:Name) "', '" (cadr ATT:Name) "'\n")
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
 	 (setq c (strcat (rtos x) ", " (rtos y) ", " (rtos z) "\n"))
	 (princ c fd)

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
  )
(c:pointsout)