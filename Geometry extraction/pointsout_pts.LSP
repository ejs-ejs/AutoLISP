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
    (if (eq "POINT" (cdr (assoc 0 ent)))
  ;;    (if (member (cdr (assoc 2 ent)) BLK:Name)
      
;      (if (eq BLK:Name (cdr (assoc 2 ent)) )
       (progn (setq xyz (cdr (assoc 10 ent))
	     x (car xyz)
	     y (cadr xyz)
	     z (caddr xyz)
	     )
 	 (setq c (strcat (rtos x) ", " (rtos y) ", " (rtos z) "\n"))
	 (princ c fd)

	)
    
    
    )
    (setq a (entnext a)) ;; forward to next entity
    )
  
  (close fd)
  )
(c:pointsout)