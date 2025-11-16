# Sentinel

Plateforme de prévention routière basée sur un boîtier embarqué, de l’analyse IA et un système de récompenses pour la conduite responsable.  
Projet développé dans le cadre du hackathon **Hack For Good 4.0 – Forum INSAT Entreprise**, en partenariat avec **Lloyd Assurance**.

---

## 1. Introduction

**Sentinel** est une solution de télématique intelligente qui combine :

- un **boîtier embarqué ESP32** installé dans le véhicule ;
- une **application mobile** pour le conducteur ;
- une **infrastructure cloud** et une **API backend** ;
- un **module d’intelligence artificielle** pour analyser la conduite ;
- un **dashboard web** pour l’assureur.

L’objectif est double :

1. **Mieux comprendre et anticiper le risque** (conducteurs et zones).  
2. **Encourager et récompenser la conduite responsable** via un système d’éco-points échangeables contre des avantages.

---

## 2. Problématique

Les assureurs automobiles, font face à plusieurs limitations :

- Évaluation du risque principalement **a posteriori**, après sinistre.
- Données comportementales **peu spécifiques** et difficilement exploitables.
- Solutions basées sur smartphone **peu fiables** (capteurs limités, usage intermittent, contournement possible).
- **Absence d’incitation positive** claire pour encourager la bonne conduite.
- Manque de **cartographie dynamique** des zones routières à risque.
- Nécessité de s’inscrire dans une démarche **RSE** crédible (sécurité, éco-conduite, inclusion).

Conséquences :

- sinistralité plus élevée que nécessaire ;
- difficulté à adapter les primes au comportement réel ;
- faible engagement des assurés ;
- opportunités perdues en matière de prévention et de fidélisation.

---

## 3. Description de la solution

### 3.1 Vue d’ensemble

Sentinel propose un écosystème complet qui relie :

- les **données terrain** (capteurs dans le véhicule) ;
- une **analyse IA** à plusieurs niveaux (événements, comportements, zones) ;
- un **système de scoring** et de **classification des risques** ;
- un **programme d’éco-points** qui transforme la prévention en valeur pour le client ;
- un **outil de pilotage** pour l’assureur.

### 3.2 Fonctionnalités principales

- Collecte de télémétrie : accélérations, freinages brusques, virages, vibrations, etc.
- Détection d’événements de conduite à risque.
- Calcul d’un **score de conduite dynamique** pour chaque conducteur.
- Classification des **zones géographiques à risque**.
- Génération d’**éco-points** pour les conducteurs responsables.
- Échange des éco-points contre :
  - réductions sur la prime d’assurance,
  - bons et avantages chez les partenaires de l’assureur.
- Dashboard pour Lloyd :
  - vision agrégée des risques,
  - cartographie des zones,
  - suivi des indicateurs RSE et du programme de récompenses.
  - Classification des conduteurs selon le risque

---

## 4. Schématisation de la communication dans le système

Schéma logique des flux de données et des interactions :

```text

           │
           ▼
   [Boîtier embarqué ESP32]
  - Capteurs (accéléromètre, gyroscope,
  vibration, etc.)
  - Prétraitement local (seuils)
           │
    Wi-Fi / Bluetooth 
           │
           ▼
      [Application Mobile]
  - Ingestion des données
  - Authentification & sécurité
  - Stockage (base de données)
           │
   ┌───────┴───────────────────┐
   ▼                           ▼ 
[Service IA Cloud]     [Base de données]
- Feature eng.        - Historique scores
- Classification      - Scores
- Scoring             - Éco-points
           │
   ┌───────┴───────────────┐
   ▼                       ▼
[Application mobile]   [Dashboard assureur]
- Score conducteur     - Vue portefeuille
- Historique scores   - Segmentation
- Éco-points           - Zones à risque
- Récompenses          - KPIs RSE / sinistres
```

---

## 5. Technologies utilisées

### 5.1 Boîtier embarqué (ESP32 / IoT)

- **Carte** : ESP32.  
- **Langage** : C / C++ (Arduino / ESP-IDF).  
- **Capteurs** :
  - IMU (accéléromètre + gyroscope),
  - capteur de vibrations,
  - capteur GPS
  - capteurs de Tension batterie
- **Rôle** :
  - collecte des données brutes,
  - filtrage et prétraitement (seuils, moyennes),
  - envoi périodique ou en quasi-temps réel vers l'application mobile.

### 5.2 Backend & API

- **Langage** : Node.js (TypeScript ou JavaScript).  
- **Framework** : Express ou Fastify.  
- **Base de données** : PostgreSQL ou MongoDB.  
- **Responsabilités principales** :
  - endpoints d’ingestion de télémétrie,
  - gestion des utilisateurs (conducteurs, assureurs),
  - calcul et mise à jour des scores,
  - gestion des éco-points (crédit, débit, historique),
  - exposition d’API pour l’application mobile et le dashboard.

### 5.3 Intelligence Artificielle

- **Langage** : Python.  
- **Bibliothèques** : NumPy, Pandas, scikit-learn.  
- **Fonctions IA** :
  - extraction de caractéristiques à partir des signaux (fenêtres temporelles),
  - classification de segments de conduite (normal, agressif, risqué),
  - détection d’événements critiques (freinage brusque, virage sec, oscillations anormales),
  - scoring global du conducteur,
  - analyse des corrélations entre segments de route et risque (zones à risque).

### 5.4 Application mobile conducteur

- **Technologie**: Flutter ou React Native.  
- **Fonctionnalités** :
  - Collecte des données du boitier
  - affichage du **score de conduite** (global et par trajet),
  - consultation de l’**historique des scores** et événements,
  - affichage et gestion des **éco-points**,
  - catalogue des **récompenses** (réductions, bons, avantages partenaires),
  - notifications de feedback (alertes, conseils d’amélioration).

### 5.5 Dashboard assureur

- **Frontend** : React ou Next.js.  
- **Visualisation** : Recharts, Chart.js ou équivalent.  
- **Fonctionnalités** :
  - vue d’ensemble des conducteurs classés par niveau de risque,
  - filtres par profil, zone, période,
  - cartographie des zones à risque (intégration API de carte),
  - suivi de l’émission et de l’utilisation des éco-points,
  - indicateurs de performance (évolution des scores, baisse des événements critiques, etc.).

### 5.6 Infrastructure & déploiement (prototype)

- Hébergement cloud (type PaaS : Render, Railway, Heroku ou autre).
- CI/CD simple via GitHub Actions (tests de base, déploiement).
- Sécurisation minimale des endpoints (HTTPS, tokens, etc., selon l’avancement).

---


## 6. Marketing et positionnement

**Pour les conducteurs :**

- accès à un score de conduite clair et pédagogique ;
- possibilité de **gagner des éco-points** en améliorant leur comportement ;
- conversion des points en **avantages concrets** (réductions, bons, services).

**Pour l’assureur (Lloyd) :**

- meilleure **segmentation des clients** par niveau de risque réel ;
- réduction de la sinistralité grâce à la prévention ;
- offre différenciante, orientée **RSE** et innovation ;
- programme de fidélisation basé sur des récompenses plutôt que sur la sanction.

**Pour les partenaires :**

- visibilité auprès de conducteurs engagés ;
- intégration de leurs offres dans un écosystème à forte valeur ajoutée.

---

## 8. Contexte Hack For Good 4.0

Le projet est développé dans le cadre du hackathon **Hack For Good 4.0** dont les axes incluent :

- **prévention routière**,  
- **mobilité responsable**,  
- intégration de l’**IA** dans une démarche RSE.

Sentinel vise à :

- adresser une problématique réelle et prioritaire pour l’assurance ;
- démontrer une **intégration IA crédible** et cohérente ;
- proposer un prototype techniquement réalisable dans les contraintes du hackathon ;
- mettre en avant un **impact RSE** mesurable (sécurité, éco-conduite, inclusion).

---


## 9. Avertissement

Ce dépôt correspond à un **prototype de hackathon** :

- le code est en cours d’évolution ;
- certains modules sont partiellement implémentés ou simulés ;
- la solution n’est pas destinée à un usage en production sans durcissement, revue de sécurité et validation approfondie.

---

## 10. Crédits

Projet **Sentinel** — développé par l’équipe cham3a^2 au **Hack For Good 4.0 – Forum INSAT Entreprise**, en collaboration avec **Lloyd Assurance**.

