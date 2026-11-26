;;; ---------------------------------------------------------------------
;;;  SCENARIUL 2 - locuri rezervate si statie de autobuz
;;;     Masina proprie: neelectrica, CU card de dizabilitati.
;;;
;;;     t1-t2    drum liber                                    -> interzis (fara loc)
;;;     t3-t6    loc E1 liber, rezervat electrice              -> interzis (loc nepotrivit)
;;;     t7-t10   loc O1 nerezervat, dar ocupat                 -> interzis (loc nepotrivit)
;;;     t11-t14  loc D1 pentru dizabilitati + statie la <25 m  -> interzis (R10)
;;;     t15-t22  loc D1, statia ramane la >25 m in spate       -> PERMIS (R2, R13)
;;; ---------------------------------------------------------------------

(deffacts scenariu-2
   (timp 1)
   (timp-max 22)
   (zone)

   ;; t1-t2: drum liber
   (masina (t 1) (viteza 40) (card-dizabilitati da))
   (masina (t 2) (viteza 40) (card-dizabilitati da))

   ;; t3-t6: loc rezervat masinilor electrice - masina nu este electrica
   (masina      (t 3) (viteza 35) (card-dizabilitati da))
   (loc-parcare (t 3) (id E1) (rezervat electrice) (distanta 25))
   (masina      (t 4) (viteza 30) (card-dizabilitati da))
   (loc-parcare (t 4) (id E1) (rezervat electrice) (distanta 17))
   (masina      (t 5) (viteza 30) (card-dizabilitati da))
   (loc-parcare (t 5) (id E1) (rezervat electrice) (distanta 9))
   (masina      (t 6) (viteza 30) (card-dizabilitati da))
   (loc-parcare (t 6) (id E1) (rezervat electrice) (distanta 1))

   ;; t7-t10: loc nerezervat, dar ocupat
   (masina      (t 7)  (viteza 25) (card-dizabilitati da))
   (loc-parcare (t 7)  (id O1) (stare ocupat) (distanta 20))
   (masina      (t 8)  (viteza 25) (card-dizabilitati da))
   (loc-parcare (t 8)  (id O1) (stare ocupat) (distanta 13))
   (masina      (t 9)  (viteza 25) (card-dizabilitati da))
   (loc-parcare (t 9)  (id O1) (stare ocupat) (distanta 6))
   (masina      (t 10) (viteza 25) (card-dizabilitati da))
   (loc-parcare (t 10) (id O1) (stare ocupat) (distanta 1))

   ;; t11-t14: loc pentru dizabilitati, dar langa o statie de autobuz
   (masina      (t 11) (viteza 20) (card-dizabilitati da))
   (loc-parcare (t 11) (id D1) (rezervat dizabilitati) (distanta 30))
   (obiect      (t 11) (tip statie) (distanta 20))
   (masina      (t 12) (viteza 20) (card-dizabilitati da))
   (loc-parcare (t 12) (id D1) (rezervat dizabilitati) (distanta 25))
   (obiect      (t 12) (tip statie) (distanta 15))
   (masina      (t 13) (viteza 20) (card-dizabilitati da))
   (loc-parcare (t 13) (id D1) (rezervat dizabilitati) (distanta 20))
   (obiect      (t 13) (tip statie) (distanta 10))
   (masina      (t 14) (viteza 20) (card-dizabilitati da))
   (loc-parcare (t 14) (id D1) (rezervat dizabilitati) (distanta 15))
   (obiect      (t 14) (tip statie) (distanta 20))

   ;; t15-t16: statia a ramas in spate, la mai mult de 25 m
   (masina      (t 15) (viteza 15) (card-dizabilitati da))
   (loc-parcare (t 15) (id D1) (rezervat dizabilitati) (distanta 11))
   (obiect      (t 15) (tip statie) (distanta 26))
   (masina      (t 16) (viteza 12) (card-dizabilitati da))
   (loc-parcare (t 16) (id D1) (rezervat dizabilitati) (distanta 8))
   (obiect      (t 16) (tip statie) (distanta 30))

   ;; t17-t22: masina intra pe loc si opreste
   (masina      (t 17) (viteza 10) (card-dizabilitati da))
   (loc-parcare (t 17) (id D1) (rezervat dizabilitati) (distanta 6))
   (masina      (t 18) (viteza 8)  (card-dizabilitati da))
   (loc-parcare (t 18) (id D1) (rezervat dizabilitati) (distanta 4))
   (masina      (t 19) (viteza 6)  (card-dizabilitati da))
   (loc-parcare (t 19) (id D1) (rezervat dizabilitati) (distanta 3))
   (masina      (t 20) (viteza 4)  (card-dizabilitati da))
   (loc-parcare (t 20) (id D1) (rezervat dizabilitati) (distanta 2))
   (masina      (t 21) (viteza 2)  (card-dizabilitati da))
   (loc-parcare (t 21) (id D1) (rezervat dizabilitati) (distanta 1))
   (masina      (t 22) (viteza 0)  (card-dizabilitati da))
   (loc-parcare (t 22) (id D1) (rezervat dizabilitati) (distanta 0)))
