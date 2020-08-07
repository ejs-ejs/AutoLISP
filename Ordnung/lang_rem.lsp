;;;
;;; C:LANG_REM
;;;
;;; Will draw a polyline for a "window"
;;;  The early handy tools for drafting purposes
;;;  Have no real value in the BIM environment
;;;
;;; 
;;;
;;; (c) ejs 1997 -2020
;;; The provided software will not suite any of your needs, will do any harm for your data. 
;;; Handle with care.
;;;


(defun c:lang_rem()
(setq p1 (getpoint)
      p2 (getpoint)
      p3 (getpoint)
      p4 (getpoint)
      offsetL 0.2
      offsetW 0.1
      )
  (setq P11 (polar p1 (angle p2 p1) offsetL)
	P12 (polar P11 (angle p4 p1) offsetW)
	P21 (polar p2 (angle p1 p2) offsetL)
	P22 (polar P21 (angle p3 p2) offsetW)
	P31 (polar p3 (angle p4 p3) offsetL)
	P32 (polar P31 (angle p2 p3) offsetW)
	P41 (polar p4 (angle p3 p4) offsetL)
	P42 (polar P41 (angle p1 p4) offsetW)
	)
  (setq osm (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (command ".pline" p1 P11 P12 P22 P21 p2 p3 p4 "c")
  (setvar "OSMODE" osm)
;;;
;;;  ((-1 . <Entity name: 20f05763880>)
;;;    (0 . "HATCH")
;;;    (330 . <Entity name: 20ef271f820>)
;;;    (5 . "3C640")
;;;    (100 . "AcDbEntity")
;;;    (67 . 0)
;;;    (410 . "Model")
;;;    (8 . "A-ang\U+0173_remontas")
;;;    (100 . "AcDbHatch")
;;;    (10 0.0 0.0 0.0)
;;;    (210 0.0 0.0 1.0)
;;;    (2 . "ANSI31")
;;;    (70 . 0)
;;;    (71 . 0)
;;;    (91 . 1)
;;;    (92 . 1)
;;;    (93 . 12)
;;;    (72 . 1)
;;;    (10 -109.523 14.0736 0.0)
;;;    (11 -108.161 13.8543 0.0)
;;;    (72 . 1)     (10 -108.161 13.8543 0.0)
;;;    (11 -108.177 13.7556 0.0)
;;;    (72 . 1) (10 -108.177 13.7556 0.0) (11 -108.374 13.7874 0.0)
;;;    (72 . 1) (10 -108.374 13.7874 0.0) (11 -108.57 12.5729 0.0)
;;;    (72 . 1) (10 -108.57 12.5729 0.0) (11 -108.372 12.5411 0.0)
;;;    (72 . 1) (10 -108.372 12.5411 0.0) (11 -108.388 12.4424 0.0)
;;;    (72 . 1) (10 -108.388 12.4424 0.0) (11 -109.75 12.6617 0.0)
;;;    (72 . 1) (10 -109.75 12.6617 0.0) (11 -109.735 12.7604 0.0)
;;;    (72 . 1) (10 -109.735 12.7604 0.0) (11 -109.537 12.7286 0.0)
;;;    (72 . 1) (10 -109.537 12.7286 0.0) (11 -109.342 13.9431 0.0)
;;;    (72 . 1) (10 -109.342 13.9431 0.0) (11 -109.539 13.9749 0.0)
;;;    (72 . 1) (10 -109.539 13.9749 0.0) (11 -109.523 14.0736 0.0)
;;;    (97 . 0) (75 . 1) (76 . 1) (52 . 0.0) (41 . 1.0) (77 . 0)
;;;    (78 . 1)
;;;    (53 . 0.785398)
;;;    (43 . -14.1158) (44 . 5.20442) (45 . -0.0883883) (46 . 0.0883883) (79 . 0) (98 . 1) (10 -14.1158 5.20442 0.0))

	
  )