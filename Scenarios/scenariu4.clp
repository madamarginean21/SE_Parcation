;;; ---------------------------------------------------------------------
;;;  SCENARIUL 4 - doua zone de interdictie active in acelasi timp
;;;     Masina proprie: neelectrica, fara card de dizabilitati.
;;;
;;;     t1-t2    drum liber                                       -> interzis (fara loc)
;;;     t3       semn "Oprirea interzisa"                         -> interzis (R4)
;;;     t4-t6    loc L1 liber                                     -> interzis (R4)
;;;     t7       semn "Stationarea interzisa" (ambele zone active)-> interzis (R4, R5)
;;;     t8-t11   loc L2 liber                                     -> interzis (R4, R5)
;;;     t12      "Incetarea tuturor restrictiilor"                -> R6 + R7 in acelasi cadru
;;;     t13-t14  drum liber                                       -> interzis (fara loc)
;;;     t15-t17  loc L3 liber, dar viteza >10 km/h                -> interzis (R14)
;;;     t18-t22  loc L3 liber, viteza <= 10 km/h                  -> PERMIS (R1, R13)
;;; ---------------------------------------------------------------------

(deffacts scenariu-4
   (timp 1)
   (timp-max 22)
   (zone)

   ;; t1-t2: drum liber
   (masina (t 1) (viteza 45))
   (masina (t 2) (viteza 45))

   ;; t3: semnul "Oprirea interzisa"
   (masina (t 3) (viteza 40))
   (semn   (t 3) (tip oprire-interzisa) (distanta 5))

   ;; t4-t6: loc liber in zona cu oprirea interzisa
   (masina      (t 4) (viteza 35))
   (loc-parcare (t 4) (id L1) (distanta 20))
   (masina      (t 5) (viteza 35))
   (loc-parcare (t 5) (id L1) (distanta 10))
   (masina      (t 6) (viteza 35))
   (loc-parcare (t 6) (id L1) (distanta 1))

   ;; t7: semnul "Stationarea interzisa" - acum ambele zone sunt active
   (masina (t 7) (viteza 30))
   (semn   (t 7) (tip stationare-interzisa) (distanta 5))

   ;; t8-t11: loc liber, dar in ambele zone
   (masina      (t 8)  (viteza 30))
   (loc-parcare (t 8)  (id L2) (distanta 25))
   (masina      (t 9)  (viteza 30))
   (loc-parcare (t 9)  (id L2) (distanta 17))
   (masina      (t 10) (viteza 30))
   (loc-parcare (t 10) (id L2) (distanta 9))
   (masina      (t 11) (viteza 30))
   (loc-parcare (t 11) (id L2) (distanta 1))

   ;; t12: "Incetarea tuturor restrictiilor" - se termina ambele zone
   (masina (t 12) (viteza 30))
   (semn   (t 12) (tip incetare-restrictii) (distanta 5))

   ;; t13-t14: drum liber
   (masina (t 13) (viteza 30))
   (masina (t 14) (viteza 25))

   ;; t15-t22: loc liber, nicio interdictie - masina parcheaza
   (masina      (t 15) (viteza 20))
   (loc-parcare (t 15) (id L3) (distanta 15))
   (masina      (t 16) (viteza 15))
   (loc-parcare (t 16) (id L3) (distanta 11))
   (masina      (t 17) (viteza 12))
   (loc-parcare (t 17) (id L3) (distanta 8))
   (masina      (t 18) (viteza 10))
   (loc-parcare (t 18) (id L3) (distanta 5))
   (masina      (t 19) (viteza 7))
   (loc-parcare (t 19) (id L3) (distanta 3))
   (masina      (t 20) (viteza 5))
   (loc-parcare (t 20) (id L3) (distanta 2))
   (masina      (t 21) (viteza 2))
   (loc-parcare (t 21) (id L3) (distanta 1))
   (masina      (t 22) (viteza 0))
   (loc-parcare (t 22) (id L3) (distanta 0)))
