;;;
;;; 
;;; A script for modifyin line type definition on-the-fly
;;;  Not sure it works
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;

(setq a (tblnext "LTYPE" T))
(while (not (= (cdr (assoc 2 a )) "GAS_LINE"))
  (setq a (tblnext "LTYPE"))
  )

(setq lname (cdr (assoc 2 a ))
      ltype (tblobjname "LTYPE" lname))
(setq ldescr (entget ltype)
      ldescr (subst (cons 3 "---KS---") (assoc 3 ldescr) ldescr)
      ldescr (subst (cons 2 "KS") (assoc 2 ldescr) ldescr)
      ldescr (subst (cons 9 "KS") (assoc 9 ldescr) ldescr)
      ldescr (vl-remove (assoc 5 ldescr) ldescr) ; handle
      ldescr (vl-remove (assoc 330 ldescr) ldescr) ; EntityName
      ldescr (vl-remove (assoc 100 ldescr) ldescr) ; AcDbLinetypeTableRecord
      ldescr (vl-remove (assoc 100 ldescr) ldescr) ; AcDbLinetypeTableRecord
      ldescr (vl-remove (assoc -1 ldescr) ldescr) ; EName
      
      )
(entmod ldescr)