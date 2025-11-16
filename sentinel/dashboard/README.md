
---

## 5️⃣ `dashboard/README.md`


# Dashboard – Interface assureur Sentinel

Le dashboard est une application web destinée aux équipes de l’assureur.  
Il permet de :

- visualiser l’état du **portefeuille de conducteurs** ;
- identifier les **zones à risque** ;
- suivre l’évolution des **scores moyens** ;
- piloter les **programmes de récompenses**.

Stack cible : **React + TypeScript** (avec ou sans Next.js).

---

## Structure

- `src/App.tsx` : point d’entrée de l’app.

- `src/pages/`
  - `Dashboard.tsx` : vue globale (scores moyens, KPIs, graphes).
  - `DriverDetail.tsx` : détails pour un conducteur (historique des scores, trajets).
  - `RiskMap.tsx` : carte affichant les zones de risque (données mock).

- `src/components/`
  - `ScoreSummaryCard.tsx` : carte présentant les scores moyens.
  - `PortfolioTable.tsx` : tableau des conducteurs (score, segment, statut).
  - `RiskMap.tsx` : composant carte intégrable dans plusieurs pages.

- `src/services/`
  - `api.ts` : fonctions d’appel vers le backend (`getPortfolio`, `getDriverScores`, etc.).

- `src/mock/`
  - `mock_insurer_view.json` : données de démo (portefeuille et statistiques).

---

## Scénario d’utilisation démo

1. L’assureur se connecte (auth simplifiée ou bypass).
2. Il visualise :
   - la distribution des Safety/Eco Scores,
   - les conducteurs les plus à risque,
   - les zones géographiques où les incidents sont fréquents (mock).
3. Il accède à la fiche d’un conducteur pour voir :
   - son évolution de score,
   - ses trajets récents,
   - ses eco-points.

---

## Lancer le dashboard

```bash
cd dashboard
npm install
npm run dev
