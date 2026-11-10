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

## Installer le projet sur son PC (Laragon)

Prérequis : Laragon (avec PHP, MySQL et Composer), Git et Node.js.

1. Cloner le dépôt dans le dossier de Laragon :
   ```
   cd C:\laragon\www
   git clone https://github.com/Tidaku/arena.git
   cd arena
   ```
2. Installer les dépendances :
   ```
   composer install
   npm install
   ```
3. Créer son fichier de configuration (il n'est jamais envoyé sur GitHub) :
   ```
   copy .env.example .env
   php artisan key:generate
   ```
4. Dans `.env`, régler la base de données (valeurs par défaut de Laragon) :
   ```
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=arena
   DB_USERNAME=root
   DB_PASSWORD=
   ```
5. Créer la base : dans Laragon, bouton **Base de données** (HeidiSQL), puis *Fichier > Charger un fichier SQL* et exécuter `database/arena.sql`.
   Deux comptes de test sont créés : `admin@arena.test` et `lea.martin@test.fr`, mot de passe `password`.
6. Lancer le site :
   ```
   npm run dev
   ```
   puis ouvrir http://arena.test (Laragon crée l'adresse automatiquement ; sinon `php artisan serve` et http://127.0.0.1:8000).

## Organisation du dépôt

| Dossier | Contenu |
| --- | --- |
| `app/`, `routes/`, `resources/` | Le code Laravel |
| `database/arena.sql` | Script de création de la base (MPD), avec des données de test |
| `database/requetes.sql` | Les requêtes clés : disponibilité d'un créneau, filtres, distance, « Mes réservations » |
| `docs/` | Dictionnaire de données, MCD/MLD, support, guide GitHub |
| `.github/` | Modèles de tickets (incident, évolution) et de pull request |

## Travailler à plusieurs

Lire [CONTRIBUTING.md](CONTRIBUTING.md) avant le premier commit : on ne pousse jamais directement sur `main`.
