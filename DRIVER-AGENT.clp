;;----------------------------------
;;
;;  Validarea manevrei de parcare (parking-maneuver)
;;
;;  La fiecare cadru parcarea este INTERZISA implicit (initCycle-parking).
;;  Devine PERMISA doar daca exista un loc potrivit (R1-R3) si nu exista
;;  niciun motiv de interdictie (R4-R12, R14).
;;
;;  Ordinea in cadrul unui ciclu (salience):
;;     93  percepts_into_beliefs (AddMomentBelifsGetStartTime.clp)
;;     90  afisarea vitezei
;;     89  initCycle-parking: parking-maneuver prohibited
;;     85  actualizarea zonelor de interdictie - credinte fluent (R4-R7)
;;     80  locuri potrivite (R1-R3) si motive de interdictie (R4, R5, R8-R12, R14)
;;     70  decizia finala (R13)
;;    -45  afisarea motivelor / locului ales
;;    -50  tell: afisarea deciziei (TellDeleteMomentBelifsGetEndTime.clp)
;;
;;  Perceptii folosite (percept_pobj  percept_pname  percept_pval):
;;     ego     speed                km/h
;;     ego     is_electric          yes|no
;;     ego     has_disability_card  yes|no
;;     <loc>   isa                  parking_spot
;;     <loc>   status               free|occupied
;;     <loc>   reserved_for         none|disabled|electric
;;     <loc>   rel_dist             m
;;     <semn>  isa                  road_sign
;;     <semn>  has_type             no_stopping|no_parking|end_no_stopping|
;;                                  end_no_parking|end_all_restrictions
;;     <elem>  isa                  road_elem
;;     <elem>  has_type             crosswalk|intersection|bus_stop|railway_level_crossing
;;     <elem>  rel_dist             m
;;     <pers>  isa                  pedestrian
;;     <pers>  rel_dist             m
;;----------------------------------


;
; Sfarsitul scenei: nu s-a mai incarcat niciun fisier de perceptii
;

(defrule AGENT::end_of_scene
    (declare (salience 95))
    (timp (valoare ?t))
    (not (ag_percept (percept_pobj ego)))
=>
    (printout t "   === Sfarsitul scenei (" (- ?t 1) " cadre) ===" crlf)
    (halt)
)

(defrule AGENT::print_speed
    (declare (salience 90))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname speed) (bel_pval ?v))
=>
    (printout t "         viteza = " ?v " km/h" crlf)
)


;
; Mandatory rule - parcarea este interzisa implicit
;

(defrule AGENT::initCycle-parking
    (declare (salience 89))
    (timp (valoare ?)) ;make sure it fires each cycle
=>
    (if (eq ?*ag-in-debug* TRUE) then (printout t "    <D>initCycle-parking prohibited by default " crlf))
    (assert (ag_bel (bel_type moment) (bel_pname parking-maneuver) (bel_pval prohibited)))
)


;;----------------------------------
;;  Semne de interzicere - zone (R4-R7)
;;  Raman valabile (credinte fluent) pana cand zona se termina.
;;----------------------------------

(defrule AGENT::R4_intra_zona_oprire_interzisa
    (declare (salience 85))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname has_type) (bel_pval no_stopping))
    (not (ag_bel (bel_type fluent) (bel_pname no-stopping-zone)))
=>
    (assert (ag_bel (bel_type fluent) (bel_pobj ego) (bel_pname no-stopping-zone) (bel_pval yes)))
    (printout t "         [R4] intra in zona cu oprirea interzisa" crlf)
)

(defrule AGENT::R5_intra_zona_stationare_interzisa
    (declare (salience 85))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname has_type) (bel_pval no_parking))
    (not (ag_bel (bel_type fluent) (bel_pname no-parking-zone)))
=>
    (assert (ag_bel (bel_type fluent) (bel_pobj ego) (bel_pname no-parking-zone) (bel_pval yes)))
    (printout t "         [R5] intra in zona cu stationarea interzisa" crlf)
)

(defrule AGENT::R6_iese_zona_oprire_interzisa
    (declare (salience 85))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname has_type) (bel_pval end_no_stopping|end_all_restrictions))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-stopping-zone))
=>
    (retract ?f)
    (printout t "         [R6] zona cu oprirea interzisa s-a terminat" crlf)
)

(defrule AGENT::R7_iese_zona_stationare_interzisa
    (declare (salience 85))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname isa) (bel_pval road_sign))
    (ag_bel (bel_type moment) (bel_pobj ?s) (bel_pname has_type) (bel_pval end_no_parking|end_all_restrictions))
    ?f <- (ag_bel (bel_type fluent) (bel_pname no-parking-zone))
=>
    (retract ?f)
    (printout t "         [R7] zona cu stationarea interzisa s-a terminat" crlf)
)

(defrule AGENT::zona_oprire_activa
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type fluent) (bel_pname no-stopping-zone) (bel_pval yes))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval "R4 zona cu oprirea interzisa")))
)

(defrule AGENT::zona_stationare_activa
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type fluent) (bel_pname no-parking-zone) (bel_pval yes))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval "R5 zona cu stationarea interzisa")))
)


;;----------------------------------
;;  Exista un loc liber potrivit? (R1-R3)
;;----------------------------------

(defrule AGENT::R1_loc_liber_nerezervat
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname isa) (bel_pval parking_spot))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname status) (bel_pval free))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname reserved_for) (bel_pval none))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname suitable_spot) (bel_pval R1)))
)

(defrule AGENT::R2_loc_dizabilitati
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname isa) (bel_pval parking_spot))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname status) (bel_pval free))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname reserved_for) (bel_pval disabled))
    (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname has_disability_card) (bel_pval yes))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname suitable_spot) (bel_pval R2)))
)

(defrule AGENT::R3_loc_electrice
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname isa) (bel_pval parking_spot))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname status) (bel_pval free))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname reserved_for) (bel_pval electric))
    (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname is_electric) (bel_pval yes))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname suitable_spot) (bel_pval R3)))
)


;;----------------------------------
;;  Locuri in care nu ai voie sa parchezi (R8-R12)
;;  Conteaza doar in cadrul in care obiectul este vazut.
;;----------------------------------

(defrule AGENT::R8_trecere_de_pietoni
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname isa) (bel_pval road_elem))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname has_type) (bel_pval crosswalk))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname rel_dist) (bel_pval ?d))
    (test (< ?d 25))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval "R8 trecere de pietoni la mai putin de 25 m")))
)

(defrule AGENT::R9_intersectie
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname isa) (bel_pval road_elem))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname has_type) (bel_pval intersection))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname rel_dist) (bel_pval ?d))
    (test (< ?d 25))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval "R9 intersectie la mai putin de 25 m")))
)

(defrule AGENT::R10_statie_transport_public
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname isa) (bel_pval road_elem))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname has_type) (bel_pval bus_stop))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname rel_dist) (bel_pval ?d))
    (test (< ?d 25))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval "R10 statie de transport public la mai putin de 25 m")))
)

(defrule AGENT::R11_trecere_cale_ferata
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname isa) (bel_pval road_elem))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname has_type) (bel_pval railway_level_crossing))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname rel_dist) (bel_pval ?d))
    (test (< ?d 50))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval "R11 trecere la nivel cu calea ferata la mai putin de 50 m")))
)

(defrule AGENT::R12_pieton_aproape
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname isa) (bel_pval pedestrian))
    (ag_bel (bel_type moment) (bel_pobj ?o) (bel_pname rel_dist) (bel_pval ?d))
    (test (< ?d 5))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval "R12 pieton la mai putin de 5 m - masina asteapta")))
)


;;----------------------------------
;;  Viteza (R14)
;;----------------------------------

(defrule AGENT::R14_viteza_prea_mare
    (declare (salience 80))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname speed) (bel_pval ?v))
    (test (> ?v ?*parking-max-speed*))
=>
    (assert (ag_bel (bel_type moment) (bel_pobj ego) (bel_pname parking_prohibited_by)
                    (bel_pval (str-cat "R14 viteza prea mare pentru parcare (" ?v
                                       " km/h > " ?*parking-max-speed* " km/h)"))))
)


;;----------------------------------
;;  Decizia finala (R13)
;;----------------------------------

(defrule AGENT::R13_parcare_permisa
    (declare (salience 70))
    (timp (valoare ?t))
    ?f <- (ag_bel (bel_type moment) (bel_pname parking-maneuver) (bel_pval prohibited))
    (ag_bel (bel_type moment) (bel_pname suitable_spot))
    (not (ag_bel (bel_type moment) (bel_pname parking_prohibited_by)))
=>
    (retract ?f)
    (assert (ag_bel (bel_type moment) (bel_pname parking-maneuver) (bel_pval allowed)))
)


;;----------------------------------
;;  Explicatia deciziei - afisata chiar inainte de tell, cat timp
;;  credinta parking-maneuver inca exista
;;----------------------------------

(defrule AGENT::explica_loc_ales
    (declare (salience -45))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pname parking-maneuver))
    (ag_bel (bel_type moment) (bel_pobj ?l) (bel_pname suitable_spot) (bel_pval ?r))
    (not (ag_bel (bel_type moment) (bel_pname parking_prohibited_by)))
=>
    (printout t "            loc potrivit: " ?l " (" ?r ")" crlf)
)

(defrule AGENT::explica_fara_loc
    (declare (salience -45))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pname parking-maneuver))
    (not (ag_bel (bel_type moment) (bel_pname suitable_spot)))
=>
    (printout t "            motiv: nu exista loc potrivit" crlf)
)

(defrule AGENT::explica_interdictie
    (declare (salience -45))
    (timp (valoare ?t))
    (ag_bel (bel_type moment) (bel_pname parking-maneuver))
    (ag_bel (bel_type moment) (bel_pname parking_prohibited_by) (bel_pval ?m))
=>
    (printout t "            motiv: " ?m crlf)
)
