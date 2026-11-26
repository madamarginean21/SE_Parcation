;;; ---------------------------------------------------------------------
;;;  SCENARIUL 1 - zona cu oprirea interzisa, apoi parcare permisa
;;;     Masina proprie: neelectrica, fara card de dizabilitati.
;;;
;;;     t1-t3    drum liber                                  -> interzis (fara loc)
;;;     t4       semn "Oprirea interzisa"                    -> interzis (R4)
;;;     t5-t9    loc L1 liber + trecere de pietoni la <25 m  -> interzis (R4, R8)
;;;     t10      "Sfarsitul zonei de oprire interzisa"       -> R6, interzis (R8)
;;;     t11-t14  loc L3 liber + intersectie la <25 m         -> interzis (R9)
;;;     t15-t16  loc L2 liber, dar viteza 15, 12 km/h           -> interzis (R14)
;;;     t17      loc L2 liber, viteza 10 km/h                   -> PERMIS (R1, R13)
;;;     t18-t19  pieton la 3 m                               -> interzis, asteapta (R12)
;;;     t20-t22  pietonul a plecat, masina opreste           -> PERMIS
;;; ---------------------------------------------------------------------

(deffacts scenariu-1
   (timp 1)
   (timp-max 22)
   (zone)

   ;; t1-t3: drum liber
   (masina (t 1) (viteza 40))
   (masina (t 2) (viteza 40))
   (masina (t 3) (viteza 40))

   ;; t4: semnul "Oprirea interzisa"
   (masina (t 4) (viteza 35))
   (semn   (t 4) (tip oprire-interzisa) (distanta 5))

   ;; t5-t9: loc L1 liber, dar in zona interzisa si langa trecerea de pietoni
   (masina      (t 5) (viteza 30))
   (loc-parcare (t 5) (id L1) (distanta 30))
   (obiect      (t 5) (tip trecere-pietoni) (distanta 24))
   (masina      (t 6) (viteza 30))
   (loc-parcare (t 6) (id L1) (distanta 22))
   (obiect      (t 6) (tip trecere-pietoni) (distanta 18))
   (masina      (t 7) (viteza 30))
   (loc-parcare (t 7) (id L1) (distanta 14))
   (obiect      (t 7) (tip trecere-pietoni) (distanta 12))
   (masina      (t 8) (viteza 30))
   (loc-parcare (t 8) (id L1) (distanta 6))
   (obiect      (t 8) (tip trecere-pietoni) (distanta 6))
   (masina      (t 9) (viteza 30))
   (loc-parcare (t 9) (id L1) (distanta 1))
   (obiect      (t 9) (tip trecere-pietoni) (distanta 1))

   ;; t10: sfarsitul zonei de oprire interzisa (trecerea e inca aproape)
   (masina (t 10) (viteza 30))
   (semn   (t 10) (tip sfarsit-oprire) (distanta 5))
   (obiect (t 10) (tip trecere-pietoni) (distanta 8))

   ;; t11-t14: loc L3 liber, dar langa o intersectie
   (masina      (t 11) (viteza 25))
   (loc-parcare (t 11) (id L3) (distanta 20))
   (obiect      (t 11) (tip intersectie) (distanta 24))
   (masina      (t 12) (viteza 25))
   (loc-parcare (t 12) (id L3) (distanta 14))
   (obiect      (t 12) (tip intersectie) (distanta 18))
   (masina      (t 13) (viteza 25))
   (loc-parcare (t 13) (id L3) (distanta 8))
   (obiect      (t 13) (tip intersectie) (distanta 12))
   (masina      (t 14) (viteza 25))
   (loc-parcare (t 14) (id L3) (distanta 2))
   (obiect      (t 14) (tip intersectie) (distanta 6))

   ;; t15-t17: loc L2 liber, nerezervat, nicio interdictie
   (masina      (t 15) (viteza 15))
   (loc-parcare (t 15) (id L2) (distanta 10))
   (masina      (t 16) (viteza 12))
   (loc-parcare (t 16) (id L2) (distanta 8))
   (masina      (t 17) (viteza 10))
   (loc-parcare (t 17) (id L2) (distanta 6))

   ;; t18-t19: un pieton apare langa masina
   (masina      (t 18) (viteza 5))
   (loc-parcare (t 18) (id L2) (distanta 4))
   (obiect      (t 18) (tip pieton) (distanta 3))
   (masina      (t 19) (viteza 5))
   (loc-parcare (t 19) (id L2) (distanta 4))
   (obiect      (t 19) (tip pieton) (distanta 2))

   ;; t20-t22: pietonul a plecat, masina intra pe loc si opreste
   (masina      (t 20) (viteza 5))
   (loc-parcare (t 20) (id L2) (distanta 3))
   (masina      (t 21) (viteza 3))
   (loc-parcare (t 21) (id L2) (distanta 1))
   (masina      (t 22) (viteza 0))
   (loc-parcare (t 22) (id L2) (distanta 0)))

