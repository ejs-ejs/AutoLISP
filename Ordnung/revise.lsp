;;;
;;; C:ERR
;;; C:WARN
;;;
;;; The 2 command for drawing revision
;;; Will place error revision clouds onto layers "ERROR" and warnings onto layer "Warnings"
;;;  
;;;  A quick tool, written when had to check 300+ drawings quickly
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;


(defun err_setup()
  (command "-linetype" "load" "DASHED" "acadiso.lin" "")
  (command "-linetype" "load" "DASHDOT" "acadiso.lin" "")
  (command "-layer" "new" "ERROR, Warnings" "")
  (command "-layer" "Color" 10 "Error" "Color" 40 "Warnings"  "")
  (command "-layer" "lt" "DASHED" "ERROR" "LW" 0.7 "ERROR" "")
  (command "-layer" "lt" "DASHDOT" "Warnings" "LW" 0.5 "Warnings" "")
  (command "-REVCLOUD" "A" "2000" "4000")
  (command)
  (setq err_setup_completed T)
  
  )

(defun c:err()
  (if (not err_setup_completed)
    (err_setup)
    )
  (setq _CL (getvar "CLAYER")
	_CC (getvar "CECOLOR")
	_CLT (getvar "CELTYPE")
	_CLW (getvar "LWDEFAULT")
	)
  
  (command "COLOR" "BYLAYER")
  (command "LineTYPE" "set" "BYLAYER" "")
  (command "LWEIGHT" "BYLAYER")
  (command "-layer" "set" "ERROR" "")

  (command "REVCLOUD")
 ;; (command "MLEADER")
  
   (command "-layer" "set" _CL "")
  (command "COLOR" _CC)
  (command "LineTYPE" "set" _CLT "")
  (command "LWEIGHT" _CLW)
  )



(defun c:warn()
  (if (not err_setup_completed)
    (err_setup)
    )
  (setq _CL (getvar "CLAYER")
	_CC (getvar "CECOLOR")
	_CLT (getvar "CELTYPE")
	_CLW (getvar "LWDEFAULT")
	)
  
  (command "COLOR" "BYLAYER")
  (command "LineTYPE" "set" "BYLAYER" "")
  (command "LWEIGHT" "BYLAYER")
  (command "-layer" "set" "Warnings" "")

  (command "REVCLOUD")
 ;; (command "-MLEADER")
  
  (command "-layer" "set" _CL "")
  (command "COLOR" _CC)
  (command "LineTYPE" "set" _CLT "")
  (command "LWEIGHT" _CLW)
  )
