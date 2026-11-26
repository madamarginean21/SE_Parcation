;
;----------Modul: MAIN-------------
;
(defmodule MAIN
    ;CLIPS 6.4 (export deftemplate initial-fact)
    (export deftemplate tic)
)

(deftemplate MAIN::tic)

(defglobal ?*main-in-debug* = FALSE)
; (defglobal ?*main-in-debug* = TRUE)
(defglobal ?*ag-tic-in-debug* = FALSE)
; (defglobal ?*ag-tic-in-debug* = TRUE)


; Limita de siguranta pentru (run). Scena se opreste singura (halt)
; cand nu mai exista fisier de perceptii pentru cadrul urmator.
(defglobal ?*totalNrRules* = 100000)

;
;----------Modul: PERCEPT-MANAGER-----------
;
(defmodule PERCEPT-MANAGER
 ;CLIPS 6.4 (import MAIN deftemplate initial-fact)
 (import MAIN deftemplate tic)
 (export deftemplate timp)
 (export deftemplate ag_percept)
)


(defglobal ?*sim-in-debug* = FALSE)
; (defglobal ?*sim-in-debug* = TRUE)
(defglobal ?*percepts-in-debug* = FALSE)
; (defglobal ?*percepts-in-debug* = TRUE)
(defglobal ?*perceptsDir* = "./percepts/scene1/")
; (defglobal ?*perceptsDir* = "./percepts/scene2/")
; (defglobal ?*perceptsDir* = "./percepts/scene3/")
; (defglobal ?*perceptsDir* = "./percepts/scene4/")
; (defglobal ?*perceptsDir* = "./percepts/scene5/")
; (defglobal ?*perceptsDir* = "./percepts/scene6/")


(deftemplate PERCEPT-MANAGER::timp (slot valoare))

(deftemplate PERCEPT-MANAGER::ag_percept
    (slot percept_pname)
    (slot percept_pval)
    (slot percept_pobj))

;
;-------------Modul: DRIVER-AGENT
;
(defmodule AGENT
    ;CLIPS 6.4 (import MAIN deftemplate initial-fact)
    (import PERCEPT-MANAGER deftemplate timp)
    (import PERCEPT-MANAGER deftemplate ag_percept)
)

(defglobal ?*ag-in-debug* = FALSE)
; (defglobal ?*ag-in-debug* = TRUE)
(defglobal ?*ag-percepts-in-debug* = FALSE)
; (defglobal ?*ag-percepts-in-debug* = TRUE)

; (defglobal ?*ag-measure-time* = FALSE)
(defglobal ?*ag-measure-time* = TRUE)

; Viteza maxima (km/h) la care poate incepe manevra de parcare (R14)
(defglobal ?*parking-max-speed* = 10)

(deftemplate ag_bel
    (slot bel_type) ; fluent|moment
    (slot bel_pname) ; which property we're talking about: parking-maneuver|no-stopping-zone|no-parking-zone|suitable_spot|parking_prohibited_by
    (slot bel_pval) ; bel_pname value: (prohibited|allowed) or (yes|no) or the rule/reason
    (slot bel_pobj)
)
