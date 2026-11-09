# Mettre Arena sur GitHub — guide pas à pas

À faire **une seule fois**, par une seule personne (Tiago). Les autres membres n'ont que l'étape 6.

## 1. Chaque membre a un compte GitHub

Créer un compte sur github.com si besoin, puis envoyer son **nom d'utilisateur** à Tiago.
Astuce : avec l'adresse mail du lycée, demander le *GitHub Student Developer Pack* (gratuit pour les étudiants).

## 2. Créer l'organisation

1. Sur GitHub : photo de profil > **Your organizations** > **New organization**.
2. Choisir l'offre **Free**.
3. Nom : `arena-bts` (s'il est pris : `arena-bts-2027`, puis adapter les liens du README).
4. Inviter les 4 autres membres par leur nom d'utilisateur. Rôle : *Member* (Tiago reste *Owner* ; ajouter un 2e owner, par exemple l'autre SLAM, pour ne pas dépendre d'un seul compte).

## 3. Créer le dépôt

1. Dans l'organisation : **New repository**.
2. Nom : `arena`. Description : « Réservation de terrains de sport — projet BTS SIO ».
3. Visibilité : **Public**. Raisons : la protection de `main` (étape 5) n'est gratuite que sur un dépôt public, et le dépôt servira de portfolio. Rien de secret n'y va : le `.env` reste sur vos PC.
4. **Ne cocher aucune case** (pas de README, pas de .gitignore, pas de licence) : on envoie les nôtres.
5. Dans *Settings > Collaborators and teams* : donner le rôle **Write** aux membres.

## 4. Créer le projet Laravel et faire le premier push

Sur le PC de Tiago, avec Laragon démarré :

1. Clic droit dans Laragon > **Quick app > Laravel**, nom `arena`.
   (Ou dans le terminal Laragon : `cd C:\laragon\www` puis `composer create-project laravel/laravel arena`.)
2. Copier dans `C:\laragon\www\arena` tout le contenu de ce dossier (README.md, CONTRIBUTING.md, `database/`, `docs/`, `.github/`) en **remplaçant** le README.md de Laravel.
3. Dans `.env` **et** `.env.example`, remplacer la partie base de données par :
   ```
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=arena
   DB_USERNAME=root
   DB_PASSWORD=
   ```
   (`.env.example` part sur GitHub sans mot de passe ; `.env` reste sur le PC.)
4. Bouton **Terminal** de Laragon :
   ```
   cd C:\laragon\www\arena
   git init -b main
   git add .
   git status
   ```
   Vérifier dans la liste qu'il n'y a **ni `.env`, ni `vendor/`, ni `node_modules/`**.
   ```
   git commit -m "Initialiser le projet Laravel Arena"
   git remote add origin https://github.com/Tidaku/arena.git
   git push -u origin main
   ```
   La première fois, une fenêtre de connexion GitHub s'ouvre dans le navigateur : l'accepter.
   Si `git` n'est pas reconnu : installer *Git for Windows*, puis rouvrir le terminal.

## 5. Protéger `main`

Dans le dépôt : **Settings > Branches > Add branch protection rule** (ou *Add classic branch protection rule*).

- Branch name pattern : `main`
- Cocher **Require a pull request before merging**, puis **Require approvals : 1**.
- Enregistrer.

Désormais, tout passe par une pull request relue par quelqu'un d'autre (voir CONTRIBUTING.md).

## 6. Chaque membre récupère le projet

Suivre la partie « Installer le projet sur son PC » du README : `git clone`, `composer install`, `.env`, import de `database/arena.sql`.

## 7. Créer le tableau de suivi

1. Onglet **Projects** de l'organisation > **New project** > modèle *Board* (colonnes À faire / En cours / Fait). Le relier au dépôt `arena`.
2. Onglet **Issues** > **Labels** : créer `incident`, `évolution`, `SLAM`, `SISR`, `prioritaire`.
3. Créer les premières issues (une par tâche) :

| Issue | Étiquettes |
| --- | --- |
| Écrire les migrations Laravel à partir du MLD | SLAM, prioritaire |
| Remplir la base avec des données de test (seeders) | SLAM |
| Comptes utilisateurs : inscription, connexion, mot de passe oublié | SLAM, prioritaire |
| Page admin pour le support (état d'un compte, dernière connexion) | SLAM |
| Questionnaire : écrans sport puis lieu et créneau | SLAM |
| Page des résultats : tri et filtres | SLAM |
| Réservation avec contrôle de chevauchement | SLAM, prioritaire |
| Interface finale charte « Terre battue » + logo | SLAM |
| Installer le serveur web et MySQL | SISR, prioritaire |
| Installer GLPI pour le support | SISR |
| Sauvegardes de la base | SISR |
