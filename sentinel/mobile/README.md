
---

## 4️⃣ `mobile/README.md`

```markdown
# Mobile – App conducteur Sentinel

L’application mobile est l’interface principale pour le conducteur.  
Elle permet de :

- **lier le module Sentinel** (pairing) ;
- **consulter ses trajets** ;
- **visualiser Safety Score et Eco Score** ;
- **gérer les eco-points** et les récompenses.

Cible : **React Native + TypeScript** (ou Flutter, selon la stack retenue).

---

## Structure

- `src/App.tsx` : point d’entrée de l’app, navigation principale.
- `src/screens/`
  - `PairingScreen.tsx` : écran d’association avec le module (BLE/WiFi – stub).
  - `TripsScreen.tsx` : liste des trajets du conducteur.
  - `TripDetailScreen.tsx` : détail d’un trajet (distance, freinages, virages…).
  - `ScoresScreen.tsx` : affichage des scores Safety/Eco + conseils.
  - `RewardsScreen.tsx` : consultation des eco-points et des récompenses.

- `src/components/`
  - `ScoreCard.tsx` : composant de carte score (Safety/Eco).
  - `TripItem.tsx` : élément de liste pour un trajet.

- `src/services/`
  - `api.ts` : fonctions d’appel au backend (`getTrips`, `getScores`, etc.).
  - `device.ts` : stub pour la connexion au module (BLE/WiFi).

- `src/mock/`
  - `mock_trips.json` : données de trajets simulés.
  - `mock_scores.json` : scores simulés pour démo hors ligne.

---

## Fonctionnement en mode démo

En phase hackathon, l’app peut :

- afficher des trajets et scores **à partir des fichiers mock** ;
- appeler les endpoints backend **lorsqu’ils seront disponibles** ;
- simuler le pairing avec le module embarqué.

---

