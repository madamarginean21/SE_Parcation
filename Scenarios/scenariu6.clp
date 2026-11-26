;;; ---------------------------------------------------------------------
;;;  SCENARIUL 6 - mai multe locuri deodata si interdictii succesive
;;;     Masina proprie: ELECTRICA si CU card de dizabilitati.
;;;     Locuri vazute: E3 (electrice), D3 (dizabilitati), O3 (ocupat).
;;;
;;;     t1-t2    drum liber                                  -> interzis (fara loc)
;;;     t3       E3, D3 libere, O3 ocupat                    -> PERMIS (R2 / R3)
;;;     t4-t5    pieton la <5 m                              -> interzis, asteapta (R12)
;;;     t6-t7    intersectie la <25 m                        -> interzis (R9)
;;;     t8       intersectie + pieton                        -> interzis (R9, R12)
;;;     t9-t11   statie de autobuz la <25 m                  -> interzis (R10)
;;;     t12-t24  nicio interdictie                           -> PERMIS, masina parcheaza
;;; ---------------------------------------------------------------------

(deffacts scenariu-6
   (timp 1)
   (timp-max 24)
   (zone)

   ;; t1-t2: drum liber
   (masina (t 1) (viteza 30) (electrica da) (card-dizabilitati da))
   (masina (t 2) (viteza 25) (electrica da) (card-dizabilitati da))

   ;; t3: trei locuri vazute deodata
   (masina      (t 3) (viteza 10) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 3) (id E3) (rezervat electrice) (distanta 20))
   (loc-parcare (t 3) (id D3) (rezervat dizabilitati) (distanta 25))
   (loc-parcare (t 3) (id O3) (stare ocupat) (distanta 15))

   ;; t4-t5: un pieton traverseaza langa masina
   (masina      (t 4) (viteza 10) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 4) (id E3) (rezervat electrice) (distanta 18))
   (loc-parcare (t 4) (id D3) (rezervat dizabilitati) (distanta 23))
   (loc-parcare (t 4) (id O3) (stare ocupat) (distanta 13))
   (obiect      (t 4) (tip pieton) (distanta 4))
   (masina      (t 5) (viteza 0) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 5) (id E3) (rezervat electrice) (distanta 18))
   (loc-parcare (t 5) (id D3) (rezervat dizabilitati) (distanta 23))
   (loc-parcare (t 5) (id O3) (stare ocupat) (distanta 13))
   (obiect      (t 5) (tip pieton) (distanta 2))

   ;; t6-t7: masina pleaca; locurile sunt langa o intersectie
   (masina      (t 6) (viteza 8) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 6) (id E3) (rezervat electrice) (distanta 15))
   (loc-parcare (t 6) (id D3) (rezervat dizabilitati) (distanta 20))
   (obiect      (t 6) (tip intersectie) (distanta 20))
   (masina      (t 7) (viteza 10) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 7) (id E3) (rezervat electrice) (distanta 12))
   (loc-parcare (t 7) (id D3) (rezervat dizabilitati) (distanta 17))
   (obiect      (t 7) (tip intersectie) (distanta 17))

   ;; t8: intersectie si inca un pieton
   (masina      (t 8) (viteza 5) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 8) (id E3) (rezervat electrice) (distanta 10))
   (loc-parcare (t 8) (id D3) (rezervat dizabilitati) (distanta 15))
   (obiect      (t 8) (tip intersectie) (distanta 15))
   (obiect      (t 8) (tip pieton) (distanta 3))

   ;; t9-t11: dupa intersectie, o statie de autobuz
   (masina      (t 9)  (viteza 8) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 9)  (id E3) (rezervat electrice) (distanta 8))
   (loc-parcare (t 9)  (id D3) (rezervat dizabilitati) (distanta 13))
   (obiect      (t 9)  (tip statie) (distanta 20))
   (masina      (t 10) (viteza 8) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 10) (id E3) (rezervat electrice) (distanta 6))
   (loc-parcare (t 10) (id D3) (rezervat dizabilitati) (distanta 11))
   (obiect      (t 10) (tip statie) (distanta 22))
   (masina      (t 11) (viteza 8) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 11) (id E3) (rezervat electrice) (distanta 5))
   (loc-parcare (t 11) (id D3) (rezervat dizabilitati) (distanta 10))
   (obiect      (t 11) (tip statie) (distanta 24))

   ;; t12-t24: statia a ramas la >25 m, nicio interdictie - parcheaza pe E3
   (masina      (t 12) (viteza 7) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 12) (id E3) (rezervat electrice) (distanta 5))
   (loc-parcare (t 12) (id D3) (rezervat dizabilitati) (distanta 10))
   (obiect      (t 12) (tip statie) (distanta 27))
   (masina      (t 13) (viteza 7) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 13) (id E3) (rezervat electrice) (distanta 4))
   (loc-parcare (t 13) (id D3) (rezervat dizabilitati) (distanta 9))
   (masina      (t 14) (viteza 6) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 14) (id E3) (rezervat electrice) (distanta 4))
   (masina      (t 15) (viteza 6) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 15) (id E3) (rezervat electrice) (distanta 3))
   (masina      (t 16) (viteza 5) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 16) (id E3) (rezervat electrice) (distanta 3))
   (masina      (t 17) (viteza 5) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 17) (id E3) (rezervat electrice) (distanta 2))
   (masina      (t 18) (viteza 4) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 18) (id E3) (rezervat electrice) (distanta 2))
   (masina      (t 19) (viteza 4) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 19) (id E3) (rezervat electrice) (distanta 1))
   (masina      (t 20) (viteza 3) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 20) (id E3) (rezervat electrice) (distanta 1))
   (masina      (t 21) (viteza 2) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 21) (id E3) (rezervat electrice) (distanta 1))
   (masina      (t 22) (viteza 1) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 22) (id E3) (rezervat electrice) (distanta 0))
   (masina      (t 23) (viteza 1) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 23) (id E3) (rezervat electrice) (distanta 0))
   (masina      (t 24) (viteza 0) (electrica da) (card-dizabilitati da))
   (loc-parcare (t 24) (id E3) (rezervat electrice) (distanta 0)))
