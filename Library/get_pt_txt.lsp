(defun get_pt_txt (ent search_dist)
		;  (get_pt_txt (entget (car (entsel))) 0.4)

;(setq ent	  (entget (car (entsel)))
;     search_dist 0.4
;)



(if (eq "INSERT" (cdr (assoc 0 ent)))
  (progn
    (setq xyz (cdr (assoc 10 ent))
	  x   (car xyz)
	  y   (cadr xyz)
	  z   0				; text is allway at Z=0
    )
    (setq
      search_x1	(- x search_dist)
      search_x2	(+ x search_dist)
      search_y1	(+ y (/ search_dist 2))
      search_y2	(+ search_y1 search_dist)
    )
    (setq
      targets (ssget "_C"
		     (list search_x1 search_y1)
		     (list search_x2 search_y2)
	      )
    )
  )
)					; if

					; process the selection set
(setq _txt "0")
(while (> (sslength targets) 0)
  (progn
    (setq ss_mem (ssname targets 0)
	  ss_ent (entget ss_mem)
    )

    (if	(eq "MTEXT" (cdr (assoc 0 ss_ent)))
      (progn
	(setq ent_txt  (cdr (assoc 1 ss_ent))
	      ent_txt0 (unformat ent_txt "*")
	)
	(if (distof ent_txt0 2)
	  (setq _txt ent_txt0)
	  )
      )

    )
    (setq targets (ssdel ss_mem targets)) ; delete processed element
  )
)


_txt

); defun


; Here it is the UNFORMAT defun By John Uhden 

;| The UnFormat function below was written by John Uhden. I have made
   some small modifications to John's original code to optimize it for
   running inside StripMtext.  Thanks to you John!  SD |;

;; UnFormat by John Uhden
;; Primary function to perform the format stripping:
;; Arguments:
;;   Mtext   - the text string to be Unformatted
;;   Formats - a string containing some or all of 
;;             the following characters:
;;
;;     A - Alignment
;;     C - Color
;;     F - Font
;;     H - Height
;;     L - Underscore
;;     O - Overscore
;;     P - Linefeed (Paragraph)
;;     Q - Obliquing
;;     S - Spacing (Stacking)
;;     T - Tracking
;;     W - Width
;;     ~ - Non-breaking Space
;;   Optional Formats -
;;     * - All formats
;; Returns:
;;   nil  - if not a valid Mtext object
;;   Text - the Mtext textstring with none, some, or all
;;          of the formatting removed, depending on what
;;          formats were present and what formats were
;;          specified for removal.
;;

(DEFUN UNFORMAT	(MTEXT FORMATS / ALL FORMAT1 FORMAT2 FORMAT3 TEXT STR)
  (AND
    MTEXT
    FORMATS
    (= (TYPE MTEXT) 'STR)
    (= (TYPE FORMATS) 'STR)
    (SETQ FORMATS (STRCASE FORMATS))
    (SETQ TEXT "")
    (SETQ ALL T)
    (IF	(= FORMATS "*")
      (SETQ FORMATS "S"
	    FORMAT1 "\\[LO`~]"
	    FORMAT2 "\\[ACFHQTW]"
	    FORMAT3 "\\P"
      )
      (PROGN
	(SETQ FORMAT1 ""
	      FORMAT2 ""
	      FORMAT3 ""
	)
	(FOREACH ITEM '("L" "O" "~")
	  (IF (VL-STRING-SEARCH ITEM FORMATS)
	    (SETQ FORMAT1 (STRCAT FORMAT1 "`" ITEM))
	    (SETQ ALL NIL)
	  )
	)
	(IF (= FORMAT1 "")
	  (SETQ FORMAT1 NIL)
	  (SETQ FORMAT1 (STRCAT "\\[" FORMAT1 "]"))
	)
	(FOREACH ITEM '("A" "C" "F" "H" "Q" "T" "W")
	  (IF (VL-STRING-SEARCH ITEM FORMATS)
	    (SETQ FORMAT2 (STRCAT FORMAT2 ITEM))
	    (SETQ ALL NIL)
	  )
	)
	(IF (= FORMAT2 "")
	  (SETQ FORMAT2 NIL)
	  (SETQ FORMAT2 (STRCAT "\\[" FORMAT2 "]"))
	)
	(IF (VL-STRING-SEARCH "P" FORMATS)
	  (SETQ FORMAT3 "\\P")
	  (SETQ	FORMAT3	NIL
		ALL NIL
	  )
	)
	T
      )
    )
    (WHILE (/= MTEXT "")
      (COND
	((WCMATCH (STRCASE (SETQ STR (SUBSTR MTEXT 1 2))) "\\[\\{}]")
	 (SETQ MTEXT (SUBSTR MTEXT 3)
	       TEXT  (STRCAT TEXT STR)
	 )
	)
	((AND ALL (WCMATCH (SUBSTR MTEXT 1 1) "[{}]"))
	 (SETQ MTEXT (SUBSTR MTEXT 2))
	)
	((AND FORMAT1 (WCMATCH (STRCASE (SUBSTR MTEXT 1 2)) FORMAT1))
	 (SETQ MTEXT (SUBSTR MTEXT 3))
	)
	((AND FORMAT2 (WCMATCH (STRCASE (SUBSTR MTEXT 1 2)) FORMAT2))
	 (SETQ MTEXT (SUBSTR MTEXT (+ 2 (VL-STRING-SEARCH ";" MTEXT))))
	)
	((AND FORMAT3 (WCMATCH (STRCASE (SUBSTR MTEXT 1 2)) FORMAT3))
	 (IF
	   (OR
	     (EQ "" TEXT) ;_ added JB 1/15/2007
	     (= " " (SUBSTR TEXT (STRLEN TEXT)))
	     (= " " (SUBSTR MTEXT 3 1))
	   )
	    (SETQ MTEXT (SUBSTR MTEXT 3))
	    (SETQ MTEXT	(SUBSTR MTEXT 3)
		  TEXT	(STRCAT TEXT " ")
	    )
	 )
	)
	((AND (VL-STRING-SEARCH "S" FORMATS)
	      (WCMATCH (STRCASE (SUBSTR MTEXT 1 2)) "\\S")
	 )
	 (SETQ STR   (SUBSTR MTEXT 3 (- (VL-STRING-SEARCH ";" MTEXT) 2))
	       TEXT  (STRCAT TEXT (VL-STRING-TRANSLATE "#^\\" "/^\\" STR))
	       MTEXT (SUBSTR MTEXT (+ 4 (STRLEN STR)))
	 )
	)
	(1
	 (SETQ TEXT  (STRCAT TEXT (SUBSTR MTEXT 1 1))
	       MTEXT (SUBSTR MTEXT 2)
	 )
	)
      )
    )
  )
  TEXT
)

;;;(princ "\nStripMtext v3.08 by John Uhden & Steve Doman\nStart by typing \"STRIPMTEXT\" ")
;;;(princ)