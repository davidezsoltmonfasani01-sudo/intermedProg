create table Utente (
  CF CHAR(16) PRIMARY KEY,
  Cognome VARCHAR(50) NOT NULL,
  Nome VARCHAR(50) NOT NULL,
  Data_Nascita DATE NOT NULL,
  Password VARCHAR(255) NOT NULL,
  Stato INT NOT NULL,
  Ruolo VARCHAR(50) NOT NULL,
  FOREIGN KEY (Stato) REFERENCES Stato(ID_Stato)
);


create table Stato (
    ID_Stato INT PRIMARY KEY,
    Stato VARCHAR(50) NOT NULL
);

create table Scheda_Professionale (
    CF_personale CHAR(16) PRIMARY KEY,
    descrizione TEXT NOT NULL,
    data_certificazione DATE NOT NULL,
    numero_albo INT NOT NULL
);

create table Prenotazione (
    ID_prenotazione INT PRIMARY KEY,
    CF_pz CHAR(16) NOT NULL,
    CF_md CHAR(16) NOT NULL,
    Data_prenotazione DATETIME NOT NULL,
    Data_visita DATETIME NOT NULL,
    Stato INT NOT NULL,
    FOREIGN KEY (Stato) REFERENCES Stato(ID_Stato)
);

create table Visita (
    ID_visita INT PRIMARY KEY,
    Data_visita DATETIME NOT NULL,
    Data_fine DATETIME NOT NULL,
    ID_prenotazione INT NOT NULL,
    Stato INT NOT NULL,
    Altezza INT NOT NULL,
    Peso INT NOT NULL,
    fabbisogno_energetico INT NOT NULL,
    grassi INT NOT NULL,
    note TEXT NOT NULL,
    FOREIGN KEY (ID_prenotazione) REFERENCES Prenotazione(ID_prenotazione),
    FOREIGN KEY (Stato) REFERENCES Stato(ID_Stato)
);

create table Pagina_Diario (
    ID_pagina INT PRIMARY KEY,
    CF_pz CHAR(16) NOT NULL,
    ID_visita INT NOT NULL,
    Data_pagina DATETIME NOT NULL,
    Data_compilazione DATETIME NOT NULL,
    Peso_giornaliero INT NOT NULL,
    FOREIGN KEY (ID_visita) REFERENCES Visita(ID_visita)
);

create table Porzione (
    ID_porzione INT PRIMARY KEY,
    Tipo_pasto VARCHAR(50) NOT NULL,
    Alimento VARCHAR(50) NOT NULL,
    Quantita INT NOT NULL
);

create table Alimento (
    ID_alimento INT PRIMARY KEY,
    Alimento VARCHAR(50) NOT NULL,
    Energia INT NOT NULL,
    Proteine INT NOT NULL,
    Glucidi INT NOT NULL,
    Liquido INT NOT NULL,
    FOREIGN KEY (Alimento) REFERENCES Porzione(Alimento)
);

create table Annotazione_Diario (
    ID_annotazione INT PRIMARY KEY,
    ID_pagina INT NOT NULL,
    Data_ultima_modifica DATETIME NOT NULL,
    Testo TEXT NOT NULL,
    CF char(16) NOT NULL,
    FOREIGN KEY (ID_pagina) REFERENCES Pagina_Diario(ID_pagina),
    FOREIGN KEY (CF) REFERENCES Utente(CF)
);

create table Tipo_Notifica (
    ID_tipo INT PRIMARY KEY,
    Descrizione VARCHAR(50) NOT NULL,
    Messaggio VARCHAR(255) NOT NULL
);

create table Notifica (
    ID_notifica INT PRIMARY KEY,
    ID_risorsa INT NOT NULL,
    Risorsa VARCHAR(50) NOT NULL,
    ID_tipo INT NOT NULL,
    Stato INT NOT NULL,
    FOREIGN KEY (ID_tipo) REFERENCES Tipo_Notifica(ID_tipo),
    FOREIGN KEY (Stato) REFERENCES Stato(ID_Stato)
);

create table Associazione_KC_PZ (
    ID_associazione INT PRIMARY KEY,
    CF_pz CHAR(16) NOT NULL,
    CF_kc CHAR(16) NOT NULL,
    Data_inizio DATETIME NOT NULL,
    Data_fine DATETIME NOT NULL,
    Stato INT NOT NULL,
    Motivazione VARCHAR(255) NOT NULL,
    FOREIGN KEY (Stato) REFERENCES Stato(ID_Stato)
);
