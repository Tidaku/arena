-- =====================================================================
-- Arena — script de création de la base (MPD issu du MLD)
-- SGBD : MySQL 8 (Laragon) — testé aussi sur MariaDB 10.11
-- Usage : mysql -u root < database/arena.sql   (ou import dans HeidiSQL)
-- =====================================================================

DROP DATABASE IF EXISTS arena;
CREATE DATABASE arena CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE arena;

-- ---------------------------------------------------------------------
-- CLIENT (id_cli, nom_cli, prenom_cli, mail_cli, mdp_cli, tel_cli,
--         rue_cli, cp_cli, ville_cli, date_inscription_cli, role_cli)
-- ---------------------------------------------------------------------
CREATE TABLE client (
    id_cli               INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_cli              VARCHAR(50)  NOT NULL,
    prenom_cli           VARCHAR(50)  NOT NULL,
    mail_cli             VARCHAR(100) NOT NULL,
    mdp_cli              VARCHAR(255) NOT NULL COMMENT 'Haché avec password_hash(), jamais en clair',
    tel_cli              VARCHAR(15)  NULL,
    rue_cli              VARCHAR(100) NULL,
    cp_cli               CHAR(5)      NULL COMMENT 'Texte : garde le 0 initial',
    ville_cli            VARCHAR(50)  NULL,
    date_inscription_cli DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    role_cli             ENUM('client','admin') NOT NULL DEFAULT 'client',
    CONSTRAINT pk_client PRIMARY KEY (id_cli),
    CONSTRAINT uq_client_mail UNIQUE (mail_cli)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- COMPLEXE (id_complexe, nom_complexe, rue_complexe, cp_complexe,
--           ville_complexe, latitude_complexe, longitude_complexe,
--           heure_ouverture_complexe, heure_fermeture_complexe,
--           vestiaires_complexe)
-- ---------------------------------------------------------------------
CREATE TABLE complexe (
    id_complexe              INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom_complexe             VARCHAR(100) NOT NULL,
    rue_complexe             VARCHAR(100) NOT NULL,
    cp_complexe              CHAR(5)      NOT NULL,
    ville_complexe           VARCHAR(50)  NOT NULL,
    latitude_complexe        DECIMAL(9,6) NOT NULL,
    longitude_complexe       DECIMAL(9,6) NOT NULL,
    heure_ouverture_complexe TIME         NOT NULL,
    heure_fermeture_complexe TIME         NOT NULL,
    vestiaires_complexe      BOOLEAN      NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_complexe PRIMARY KEY (id_complexe),
    CONSTRAINT ck_complexe_horaires CHECK (heure_ouverture_complexe < heure_fermeture_complexe)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- SPORT (id_sport, libelle_sport)
-- ---------------------------------------------------------------------
CREATE TABLE sport (
    id_sport      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    libelle_sport VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_sport PRIMARY KEY (id_sport),
    CONSTRAINT uq_sport_libelle UNIQUE (libelle_sport)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- TERRAIN (id_terrain, nom_terrain, surface_terrain, couvert_terrain,
--          eclaire_terrain, materiel_fourni_terrain,
--          nb_joueurs_min_terrain, nb_joueurs_max_terrain,
--          tarif_horaire_terrain, photo_terrain, #id_complexe)
-- ---------------------------------------------------------------------
CREATE TABLE terrain (
    id_terrain              INT UNSIGNED     NOT NULL AUTO_INCREMENT,
    nom_terrain             VARCHAR(50)      NOT NULL,
    surface_terrain         VARCHAR(30)      NOT NULL,
    couvert_terrain         BOOLEAN          NOT NULL DEFAULT FALSE,
    eclaire_terrain         BOOLEAN          NOT NULL DEFAULT FALSE,
    materiel_fourni_terrain BOOLEAN          NOT NULL DEFAULT FALSE,
    nb_joueurs_min_terrain  TINYINT UNSIGNED NOT NULL,
    nb_joueurs_max_terrain  TINYINT UNSIGNED NOT NULL,
    tarif_horaire_terrain   DECIMAL(6,2)     NOT NULL DEFAULT 0 COMMENT '0 = gratuit',
    photo_terrain           VARCHAR(255)     NULL COMMENT 'Nom du fichier image',
    id_complexe             INT UNSIGNED     NOT NULL,
    CONSTRAINT pk_terrain PRIMARY KEY (id_terrain),
    CONSTRAINT fk_terrain_complexe FOREIGN KEY (id_complexe)
        REFERENCES complexe (id_complexe) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_terrain_joueurs CHECK (nb_joueurs_min_terrain <= nb_joueurs_max_terrain),
    CONSTRAINT ck_terrain_tarif   CHECK (tarif_horaire_terrain >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- ACCUEILLIR (#id_terrain, #id_sport)  — association n,n Terrain / Sport
-- ---------------------------------------------------------------------
CREATE TABLE accueillir (
    id_terrain INT UNSIGNED NOT NULL,
    id_sport   INT UNSIGNED NOT NULL,
    CONSTRAINT pk_accueillir PRIMARY KEY (id_terrain, id_sport),
    CONSTRAINT fk_accueillir_terrain FOREIGN KEY (id_terrain)
        REFERENCES terrain (id_terrain) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_accueillir_sport FOREIGN KEY (id_sport)
        REFERENCES sport (id_sport) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- RESERVATION (id_reserv, date_creation_reserv, date_seance_reserv,
--              heure_debut_reserv, duree_reserv, heure_fin_reserv,
--              nb_joueurs_reserv, prix_reserv, statut_reserv,
--              #id_cli, #id_terrain)
-- ---------------------------------------------------------------------
CREATE TABLE reservation (
    id_reserv            INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    date_creation_reserv DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_seance_reserv   DATE              NOT NULL,
    heure_debut_reserv   TIME              NOT NULL,
    duree_reserv         SMALLINT UNSIGNED NOT NULL COMMENT 'En minutes',
    heure_fin_reserv     TIME              NOT NULL COMMENT 'Calculée : début + durée, mémorisée pour le contrôle de chevauchement',
    nb_joueurs_reserv    TINYINT UNSIGNED  NOT NULL,
    prix_reserv          DECIMAL(6,2)      NOT NULL COMMENT 'Calculé puis mémorisé (le tarif peut changer)',
    statut_reserv        ENUM('confirmée','annulée','terminée') NOT NULL DEFAULT 'confirmée',
    id_cli               INT UNSIGNED      NOT NULL,
    id_terrain           INT UNSIGNED      NOT NULL,
    CONSTRAINT pk_reservation PRIMARY KEY (id_reserv),
    CONSTRAINT fk_reservation_client FOREIGN KEY (id_cli)
        REFERENCES client (id_cli) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_reservation_terrain FOREIGN KEY (id_terrain)
        REFERENCES terrain (id_terrain) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_reservation_duree CHECK (duree_reserv > 0),
    CONSTRAINT ck_reservation_heures CHECK (heure_debut_reserv < heure_fin_reserv),
    CONSTRAINT ck_reservation_prix CHECK (prix_reserv >= 0)
) ENGINE=InnoDB;

-- Accélère la recherche des réservations d'un terrain un jour donné
CREATE INDEX idx_reservation_terrain_date ON reservation (id_terrain, date_seance_reserv);


-- =====================================================================
-- Données de test (fictives)
-- Mot de passe des deux comptes : "password"
-- =====================================================================

INSERT INTO sport (libelle_sport) VALUES
('Football'), ('Basket'), ('Tennis'), ('Padel'), ('Volley'), ('Badminton');

INSERT INTO complexe (nom_complexe, rue_complexe, cp_complexe, ville_complexe,
    latitude_complexe, longitude_complexe, heure_ouverture_complexe,
    heure_fermeture_complexe, vestiaires_complexe) VALUES
('City Foot Belleville',     '12 rue des Lilas',        '75019', 'Paris',   48.876200, 2.384500, '09:00', '23:00', TRUE),
('Gymnase des Buttes',       '4 avenue du Parc',        '75019', 'Paris',   48.880100, 2.381900, '08:00', '22:00', TRUE),
('Tennis Club du Canal',     '30 quai de la Marne',     '75019', 'Paris',   48.888600, 2.379300, '08:00', '21:00', TRUE),
('Playground Jaurès',        'Square Jean-Jaurès',      '93500', 'Pantin',  48.893800, 2.401000, '07:00', '22:00', FALSE);

INSERT INTO terrain (nom_terrain, surface_terrain, couvert_terrain, eclaire_terrain,
    materiel_fourni_terrain, nb_joueurs_min_terrain, nb_joueurs_max_terrain,
    tarif_horaire_terrain, photo_terrain, id_complexe) VALUES
('Terrain 1',     'Synthétique',  FALSE, TRUE,  TRUE,  6, 10, 80.00, 'cityfoot-t1.jpg', 1),
('Terrain 2',     'Synthétique',  TRUE,  TRUE,  TRUE,  6, 10, 96.00, 'cityfoot-t2.jpg', 1),
('Salle A',       'Parquet',      TRUE,  TRUE,  FALSE, 2, 12, 40.00, 'buttes-a.jpg',    2),
('Court central', 'Terre battue', FALSE, TRUE,  FALSE, 2, 4,  22.00, 'canal-central.jpg', 3),
('Court 2',       'Résine',       TRUE,  TRUE,  TRUE,  2, 4,  28.00, 'canal-2.jpg',     3),
('Playground',    'Bitume',       FALSE, FALSE, FALSE, 2, 10,  0.00, NULL,              4);

-- Terrain 1 et 2 : football ; Salle A : basket, volley, badminton (gymnase multisport)
-- Courts : tennis ; Court 2 : tennis et padel ; Playground : football et basket
INSERT INTO accueillir (id_terrain, id_sport) VALUES
(1, 1), (2, 1),
(3, 2), (3, 5), (3, 6),
(4, 3), (5, 3), (5, 4),
(6, 1), (6, 2);

INSERT INTO client (nom_cli, prenom_cli, mail_cli, mdp_cli, cp_cli, ville_cli, role_cli) VALUES
('Support', 'Arena', 'admin@arena.test',  '$2y$10$hQwCdyZULEQm7iIEcNWZMu0VvB.XyG0lWhd6H/rK.JMksVMOfVoCu', NULL,    NULL,    'admin'),
('Martin',  'Léa',   'lea.martin@test.fr', '$2y$10$hQwCdyZULEQm7iIEcNWZMu0VvB.XyG0lWhd6H/rK.JMksVMOfVoCu', '75019', 'Paris', 'client');

-- Une réservation confirmée de 18 h à 19 h 30 sur le Terrain 1 (exemple de la slide « créneaux »)
INSERT INTO reservation (date_seance_reserv, heure_debut_reserv, duree_reserv, heure_fin_reserv,
    nb_joueurs_reserv, prix_reserv, statut_reserv, id_cli, id_terrain) VALUES
('2026-12-02', '18:00', 90, '19:30', 10, 120.00, 'confirmée', 2, 1),
('2026-12-02', '20:00', 60, '21:00',  8,  80.00, 'annulée',   2, 1);
