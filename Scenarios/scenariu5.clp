;;; ---------------------------------------------------------------------
;;;  SCENARIUL 5 - locul se ocupa in timp ce masina se apropie
;;;     Masina proprie: neelectrica, fara card de dizabilitati.
;;;
;;;     t1-t2    drum liber                                  -> interzis (fara loc)
;;;     t3-t7    loc L5 liber, masina vine incet (<=10 km/h)  -> PERMIS (R1)
;;;     t8-t10   alta masina ocupa L5                        -> interzis (loc nepotrivit)
;;;     t11-t13  drum liber                                  -> interzis (fara loc)
;;;     t14-t16  loc L6 liber + trecere de pietoni la <25 m  -> interzis (R8)
;;;     t17      L6 liber, dar viteza 12 km/h                -> interzis (R14)
;;;     t18-t23  trecerea ramane la >25 m, L6 liber          -> PERMIS (R1, R13)
;;; ---------------------------------------------------------------------

(deffacts scenariu-5
   (timp 1)
   (timp-max 23)
   (zone)

   ;; t1-t2: drum liber
   (masina (t 1) (viteza 35))
   (masina (t 2) (viteza 35))

   ;; t3-t7: loc liber - masina incetineste ca sa parcheze
   (masina      (t 3) (viteza 10))
   (loc-parcare (t 3) (id L5) (distanta 30))
   (masina      (t 4) (viteza 9))
   (loc-parcare (t 4) (id L5) (distanta 23))
   (masina      (t 5) (viteza 8))
   (loc-parcare (t 5) (id L5) (distanta 17))
   (masina      (t 6) (viteza 7))
   (loc-parcare (t 6) (id L5) (distanta 12))
   (masina      (t 7) (viteza 6))
   (loc-parcare (t 7) (id L5) (distanta 8))

   ;; t8-t10: alta masina intra pe L5 inainte
   (masina      (t 8)  (viteza 5))
   (loc-parcare (t 8)  (id L5) (stare ocupat) (distanta 5))
   (masina      (t 9)  (viteza 10))
   (loc-parcare (t 9)  (id L5) (stare ocupat) (distanta 2))
   (masina      (t 10) (viteza 15))
   (loc-parcare (t 10) (id L5) (stare ocupat) (distanta 0))

   ;; t11-t13: masina cauta alt loc
   (masina (t 11) (viteza 25))
   (masina (t 12) (viteza 25))
   (masina (t 13) (viteza 25))

   ;; t14-t16: loc liber, dar langa o trecere de pietoni
   (masina      (t 14) (viteza 20))
   (loc-parcare (t 14) (id L6) (distanta 20))
   (obiect      (t 14) (tip trecere-pietoni) (distanta 12))
   (masina      (t 15) (viteza 18))
   (loc-parcare (t 15) (id L6) (distanta 15))
   (obiect      (t 15) (tip trecere-pietoni) (distanta 17))
   (masina      (t 16) (viteza 15))
   (loc-parcare (t 16) (id L6) (distanta 11))
   (obiect      (t 16) (tip trecere-pietoni) (distanta 22))

   ;; t17-t23: trecerea a ramas in spate, la mai mult de 25 m
   (masina      (t 17) (viteza 12))
   (loc-parcare (t 17) (id L6) (distanta 8))
   (obiect      (t 17) (tip trecere-pietoni) (distanta 26))
   (masina      (t 18) (viteza 10))
   (loc-parcare (t 18) (id L6) (distanta 6))
   (masina      (t 19) (viteza 8))
   (loc-parcare (t 19) (id L6) (distanta 4))
   (masina      (t 20) (viteza 6))
   (loc-parcare (t 20) (id L6) (distanta 3))
   (masina      (t 21) (viteza 4))
   (loc-parcare (t 21) (id L6) (distanta 2))
   (masina      (t 22) (viteza 2))
   (loc-parcare (t 22) (id L6) (distanta 1))
   (masina      (t 23) (viteza 0))
   (loc-parcare (t 23) (id L6) (distanta 0)))
