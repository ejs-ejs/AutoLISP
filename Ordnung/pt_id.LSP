
;;;
;;; C:PT_ID
;;; C:PT_ID_SETUP
;;; C:PT_ID_UPDATE
;;;
;;; A set of tools for marking the specified point with a block, like the coordinates in the topography.
;;;  The early handy tools for drafting purposes
;;;  Have no real value in the BIM environment
;;;
;;; PT_ID will place the predefined block at the point specified and will export the coordinates 
;;;  of the insertion point to the "X" and "Y" attributes
;;; 
;;; PT_ID_SETUP is the setup command, for specifying blocks name, drawing units 
;;;  (eg. meters to milimetrs) and the scaling of the block
;;;
;;; C:PT_ID_UPDATE will update the attribute values to the actual position of the block.
;;;
;;; What are interesging here - (get*d ...) functions: get with default value. Should be moved to a librasy some day
;;;
;;; (c) ejs 1997 - 2011 (2020 ?)
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;

(DEFUN getstringd (string default inget)
  (SETQ	str  (STRCAT string " <" default ">: "))
(if (/= inget "") (initget inget))
  (setq answ (GEtstring str)) ;_ end of setq
  (IF (= answ "")
    (SETQ answ default)
    ) ;_ end of if
  (SETQ answ answ)
  ) ;_ end of defun

(DEFUN getkwordd (string default inget)
  (SETQ	str  (STRCAT string " [" inget "] <" default ">: "))
(if (/= inget "") (initget inget))
  (setq answ (GEtkword str)) ;_ end of setq
  (IF (= answ nil)
    (SETQ answ default)
    ) ;_ end of if
  (SETQ answ answ)
  ) ;_ end of defun

(DEFUN GetDistD (string default inget)
  (SETQ	str  (STRCAT string " <" (RTOS default) ">: "))
(if (/= inget nil) (initget inget))
  (setq answ (GETDIST str)) ;_ end of setq
  (IF (= answ nil)
    (SETQ answ default)
    ) ;_ end of if
  (SETQ answ answ)
  ) ;_ end of defun




(defun c:pt_id ( / Att1 Att2 ID:XValue ID:YValue ent)
  (setq pt (getpoint "\n\tTaskas: "))
  (command ".-insert" ID:Mark pt ID:Scale ID:Scale "")
  (pt_id:attmod (entlast))
  (command "regen")
  )

(defun c:pt_id_update ( / ent)
  (setq ent (entget (car (entsel "\n\tPasirinkite bloka: "))))
  (if (= (cdr (assoc 0 ent)) "INSERT")
    (if (= (strcase (cdr (assoc 2 ent))) (strcase ID:Mark))
      (pt_id:attmod(cdr (assoc -1 ent)))
      )
    )
  (command "regen")
  )

(defun pt_id:attmod(block)
  
  (setq ent block
	Att1 (entnext ent)
	Att2 (entnext Att1)
	Att1 (entget Att1)
	Att2 (entget Att2)
	pt (cdr (assoc 10 (entget ent)))
	pt (trans pt 0 1)
	ID:XValue (strcat "X= " (rtos (* ID:LScale (cadr pt))))
	ID:YValue (strcat "Y= " (rtos (* ID:LScale (car pt))))
	)
  (if (= (strcase (cdr (assoc 2 Att1))) "X")
    (progn (setq Att1 (subst (cons 1 ID:Xvalue) (assoc 1 Att1) Att1))
      (entmod Att1)
      )
    )
  (if (= (strcase (cdr (assoc 2 Att1))) "Y")
    (progn (setq Att1 (subst (cons 1 ID:YValue) (assoc 1 Att1) Att1))
      (entmod Att1)
      )
    )
  (if (= (strcase (cdr (assoc 2 Att2))) "X")
    (progn (setq Att2 (subst (cons 1 ID:Xvalue) (assoc 1 Att2) Att2))(entmod Att2))
    )
  (if (= (strcase (cdr (assoc 2 Att2))) "Y")
    (progn (setq Att2 (subst (cons 1 ID:Yvalue) (assoc 1 Att2) Att2))(entmod Att2))
    )
    )


(defun pt_id:Setup ( / ID:Units ID:ScaleTopo ID:ScaleDWG)
  (if (not ID:LScale) (setq ID:LScale 0.01))
   (if (not ID:Scale) (setq ID:Scale 10.0))
  (if (not ID:Mark) (setq ID:Mark "PT_id"))
   (if (not ID:ScaleTopo) (setq ID:ScaleTopo "M"))
   (if (not ID:ScaleDWG) (setq ID:ScaleDWG "M"))
  (setq ID:Units (list '("MM" . 1)
			'("CM" . 10)
			'("DM" . 100)
			'("M" . 1000)
			'("KM" . 10000)
			))
  

  (setq ID:Mark (getstringd "Tasko simbolio blokas" ID:Mark 0)
	ID:ScaleTopo (getkwordd "Topopagrindo vienetai" ID:ScaleTopo "Km M Dm Cm MM")
	ID:ScaleDWG (getkwordd "Brezinio vienetai" ID:ScaleDWG "Km M Dm Cm MM")
	)
  (setq ID:ScaleTopo (cdr (assoc (strcase ID:ScaleTopo) ID:Units))
	ID:ScaleDWG (cdr (assoc (strcase ID:ScaleDWG) ID:Units))
	ID:Scale (/ ID:ScaleDWG ID:ScaleTopo)
	ID:LScale (/ ID:ScaleDWG ID:ScaleTopo)
	)
  (setq	ID:Scale (getdistd "Tasko bloko mastelis" ID:Scale 0)
	ID:LScale (getdistd "Vienetu mastelis" ID:LScale 0)
	)
  
  (if (= nil (tblsearch "BLOCK" ID:Mark))
    (setq ID:Mark (strcat ID:Mark ".dwg")
	  ID:Mark (findfile ID:Mark))
    )
  (if (= nil ID:Mark) ;; it's still NIL
    (print "\n Kazkaip nerandu reikiamo failo ...")
    )
  )

(defun c:pt_id_setup ()
  (pt_id:Setup)
  )

(defun pt_id_Info ( / str lic login)
  (setq login (getvar "LOGINNAME"))
  (if login
    (setq str (strcat "\n\t Tai va, " login "  : \n"))
    (setq str "\n"))
  
  (setq str (strcat str " *** ----------------------------------------------------------------------\n")
        str (strcat str "\t Programa uzrso topopagrindo koordinaciu reiksmes i bloko, kuris nurodytas \n")
	str (strcat str " kaip tasko simbolis, atributa. Tikslumas kontroliuojamas \n")
	str (strcat str " AutoCAD'o kintamuoju LUPREC - 'Line Units PRECision'\n\n")
	str (strcat str " PT_ID \n")
	str (strcat str "    iterpia bloka ir iraso jo iterpimo tasko koordinate i atributus;\n\n")
	str (strcat str " PT_ID_UPDATE  \n")
	str (strcat str "    pakeicia bloko atributu reiksmes pagal aktyvia koordinaciu sistema;\n")
	str (strcat str " ---***--------------------------------------------------------------------\n"))
  
  (setq lic "\n\t Galite naudoti sia programa savo reikmems ir ja platinti kitiems tol,\n"
	lic (strcat lic " kol ji islieka tokia, kokia ja gavote.\n\n")
	lic (strcat lic " As negaliu uzdrausti jums nagrineti sia programa ar aiskintis jos \n")
	lic (strcat lic " veikimo principus. Bet, kadangi Jus jau sutikote su  Autodesk Inc. \n")
	lic (strcat lic " licenzijos salygomis, tokie veiksmai priestarauja firmos Autodesk Inc. \n")
	lic (strcat lic " licenzijais. As jus perspejau                                           ;)\n\n")
	lic (strcat lic " ------***-----------------------------------------------------------------\n")
	lic (strcat lic "                                     Remkites laisva programine iranga \n")
	lic (strcat lic " \n")
	lic (strcat lic "                        Klausimai? Pageidavimai? ejs@seniejitrakai.net \n")
	lic (strcat lic "                                                     (c) 1997-2011 ejs\n")
	lic (strcat lic " ---------***--------------------------------------------------------------\n")
		    )
(textscr)
  (princ str)
  (princ lic)
  (princ)
  )
(pt_id_Info)
(pt_id:Setup)