-- ================================================================
-- Database: IntermedProg
-- ================================================================

CREATE TABLE Stati (
    ID_Stato INT PRIMARY KEY,
    Stato VARCHAR(50) NOT NULL
);

CREATE TABLE Utenti (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    CF VARCHAR(16) NOT NULL ,
    Cognome VARCHAR(50) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Sesso CHAR NOT NULL,
    Data_Nascita DATE NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    ID_stato INT NOT NULL,
    Ruolo VARCHAR(50) NOT NULL,
    FOREIGN KEY (ID_stato) REFERENCES Stati(ID_Stato)
);

CREATE TABLE Schede_Professionali (
    ID INT PRIMARY KEY NOT NULL,
    ID_utente INT NOT NULL UNIQUE,
    descrizione TEXT NOT NULL,
    data_certificazione DATE NOT NULL,
    numero_albo INT NOT NULL,
    FOREIGN KEY (ID_utente) REFERENCES Utenti(ID)
);

CREATE TABLE Tipi_Notifiche (
    ID_tipo INT PRIMARY KEY,
    Descrizione VARCHAR(50) NOT NULL,
    Messaggio TEXT NOT NULL,
    Risorsa VARCHAR(50) NOT NULL,
    Pagina VARCHAR(50) NOT NULL
);

CREATE TABLE Prenotazioni (
    ID_prenotazione INT PRIMARY KEY,
    ID_pz INT NOT NULL,
    ID_mn INT NOT NULL,
    Data_prenotazione DATETIME NOT NULL,
    Data_visita DATETIME NOT NULL,
    ID_stato INT NOT NULL,
    FOREIGN KEY (ID_pz) REFERENCES Utenti(ID),
    FOREIGN KEY (ID_mn) REFERENCES Utenti(ID),
    FOREIGN KEY (ID_stato) REFERENCES Stati(ID_Stato)
);

CREATE TABLE Visite (
    ID_visita INT PRIMARY KEY,
    Data_visita DATETIME NOT NULL,
    Data_fine DATETIME,
    ID_prenotazione INT NOT NULL,
    ID_stato INT NOT NULL,
    Altezza INT NOT NULL,
    Peso DECIMAL(5,2) NOT NULL,
    Circonferenza_vita DECIMAL(5,2) NULL,
    Anamnesi_prossima TEXT NULL,
    Anamnesi_alimentare TEXT NULL,
    Valutazione_esami_recenti TEXT NULL,
    Diagnosi TEXT NULL,
    Obiettivi TEXT NULL,
    Metabolismo_basale_stimato INT NULL,
    Fabbisogno_energetico INT NOT NULL,
    Apporto_calorico INT NULL,
    Carboidrati INT NULL,
    Proteine INT NULL,
    Grassi INT NOT NULL,
    Idratazione DECIMAL(3,1) NULL,
    Schema_alimentare TEXT NULL,
    Percentuale_colazione DECIMAL(5,2) NULL,
    Percentuale_pranzo DECIMAL(5,2) NULL,
    Percentuale_cena DECIMAL(5,2) NULL,
    note TEXT NOT NULL,
    FOREIGN KEY (ID_prenotazione) REFERENCES Prenotazioni(ID_prenotazione),
    FOREIGN KEY (ID_stato) REFERENCES Stati(ID_Stato)
);

CREATE TABLE Pagine_Diario (
    ID_pagina INT PRIMARY KEY,
    ID_pz INT NOT NULL,
    ID_visita INT NOT NULL,
    Data_pagina DATETIME NOT NULL,
    Data_compilazione DATETIME  NULL,
    Peso_giornaliero INT  NULL,
    FOREIGN KEY (ID_pz) REFERENCES Utenti(ID),
    FOREIGN KEY (ID_visita) REFERENCES Visite(ID_visita)
);


CREATE TABLE Porzioni (
    ID_porzione INT PRIMARY KEY,
    ID_alimento INT NOT NULL,
    Tipo_pasto VARCHAR(50) NOT NULL,
    Quantita INT NOT NULL,
    FOREIGN KEY (ID_alimento) REFERENCES Alimenti(ID_alimento)
);

CREATE TABLE Annotazioni_Diario (
    ID_annotazione INT PRIMARY KEY,
    ID_pagina INT NOT NULL,
    Data_ultima_modifica DATETIME NOT NULL,
    Testo TEXT NOT NULL,
    ID_Scrittore INT NOT NULL,
    FOREIGN KEY (ID_pagina) REFERENCES Pagine_Diario(ID_pagina),
    FOREIGN KEY (ID_Scrittore) REFERENCES Utenti(ID)
);

CREATE TABLE Notifiche (
    ID_notifica INT PRIMARY KEY,
    ID_risorsa INT NOT NULL,
    ID_tipo INT NOT NULL,
    ID_stato INT NOT NULL,
    ID_utente INT NOT NULL,
    Data_ora DATETIME NOT NULL,
    FOREIGN KEY (ID_tipo) REFERENCES Tipi_Notifiche(ID_tipo),
    FOREIGN KEY (ID_stato) REFERENCES Stati(ID_Stato),
    FOREIGN KEY (ID_utente) REFERENCES Utenti(ID)
);

CREATE TABLE Associazioni_KC_PZ (
    ID_associazione INT PRIMARY KEY,
    ID_pz INT NOT NULL,
    ID_kc INT NOT NULL,
    Data_inizio DATETIME NOT NULL,
    Data_fine DATETIME,
    ID_stato INT NOT NULL,
    Motivazione TEXT NULL,
    FOREIGN KEY (ID_pz) REFERENCES Utenti(ID),
    FOREIGN KEY (ID_kc) REFERENCES Utenti(ID),
    FOREIGN KEY (ID_stato) REFERENCES Stati(ID_Stato)
);

-- ================================================================
-- Dati iniziali
-- ================================================================

INSERT INTO Stati (ID_Stato, Stato) VALUES
(1, 'Attesa'),
(2, 'Attivo'),
(10, 'visualizzata'),
(11, 'non visualizzata');

INSERT INTO Tipi_Notifiche (ID_tipo, Descrizione, Messaggio, Risorsa, Pagina) VALUES
(1, 'Nuovo referto', 'È stato compilato un nuovo referto.', 'Visite', 'v_referto.jsp'),
(2, 'Nuova prenotazione', 'Un paziente ha prenotato una nuova visita.', 'Prenotazioni', 'dettaglio_prenotazione.jsp'),
(3, 'Annullamento prenotazione', 'È stata annullata una prenotazione.', 'Prenotazioni', 'dettaglio_prenotazione.jsp');

INSERT INTO Utenti (ID, CF, Cognome, Nome, Data_Nascita, username, Password, ID_stato, Ruolo) VALUES
(1, 'ALZHLT80A01Z404K', 'Alzheimer', 'Helmut', '1980-01-01', 'giovanni', '1', 2, 'MN'),
(2, 'TGLTMS05D22S00S', 'Tagliabo', 'Tommaso', '2005-04-22', 'tommaso', '1', 1, 'PZ');

INSERT INTO Schede_Professionali (ID, ID_utente, descrizione, data_certificazione, numero_albo) VALUES
(1, 1, 'Medico nutrizionista, specializzato in educazione alimentare e massimo esperto nel rimuovere i filamenti neurovegetativi di Langerhans ', '2010-06-15', 12345);

INSERT INTO Associazioni_KC_PZ (ID_associazione, ID_pz, ID_kc, Data_inizio, Data_fine, ID_stato, Motivazione) VALUES
(1, 2, 1, '2025-01-10 09:00:00', NULL, 2, NULL);

INSERT INTO Prenotazioni (ID_prenotazione, ID_pz, ID_mn, Data_prenotazione, Data_visita, ID_stato) VALUES
(1, 2, 1, '2025-01-10 09:00:00', '2025-01-20 10:00:00', 2);

INSERT INTO Visite (ID_visita, Data_visita, Data_fine, ID_prenotazione, ID_stato, Altezza, Peso, fabbisogno_energetico, grassi, note) VALUES
(1, '2025-01-20 10:00:00', '2025-01-20 10:45:00', 1, 2, 178, 75, 2200, 70, 'Prima visita: definito un piano alimentare personalizzato.');

INSERT INTO Pagine_Diario (ID_pagina, ID_pz, ID_visita, Data_pagina, Data_compilazione, Peso_giornaliero) VALUES
(1, 2, 1, '2025-01-21 00:00:00', '2025-01-21 20:00:00', 74);

INSERT INTO Annotazioni_Diario (ID_annotazione, ID_pagina, Data_ultima_modifica, Testo, ID_Scrittore) VALUES
(1, 1, '2025-01-21 20:15:00', 'ho seguito il piano alimentare.', 2);

INSERT INTO Notifiche (ID_notifica, ID_risorsa, ID_tipo, ID_stato, ID_utente, Data_ora) VALUES
(1, 1, 2, 10, 1, '2025-01-10 09:00:00'),
(2, 1, 1, 11, 1, '2025-01-20 10:45:00');INSERT INTO Stati (ID_Stato, Stato) VALUES
(1, 'Attesa'),
(2, 'Attivo'),
(10, 'visualizzata'),
(11, 'non visualizzata');

INSERT INTO Tipi_Notifiche (ID_tipo, Descrizione, Messaggio, Risorsa, Pagina) VALUES
(1, 'Nuovo referto', 'È stato compilato un nuovo referto.', 'Visite', 'v_referto.jsp'),
(2, 'Nuova prenotazione', 'Un paziente ha prenotato una nuova visita.', 'Prenotazioni', 'dettaglio_prenotazione.jsp'),
(3, 'Annullamento prenotazione', 'È stata annullata una prenotazione.', 'Prenotazioni', 'dettaglio_prenotazione.jsp');

INSERT INTO Utenti (ID, CF, Cognome, Nome, Data_Nascita, username, Password, ID_stato, Ruolo) VALUES
(1, 'ALZHLT80A01Z404K', 'Alzheimer', 'Helmut', '1980-01-01', 'giovanni', '1', 2, 'MN'),
(2, 'TGLTMS05D22S00S', 'Tagliabo', 'Tommaso', '2005-04-22', 'tommaso', '1', 1, 'PZ');

INSERT INTO Schede_Professionali (ID, ID_utente, descrizione, data_certificazione, numero_albo) VALUES
(1, 1, 'Medico nutrizionista, specializzato in educazione alimentare e massimo esperto nel rimuovere i filamenti neurovegetativi di Langerhans ', '2010-06-15', 12345);

INSERT INTO Associazioni_KC_PZ (ID_associazione, ID_pz, ID_kc, Data_inizio, Data_fine, ID_stato, Motivazione) VALUES
(1, 2, 1, '2025-01-10 09:00:00', NULL, 2, NULL);

INSERT INTO Prenotazioni (ID_prenotazione, ID_pz, ID_mn, Data_prenotazione, Data_visita, ID_stato) VALUES
(1, 2, 1, '2025-01-10 09:00:00', '2025-01-20 10:00:00', 2);

INSERT INTO Visite (
    ID_visita, 
    Data_visita, 
    Data_fine, 
    ID_prenotazione, 
    ID_stato, 
    Altezza, 
    Peso, 
    Circonferenza_vita, 
    Anamnesi_prossima, 
    Anamnesi_alimentare, 
    Valutazione_esami_recenti, 
    Diagnosi, 
    Obiettivi, 
    Metabolismo_basale_stimato, 
    Fabbisogno_energetico, 
    Apporto_calorico, 
    Carboidrati, 
    Proteine, 
    Grassi, 
    Idratazione, 
    Schema_alimentare, 
    Percentuale_colazione, 
    Percentuale_pranzo, 
    Percentuale_cena, 
    note
) VALUES (
    1, 
    '2025-01-20 10:00:00', 
    '2025-01-20 10:45:00', 
    1, 
    2, 
    178, 
    75.00, 
    84.50, 
    'Nessuna patologia rilevante segnalata, buona qualità del sonno, attività fisica moderata (2 volte a settimana).', 
    'Abitudine a saltare la colazione, consumo frequente di carboidrati raffinati a pranzo e scarso apporto di verdure.', 
    'Esami ematochimici nella norma; glicemia a digiuno 88 mg/dL, colesterolo totale 185 mg/dL.', 
    'Soggetto normopeso (BMI 23.7) con lieve adiposità addominale e abitudini alimentari disordinate.', 
    'Ricomposizione corporea, regolarizzazione dei pasti e incremento della massa magra.', 
    1750, 
    2200, 
    2000, 
    240, 
    130, 
    70, 
    2.5, 
    'Dieta mediterranea bilanciata suddivisa in 3 pasti principali più 2 spuntini proteici.', 
    20.00, 
    40.00, 
    30.00, 
    'Prima visita: definito un piano alimentare personalizzato.'
);

INSERT INTO Pagine_Diario (ID_pagina, ID_pz, ID_visita, Data_pagina, Data_compilazione, Peso_giornaliero) VALUES
(1, 2, 1, '2025-01-21 00:00:00', '2025-01-21 20:00:00', 74);

INSERT INTO Annotazioni_Diario (ID_annotazione, ID_pagina, Data_ultima_modifica, Testo, ID_Scrittore) VALUES
(1, 1, '2025-01-21 20:15:00', 'ho seguito il piano alimentare.', 2);

INSERT INTO Notifiche (ID_notifica, ID_risorsa, ID_tipo, ID_stato, ID_utente, Data_ora) VALUES
(1, 1, 2, 10, 1, '2025-01-10 09:00:00'),
(2, 1, 1, 11, 1, '2025-01-20 10:45:00');