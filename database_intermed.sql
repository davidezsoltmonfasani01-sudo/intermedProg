-- ============================================================================
-- Script SQL completo per la creazione e il popolamento delle tabelle
-- Corso: Internet e Medicina
-- ============================================================================

-- 1. Tabella Stati
CREATE TABLE Stati (
    ID_Stato INT NOT NULL,
    Stato VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_Stato)
);

-- 2. Tabella Tipi_Notifiche
CREATE TABLE Tipi_Notifiche (
    ID_tipo INT NOT NULL,
    Descrizione VARCHAR(50) NOT NULL,
    Messaggio VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID_tipo)
);

-- 3. Tabella Utenti
CREATE TABLE Utenti (
    CF CHAR(16) NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Data_Nascita DATE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    ID_stato INT NOT NULL,
    Ruolo VARCHAR(50) NOT NULL,
    Username VARCHAR(50) NOT NULL,
    PRIMARY KEY (CF)
);

-- 4. Tabella Schede_Professionali
CREATE TABLE Schede_Professionali (
    CF_personale CHAR(16) NOT NULL,
    descrizione TEXT NOT NULL,
    data_certificazione DATE NOT NULL,
    numero_albo INT NOT NULL,
    PRIMARY KEY (CF_personale)
);

-- 5. Tabella Associazioni_KC_PZ
CREATE TABLE Associazioni_KC_PZ (
    ID_associazione INT NOT NULL,
    CF_pz CHAR(16) NOT NULL,
    CF_kc CHAR(16) NOT NULL,
    Data_inizio DATETIME NOT NULL,
    Data_fine DATETIME NOT NULL,
    ID_stato INT NOT NULL,
    Motivazione VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID_associazione)
);

-- 6. Tabella Prenotazioni
CREATE TABLE Prenotazioni (
    ID_prenotazione INT NOT NULL,
    CF_pz CHAR(16) NOT NULL,
    CF_md CHAR(16) NOT NULL,
    Data_prenotazione DATETIME NOT NULL,
    Data_visita DATETIME NOT NULL,
    ID_stato INT NOT NULL,
    PRIMARY KEY (ID_prenotazione)
);

-- 7. Tabella Visite
CREATE TABLE Visite (
    ID_visita INT NOT NULL,
    Data_visita DATETIME NOT NULL,
    Data_fine DATETIME NOT NULL,
    ID_prenotazione INT NOT NULL,
    ID_stato INT NOT NULL,
    Altezza INT NOT NULL,
    Peso INT NOT NULL,
    fabbisogno_energetico INT NOT NULL,
    grassi INT NOT NULL,
    note TEXT NOT NULL,
    PRIMARY KEY (ID_visita)
);

-- 8. Tabella Pagine_Diario
CREATE TABLE Pagine_Diario (
    ID_pagina INT NOT NULL,
    CF_pz CHAR(16) NOT NULL,
    ID_visita INT NOT NULL,
    Data_pagina DATETIME NOT NULL,
    Data_compilazione DATETIME NOT NULL,
    Peso_giornaliero INT NOT NULL,
    PRIMARY KEY (ID_pagina)
);

-- 9. Tabella Annotazioni_Diario
CREATE TABLE Annotazioni_Diario (
    ID_annotazione INT NOT NULL,
    ID_pagina INT NOT NULL,
    Data_ultima_modifica DATETIME NOT NULL,
    Testo TEXT NOT NULL,
    CF CHAR(16) NOT NULL,
    PRIMARY KEY (ID_annotazione)
);

-- 10. Tabella Porzioni
CREATE TABLE Porzioni (
    ID_porzione INT NOT NULL,
    Tipo_pasto VARCHAR(50) NOT NULL,
    Alimento VARCHAR(50) NOT NULL,
    Quantita INT NOT NULL,
    PRIMARY KEY (ID_porzione)
);

-- 11. Tabella Notifiche
CREATE TABLE Notifiche (
    ID_notifica INT NOT NULL,
    ID_risorsa INT NOT NULL,
    Risorsa VARCHAR(50) NOT NULL,
    ID_tipo INT NOT NULL,
    ID_stato INT NOT NULL,
    Data DATETIME NOT NULL,
    CF CHAR(16) NULL,
    PRIMARY KEY (ID_notifica)
);

-- ============================================================================
-- Popolamento dati iniziali
-- ============================================================================

INSERT INTO Stati (ID_Stato, Stato) VALUES
(1, 'Attesa'),
(2, 'Attivo'),
(10, 'visualizzata'),
(11, 'non visualizzata');

INSERT INTO Tipi_Notifiche (ID_tipo, Descrizione, Messaggio) VALUES
(1, 'Nuovo Referto', 'e'' stato compilato un nuovo referto'),
(2, 'Nuova Prenotazione', 'un paziente ha prenotato una nuova visita'),
(3, 'Annullamento Prenotazione', 'e'' stato annullata una prenotazione');

INSERT INTO Utenti (CF, Cognome, Nome, Data_Nascita, Password, ID_stato, Ruolo, Username) VALUES
('1111111111111111', 'Alzheimer', 'Helmut', '1980-01-01', '1', 2, 'MN', 'Giovanni'),
('1234567891234567', 'Tagliabo', 'Tommaso', '2005-04-22', '1', 1, 'PZ', 'tommaso');
