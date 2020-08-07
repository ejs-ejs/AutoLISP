;;;
;;; C:BJUTIFAI
;;;
;;; Will post-process DWG files exported from Autodesk Revit
;;;
;;; The goal was to make them more readable
;;; Have no idea why the function is commented out. Broken? 
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;


;;;
;;;(defun set_all_bylayer()
;;;
;;;  (setq ss1 (ssget "X")) ;; all entities
;;;  (setq l_color '(62 . 256)
;;;	  l_linetype '(6. "BYLAYER")
;;;	  l_lw '(370 . 0)
;;;	  )
;;;  
;;;  
;;;  (setq idx 0)
;;;  (while (setq ent (entget (ssname ss1 idx)))
;;;    
;;;    (setq e_color (assoc 62 ent)
;;;	  e_linetype (assoc 6 ent)
;;;	  e_lw (assoc 370 ent))
;;;    ;; to be done
;;;    )
;;;
;;;  )

(defun set_ent_ltscale (l_name e_ltsc)
  (setq ss1 (ssget "X" (list ( cons 8 l_name)))) ;; on layer 'l_name'
    
  (setq e_ltscale (cons 48 e_ltsc)
	idx 0)
  (while (setq ent (entget (ssname ss1 idx)))
    (setq c_ltsc (assoc 48 ent)
	  )
    (if c_ltsc
      (setq n_ent (subst e_ltscale c_ltsc ent))
      (setq n_ent (cons e_ltscale ent))
      	  )
    
    (entmod n_ent)
    (entupd (cdr (assoc -1 ent)))
    (setq idx (1+ idx))
  )
  )

  
(defun set_layer_linetype (l_name l_type)
  (command "-layer" "ltype" l_type l_name "")
  )




(defun set_layer_color (l_name l_color)
  (command "-layer" "color" l_color l_name "")
  )

(defun set_layer_lw (l_name l_lw)
  (command "-layer" "lw" l_lw l_name "")
  )

(defun set_layer_noplot (l_name)
  (command "-layer" "noplot" l_name "")
  )

(defun c:bjutifai()

 ;; (set_all_bylayer)

  (set_layer_linetype "S-GRIDIDM" "Grid Line")
  
  (set_layer_color "S-GRIDIDM" 251)
  (set_layer_color "A-NPP" 5) ; blue
  (set_layer_color "A-WALL" 7) ; black
  (set_layer_color "S-WALLLOM" 7) ; black
  (set_layer_color "A-WALLMBM" 7) ; black
  (set_layer_color "A-COLSENM" 7) ; black
  (set_layer_color "S-COLSPRM" 7) ; black
  (set_layer_color "A-AREADIM" 11) ; reddish
  (set_layer_color "A-TEP" 11) ; reddish
  (set_layer_color "A_FLOORSTM" 11) ; reddish

  (set_layer_lw "A-WALL" "0.35")
  (set_layer_lw "S-WALLLOM" "0.35")
  (set_layer_lw "A-WALLMBM" "0.35")

  (set_layer_noplot "A-NPP" )

  (set_ent_ltscale "S-GRIDIDM" 100)

  )