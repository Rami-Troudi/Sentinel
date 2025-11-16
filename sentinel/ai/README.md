# AI – Scoring de conduite Sentinel

Ce module contient tout ce qui concerne l’analyse de la conduite et le calcul du **Safety Score** et de l’**Eco Score** à partir des données brutes du capteur (accélérations, freinages, virages).

---

## Contenu

- `data/`
  - `sample_raw_trips.csv` : exemples de signaux bruts simulés  
    (timestamp, ax, ay, az, gx, gy, gz, speed, trip_id).
  - `sample_trips_features.csv` : features agrégées par trajet  
    (nombre de freinages brusques, virages serrés, accélérations fortes, etc.).

- `notebooks/`
  - `01_exploration_signaux.ipynb` : exploration des données brutes, visualisation.
  - `02_features_scoring.ipynb` : construction des features de conduite.
  - `03_modele_scoring_baseline.ipynb` : entraînement d’un premier modèle de scoring.

- `models/`
  - `sentinel_scoring_baseline.pkl` : version sérialisée du modèle de base.

---

## Rôle de l’IA dans Sentinel

L’IA sert à :

1. **Caractériser les trajets** : détection de freinages brusques, virages agressifs, conduite fluide.
2. **Calculer un Safety Score** : évaluer le niveau de risque global d’un conducteur.
3. **Calculer un Eco Score** : estimer la qualité de l’éco-conduite et l’impact énergétique.
4. **Produire des recommandations personnalisées** : indiquer au conducteur sur quels aspects progresser.

Ces résultats sont utilisés par :

- le **backend** pour alimenter les endpoints `/scores` ;
- le **mobile** pour les rapports hebdomadaires au conducteur ;
- le **dashboard** pour les agrégats au niveau portefeuille.

---
