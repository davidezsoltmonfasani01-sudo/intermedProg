-- ================================================================
-- Database: IntermedProg
-- ================================================================

CREATE TABLE Stati (
    ID_Stato INT PRIMARY KEY,
    Stato VARCHAR(50) NOT NULL
);

CREATE TABLE Utenti (
    ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Cognome VARCHAR(50) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
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
    Messaggio TEXT NOT NULL
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
    Peso INT NOT NULL,
    fabbisogno_energetico INT NOT NULL,
    grassi INT NOT NULL,
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
    Risorsa VARCHAR(50) NOT NULL,
    ID_tipo INT NOT NULL,
    ID_stato INT NOT NULL,
    Data_ora DATETIME NOT NULL,
    ID_utente INT NOT NULL,
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

INSERT INTO Tipi_Notifiche (ID_tipo, Descrizione, Messaggio) VALUES
(1, 'Nuovo Referto', 'è stato compilato un nuovo referto'),
(2, 'Nuova Prenotazione', 'un paziente ha prenotato una nuova visita'),
(3, 'Annullamento Prenotazione', 'è stato annullata una prenotazione');

INSERT INTO Utenti (Cognome, Nome, Data_Nascita, username, Password, ID_stato, Ruolo) VALUES
('Alzheimer', 'Helmut', '1980-01-01', 'Giovanni', '1', 2, 'MN'),
('Tagliabo', 'Tommaso', '2005-04-22', 'tommaso', '1', 1, 'PZ');