# Arena

Application web de réservation de terrains de sport (football, basket, tennis, padel…).
L'utilisateur répond à un court questionnaire (sport, lieu, créneau), puis trie et filtre les terrains disponibles et réserve en quelques clics.

Projet de groupe BTS SIO — Bloc 1, 2026-2027.

## Équipe

| Membre | Option | Rôle dans le projet |
| --- | --- | --- |
| Tiago Da Cunha | SLAM | Application (Laravel) |
| Sacha Dumont | SLAM | Application (Laravel) |
| Julien Lim | SISR | Serveur, réseau, hébergement |
| Victor Jiang | SISR | Serveur, réseau, hébergement |
| Benjamin Quantin | SISR | Serveur, réseau, hébergement |

## Technologies

- **Laravel** (PHP) : l'application
- **MySQL** : la base de données
- **HTML, CSS, JavaScript** : l'interface, charte graphique « Terre battue »
- **Git + GitHub** : travail à plusieurs et historique
- **V2** : paiement Stripe en mode test, carte des terrains

## Organisation du dépôt

| Dossier | Contenu |
| --- | --- |
| `app/`, `routes/`, `resources/` | Le code Laravel |
| `database/arena.sql` | Script de création de la base (MPD), avec des données de test |
| `database/requetes.sql` | Les requêtes clés : disponibilité d'un créneau, filtres, distance, « Mes réservations » |
| `docs/` | Dictionnaire de données, MCD/MLD, support, guide GitHub |
| `.github/` | Modèles de tickets (incident, évolution) et de pull request |

