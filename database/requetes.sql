-- =====================================================================
-- Arena — requêtes clés de l'application (à exécuter après arena.sql)
-- =====================================================================
USE arena;

-- ---------------------------------------------------------------------
-- 1. Le créneau est-il libre ?  (règle de gestion 8)
--    Demande : Terrain 1, le 2026-12-02, de 19:00 à 20:00.
--    Deux créneaux se chevauchent si : début_demandé < fin_existante
--                                   ET fin_demandée  > début_existant
--    0 ligne  -> libre ; 1 ligne ou plus -> déjà pris.
-- ---------------------------------------------------------------------
SELECT id_reserv, heure_debut_reserv, heure_fin_reserv
FROM reservation
WHERE id_terrain = 1
  AND date_seance_reserv = '2026-12-02'
  AND statut_reserv = 'confirmée'
  AND '19:00' < heure_fin_reserv
  AND '20:00' > heure_debut_reserv;
-- -> 1 ligne (18:00-19:30) : refusé.  Avec 19:30-21:00 : 0 ligne, accepté
--    (la réservation 20:00-21:00 est annulée, elle ne bloque rien).

-- ---------------------------------------------------------------------
-- 2. Recherche avec filtres : football, éclairé, couvert, vestiaires
--    (les filtres cochés deviennent des conditions WHERE)
-- ---------------------------------------------------------------------
SELECT t.id_terrain, c.nom_complexe, t.nom_terrain, t.tarif_horaire_terrain
FROM terrain t
JOIN complexe   c ON c.id_complexe = t.id_complexe
JOIN accueillir a ON a.id_terrain  = t.id_terrain
JOIN sport      s ON s.id_sport    = a.id_sport
WHERE s.libelle_sport = 'Football'
  AND t.eclaire_terrain = TRUE
  AND t.couvert_terrain = TRUE
  AND c.vestiaires_complexe = TRUE
ORDER BY t.tarif_horaire_terrain;          -- tri « Prix »

-- Filtre « Gratuit » : AND t.tarif_horaire_terrain = 0
-- Tri « Capacité »   : ORDER BY t.nb_joueurs_max_terrain DESC

-- ---------------------------------------------------------------------
-- 3. Tri par proximité : distance (en km) depuis la position de l'utilisateur
--    (ici : place des Fêtes, Paris 19e)
-- ---------------------------------------------------------------------
SELECT c.nom_complexe,
       ROUND(ST_Distance_Sphere(
           POINT(c.longitude_complexe, c.latitude_complexe),
           POINT(2.3930, 48.8765)) / 1000, 1) AS distance_km
FROM complexe c
ORDER BY distance_km;

-- ---------------------------------------------------------------------
-- 4. « Mes réservations » d'un client
-- ---------------------------------------------------------------------
SELECT r.date_seance_reserv, r.heure_debut_reserv, r.heure_fin_reserv,
       c.nom_complexe, t.nom_terrain, r.prix_reserv, r.statut_reserv
FROM reservation r
JOIN terrain  t ON t.id_terrain  = r.id_terrain
JOIN complexe c ON c.id_complexe = t.id_complexe
WHERE r.id_cli = 2
ORDER BY r.date_seance_reserv DESC, r.heure_debut_reserv DESC;
