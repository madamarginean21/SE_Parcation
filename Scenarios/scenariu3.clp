;;; ---------------------------------------------------------------------
;;;  SCENARIUL 3 - stationare interzisa, cale ferata, loc pentru electrice
;;;     Masina proprie: ELECTRICA, fara card de dizabilitati.
;;;
;;;     t1-t2    drum liber                                     -> interzis (fara loc)
;;;     t3       semn "Stationarea interzisa"                   -> interzis (R5)
;;;     t4-t8    loc L4 liber + cale ferata la <50 m            -> interzis (R5, R11)
;;;     t9-t11   cale ferata in spate: 20, 35, 55 m             -> interzis (R5, R11 pana la 50 m)
;;;     t12      semn "Incetarea tuturor restrictiilor"         -> R7, interzis (fara loc)
;;;     t13-t15  loc D2 pentru dizabilitati (fara card)         -> interzis (loc nepotrivit)
;;;     t16-t18  loc E2 pentru electrice + trecere de pietoni   -> interzis (R8)
;;;     t19-t24  loc E2, langa un loc ocupat O2                 -> PERMIS (R3, R13)
;;; ---------------------------------------------------------------------

(deffacts scenariu-3
   (timp 1)
   (timp-max 24)
   (zone)

   ;; t1-t2: drum liber
   (masina (t 1) (viteza 50) (electrica da))
   (masina (t 2) (viteza 50) (electrica da))

   ;; t3: semnul "Stationarea interzisa"
   (masina (t 3) (viteza 45) (electrica da))
   (semn   (t 3) (tip stationare-interzisa) (distanta 5))

   ;; t4-t8: loc liber in zona interzisa, apropiere de calea ferata
   (masina      (t 4) (viteza 40) (electrica da))
   (loc-parcare (t 4) (id L4) (distanta 30))
   (obiect      (t 4) (tip cale-ferata) (distanta 45))
   (masina      (t 5) (viteza 35) (electrica da))
   (loc-parcare (t 5) (id L4) (distanta 21))
   (obiect      (t 5) (tip cale-ferata) (distanta 35))
   (masina      (t 6) (viteza 30) (electrica da))
   (loc-parcare (t 6) (id L4) (distanta 13))
   (obiect      (t 6) (tip cale-ferata) (distanta 25))
   (masina      (t 7) (viteza 20) (electrica da))
   (loc-parcare (t 7) (id L4) (distanta 6))
   (obiect      (t 7) (tip cale-ferata) (distanta 15))
   (masina      (t 8) (viteza 15) (electrica da))
   (loc-parcare (t 8) (id L4) (distanta 1))
   (obiect      (t 8) (tip cale-ferata) (distanta 5))

   ;; t9-t11: calea ferata ramane in spate
   (masina (t 9)  (viteza 25) (electrica da))
   (obiect (t 9)  (tip cale-ferata) (distanta 20))
   (masina (t 10) (viteza 30) (electrica da))
   (obiect (t 10) (tip cale-ferata) (distanta 35))
   (masina (t 11) (viteza 35) (electrica da))
   (obiect (t 11) (tip cale-ferata) (distanta 55))

   ;; t12: "Incetarea tuturor restrictiilor"
   (masina (t 12) (viteza 35) (electrica da))
   (semn   (t 12) (tip incetare-restrictii) (distanta 5))

   ;; t13-t15: loc pentru dizabilitati - masina nu are card
   (masina      (t 13) (viteza 30) (electrica da))
   (loc-parcare (t 13) (id D2) (rezervat dizabilitati) (distanta 20))
   (masina      (t 14) (viteza 25) (electrica da))
   (loc-parcare (t 14) (id D2) (rezervat dizabilitati) (distanta 12))
   (masina      (t 15) (viteza 25) (electrica da))
   (loc-parcare (t 15) (id D2) (rezervat dizabilitati) (distanta 5))

   ;; t16-t18: loc pentru electrice, dar langa o trecere de pietoni
   (masina      (t 16) (viteza 20) (electrica da))
   (loc-parcare (t 16) (id E2) (rezervat electrice) (distanta 20))
   (obiect      (t 16) (tip trecere-pietoni) (distanta 15))
   (masina      (t 17) (viteza 18) (electrica da))
   (loc-parcare (t 17) (id E2) (rezervat electrice) (distanta 15))
   (obiect      (t 17) (tip trecere-pietoni) (distanta 20))
   (masina      (t 18) (viteza 15) (electrica da))
   (loc-parcare (t 18) (id E2) (rezervat electrice) (distanta 12))
   (obiect      (t 18) (tip trecere-pietoni) (distanta 24))

   ;; t19-t24: trecerea a ramas la >25 m; E2 liber, O2 ocupat alaturi
   (masina      (t 19) (viteza 12) (electrica da))
   (loc-parcare (t 19) (id E2) (rezervat electrice) (distanta 9))
   (loc-parcare (t 19) (id O2) (stare ocupat) (distanta 4))
   (obiect      (t 19) (tip trecere-pietoni) (distanta 28))
   (masina      (t 20) (viteza 10) (electrica da))
   (loc-parcare (t 20) (id E2) (rezervat electrice) (distanta 6))
   (loc-parcare (t 20) (id O2) (stare ocupat) (distanta 1))
   (masina      (t 21) (viteza 8)  (electrica da))
   (loc-parcare (t 21) (id E2) (rezervat electrice) (distanta 4))
   (masina      (t 22) (viteza 5)  (electrica da))
   (loc-parcare (t 22) (id E2) (rezervat electrice) (distanta 2))
   (masina      (t 23) (viteza 2)  (electrica da))
   (loc-parcare (t 23) (id E2) (rezervat electrice) (distanta 1))
   (masina      (t 24) (viteza 0)  (electrica da))
   (loc-parcare (t 24) (id E2) (rezervat electrice) (distanta 0)))
