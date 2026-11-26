;;; =====================================================================
;;;  MANEVRA DE PARCARE (parking-maneuver)
;;;
;;;  Rulare in (Fuzzy)CLIPS:
;;;     (load "parcare.clp")      ; template-uri si reguli
;;;     (load "Scenarios/scenariu1.clp")  ; un singur scenariu odata
;;;     (ruleaza)                 ; reset + run + timpul de executie
;;;
;;;  Pentru alt scenariu: (clear), apoi load parcare.clp + Scenarios/scenariuN.clp
;;;
;;;  Fiecare cadru are un moment de timp t. Faptul (timp ?t) arata cadrul
;;;  curent; dupa ce s-a luat decizia pentru cadrul t, se trece la t+1.
;;;
;;;  Ordinea in cadrul unui moment de timp (prin salience):
;;;     110  afisarea cadrului (timp, viteza)
;;;     100  actualizarea zonelor de interdictie (R4-R7)
;;;      90  locuri potrivite (R1-R3) si interdictii locale (R8-R12)
;;;      80  interdictii din zonele active (R4, R5)
;;;      50  decizia finala (R13)
;;;      40  afisarea motivelor
;;;       0  trecerea la cadrul urmator
;;; =====================================================================


;;; ---------------------------------------------------------------------
;;;  1. SINTAXA FAPTELOR (template-uri)
;;; ---------------------------------------------------------------------

;; Starea masinii proprii la fiecare cadru
(deftemplate masina
   (slot t)                                 ; cadrul
   (slot viteza (default 0))                ; km/h
   (slot electrica (default nu))            ; da / nu
   (slot card-dizabilitati (default nu)))   ; da / nu

;; Semne de circulatie vazute de camera
(deftemplate semn
   (slot t)
   (slot tip)      ; oprire-interzisa, stationare-interzisa,
                   ; sfarsit-oprire, sfarsit-stationare, incetare-restrictii
   (slot distanta (default 0)))             ; m

;; Locuri de parcare detectate
(deftemplate loc-parcare
   (slot t)
   (slot id)
   (slot stare (default liber))             ; liber / ocupat
   (slot rezervat (default nu))             ; nu / dizabilitati / electrice
   (slot distanta (default 0)))             ; m

;; Alte obiecte din jur
(deftemplate obiect
   (slot t)
   (slot tip)      ; trecere-pietoni, intersectie, statie, cale-ferata, pieton
   (slot distanta))                         ; m

;; Starea zonelor de interdictie (persista intre cadre)
(deftemplate zone
   (slot oprire-interzisa (default nu))
   (slot stationare-interzisa (default nu)))

;; Fapte deduse de reguli
(deftemplate loc-potrivit (slot t) (slot id) (slot regula))
(deftemplate interdictie  (slot t) (slot motiv))
(deftemplate decizie      (slot t) (slot rezultat))


;;; ---------------------------------------------------------------------
;;;  2. AFISAREA CADRULUI
;;; ---------------------------------------------------------------------

(defrule afiseaza-cadru
   (declare (salience 110))
   (timp ?t)
   (masina (t ?t) (viteza ?v))
   =>
   (printout t crlf "t=" ?t "  viteza=" ?v " km/h" crlf))


;;; ---------------------------------------------------------------------
;;;  3. SEMNE DE INTERZICERE - ZONE (R4-R7)
;;;     Raman valabile pana cand zona se termina.
;;; ---------------------------------------------------------------------

(defrule R4-intra-zona-oprire-interzisa
   (declare (salience 100))
   (timp ?t)
   (semn (t ?t) (tip oprire-interzisa))
   ?z <- (zone (oprire-interzisa nu))
   =>
   (modify ?z (oprire-interzisa da))
   (printout t "   [R4] intra in zona cu oprirea interzisa" crlf))

(defrule R5-intra-zona-stationare-interzisa
   (declare (salience 100))
   (timp ?t)
   (semn (t ?t) (tip stationare-interzisa))
   ?z <- (zone (stationare-interzisa nu))
   =>
   (modify ?z (stationare-interzisa da))
   (printout t "   [R5] intra in zona cu stationarea interzisa" crlf))

(defrule R6-iese-zona-oprire-interzisa
   (declare (salience 100))
   (timp ?t)
   (semn (t ?t) (tip sfarsit-oprire | incetare-restrictii))
   ?z <- (zone (oprire-interzisa da))
   =>
   (modify ?z (oprire-interzisa nu))
   (printout t "   [R6] zona cu oprirea interzisa s-a terminat" crlf))

(defrule R7-iese-zona-stationare-interzisa
   (declare (salience 100))
   (timp ?t)
   (semn (t ?t) (tip sfarsit-stationare | incetare-restrictii))
   ?z <- (zone (stationare-interzisa da))
   =>
   (modify ?z (stationare-interzisa nu))
   (printout t "   [R7] zona cu stationarea interzisa s-a terminat" crlf))


;;; ---------------------------------------------------------------------
;;;  4. EXISTA UN LOC LIBER POTRIVIT? (R1-R3)
;;; ---------------------------------------------------------------------

(defrule R1-loc-liber-nerezervat
   (declare (salience 90))
   (timp ?t)
   (loc-parcare (t ?t) (id ?id) (stare liber) (rezervat nu))
   =>
   (assert (loc-potrivit (t ?t) (id ?id) (regula R1))))

(defrule R2-loc-dizabilitati
   (declare (salience 90))
   (timp ?t)
   (loc-parcare (t ?t) (id ?id) (stare liber) (rezervat dizabilitati))
   (masina (t ?t) (card-dizabilitati da))
   =>
   (assert (loc-potrivit (t ?t) (id ?id) (regula R2))))

(defrule R3-loc-electrice
   (declare (salience 90))
   (timp ?t)
   (loc-parcare (t ?t) (id ?id) (stare liber) (rezervat electrice))
   (masina (t ?t) (electrica da))
   =>
   (assert (loc-potrivit (t ?t) (id ?id) (regula R3))))


;;; ---------------------------------------------------------------------
;;;  5. LOCURI IN CARE NU AI VOIE SA PARCHEZI (R8-R12)
;;;     Conteaza doar in cadrul in care obiectul este vazut.
;;; ---------------------------------------------------------------------

(defrule R8-trecere-pietoni
   (declare (salience 90))
   (timp ?t)
   (obiect (t ?t) (tip trecere-pietoni) (distanta ?d&:(< ?d 25)))
   =>
   (assert (interdictie (t ?t) (motiv "R8 trecere de pietoni la mai putin de 25 m"))))

(defrule R9-intersectie
   (declare (salience 90))
   (timp ?t)
   (obiect (t ?t) (tip intersectie) (distanta ?d&:(< ?d 25)))
   =>
   (assert (interdictie (t ?t) (motiv "R9 intersectie la mai putin de 25 m"))))

(defrule R10-statie
   (declare (salience 90))
   (timp ?t)
   (obiect (t ?t) (tip statie) (distanta ?d&:(< ?d 25)))
   =>
   (assert (interdictie (t ?t) (motiv "R10 statie de transport public la mai putin de 25 m"))))

(defrule R11-cale-ferata
   (declare (salience 90))
   (timp ?t)
   (obiect (t ?t) (tip cale-ferata) (distanta ?d&:(< ?d 50)))
   =>
   (assert (interdictie (t ?t) (motiv "R11 trecere la nivel cu calea ferata la mai putin de 50 m"))))

(defrule R12-pieton-aproape
   (declare (salience 90))
   (timp ?t)
   (obiect (t ?t) (tip pieton) (distanta ?d&:(< ?d 5)))
   =>
   (assert (interdictie (t ?t) (motiv "R12 pieton la mai putin de 5 m - masina asteapta"))))


;;; ---------------------------------------------------------------------
;;;  6. INTERDICTII DIN ZONELE ACTIVE (R4, R5)
;;; ---------------------------------------------------------------------

(defrule zona-oprire-activa
   (declare (salience 80))
   (timp ?t)
   (zone (oprire-interzisa da))
   =>
   (assert (interdictie (t ?t) (motiv "R4 zona cu oprirea interzisa"))))

(defrule zona-stationare-activa
   (declare (salience 80))
   (timp ?t)
   (zone (stationare-interzisa da))
   =>
   (assert (interdictie (t ?t) (motiv "R5 zona cu stationarea interzisa"))))


;;; ---------------------------------------------------------------------
;;;  7. DECIZIA FINALA (R13)
;;;     Implicit parcarea este INTERZISA; devine PERMISA doar daca exista
;;;     un loc potrivit si nu exista nicio interdictie.
;;; ---------------------------------------------------------------------

(defrule R13-parcare-permisa
   (declare (salience 50))
   (timp ?t)
   (loc-potrivit (t ?t) (id ?id) (regula ?r))
   (not (interdictie (t ?t)))
   (not (decizie (t ?t)))
   =>
   (assert (decizie (t ?t) (rezultat permis)))
   (printout t "   => PARCAREA ESTE PERMISA pe locul " ?id " (" ?r ")" crlf))

(defrule R13-parcare-interzisa-fara-loc
   (declare (salience 50))
   (timp ?t)
   (not (loc-potrivit (t ?t)))
   (not (decizie (t ?t)))
   =>
   (assert (decizie (t ?t) (rezultat interzis)))
   (printout t "   => PARCAREA ESTE INTERZISA" crlf)
   (printout t "      motiv: nu exista loc potrivit" crlf))

(defrule R13-parcare-interzisa-cu-interdictie
   (declare (salience 50))
   (timp ?t)
   (loc-potrivit (t ?t))
   (interdictie (t ?t))
   (not (decizie (t ?t)))
   =>
   (assert (decizie (t ?t) (rezultat interzis)))
   (printout t "   => PARCAREA ESTE INTERZISA (exista loc, dar:)" crlf))

(defrule afiseaza-motiv
   (declare (salience 40))
   (timp ?t)
   (decizie (t ?t) (rezultat interzis))
   (interdictie (t ?t) (motiv ?m))
   =>
   (printout t "      motiv: " ?m crlf))


;;; ---------------------------------------------------------------------
;;;  8. TRECEREA LA CADRUL URMATOR
;;; ---------------------------------------------------------------------

(defrule cadrul-urmator
   (declare (salience 0))
   ?f <- (timp ?t)
   (timp-max ?max&:(< ?t ?max))
   =>
   (retract ?f)
   (assert (timp (+ ?t 1))))

(defrule sfarsit-scenariu
   (declare (salience 0))
   (timp ?t)
   (timp-max ?t)
   =>
   (printout t crlf "=== Sfarsitul scenariului (" ?t " cadre) ===" crlf))


;;; ---------------------------------------------------------------------
;;;  9. RULARE CU MASURAREA TIMPULUI
;;; ---------------------------------------------------------------------

(deffunction ruleaza ()
   (reset)
   (bind ?start (time))
   (run)
   (bind ?durata (- (time) ?start))
   (printout t "Timp de executie: " ?durata " s" crlf))
