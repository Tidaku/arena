# Règles de travail sur le dépôt Arena

## La règle d'or

**Personne ne pousse directement sur `main`.** `main` contient toujours une version qui marche. Tout passe par une branche puis une *pull request* (PR) relue par un autre membre.

## Le cycle d'une tâche

1. Prendre une *issue* dans le tableau du projet (colonne « À faire ») et se l'attribuer.
2. Partir d'un `main` à jour et créer sa branche :
   ```
   git switch main
   git pull
   git switch -c feature/filtre-eclaire
   ```
3. Coder, tester en local, puis faire des commits courts :
   ```
   git add .
   git commit -m "Ajouter le filtre Éclairé sur la page des résultats"
   ```
4. Envoyer la branche sur GitHub :
   ```
   git push -u origin feature/filtre-eclaire
   ```
5. Sur GitHub, ouvrir une **pull request** vers `main`, remplir le modèle, lier l'issue (`Closes #12`).
6. Un autre membre relit et approuve. On fusionne (*Merge*), puis on supprime la branche.
7. En cas de conflit : `git pull origin main` dans sa branche, corriger les fichiers en conflit, commit, push.

## Nommer les branches

| Préfixe | Pour | Exemple |
| --- | --- | --- |
| `feature/` | Une nouvelle fonctionnalité | `feature/questionnaire` |
| `fix/` | Corriger un bug | `fix/connexion-mot-de-passe` |
| `docs/` | Documentation, MCD, README | `docs/mld` |
| `infra/` | Partie SISR : serveur, déploiement | `infra/serveur-web` |

En minuscules, sans accents ni espaces.

## Écrire un message de commit

- Un verbe à l'infinitif + ce qui change : « Ajouter… », « Corriger… », « Supprimer… ».
- Un commit = une modification cohérente. Plusieurs petits commits valent mieux qu'un énorme.
- Mauvais : « modif », « ça marche », « test ». Bon : « Corriger le calcul du prix pour 90 minutes ».

## Ce qui ne va jamais sur GitHub

- Le fichier `.env` (mots de passe, clés Stripe de test) : chacun a le sien.
- `vendor/` et `node_modules/` : recréés par `composer install` et `npm install`.

Le `.gitignore` de Laravel s'en charge déjà : ne le modifiez pas pour les ajouter.

## Issues et tableau de suivi

- Une tâche = une issue. Modèles disponibles : **Incident** (quelque chose ne marche plus) et **Évolution** (nouvelle idée), comme dans notre organisation du support.
- Étiquettes : `incident`, `évolution`, `SLAM`, `SISR`, `prioritaire`.
- Le tableau *Projects* a trois colonnes : À faire, En cours, Fait.
