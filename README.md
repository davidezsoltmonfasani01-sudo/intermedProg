Diagramma Navigazione
(https://drive.google.com/file/d/1U-FWnjdfrfJFzupBRbnUzSBOBJXWlecL/view?usp=sharing)


# bozza ER
* Scheda Anagrafica: ID, Username, Password, Ruolo (DS, MN, KC, PZ), Cognome, Nome, Codice Fiscale, Data Nascita, Stato Account (Inoperativo, Attivo, Sospeso).
* Schede professionali: ID, descrizione, ... (boh)

* Visita: ID, Data Visita, Data fine, Diagnosi, Obiettivi, Altezza, Peso Visita, Circonferenza Vita, Calorie Prescritte, Carboidrati Prescritti, Proteine Prescritte, Grassi Prescritti, Idrazione Prescritta.
> Non sappiamo se mettere o meno data inzio che puo' non coincidere con data visita
* Pasto prescritto: ID, Tipologia (Colazione, Pranzo, Cena, Fuori Pasto), Energia, Proteine, Lipidi, Glucidi, liquidi
* Prenotazione: ID, Data Prenotazione , Stato (Attiva, Conclusa). 
* Pagina Diario: ID, Data Pagina (riferimento), Data Compilazione , Peso Mattutino.
* Pasto: ID, Tipo Pasto (Colazione, Pranzo, Cena, Fuori Pasto), Quantità (g).
* Porzione: ID, quantità 
> come li conteggiamo i liquidi?
* Alimento: ID, Codice Alimento, Alimento, Energia, Proteine, Lipidi, Glucidi, liquido (si no).
* Annotazione: ID, Testo, Data Inserimento .
* Storico Assegnazione KC: ID, Data Sostituzione, Motivazione.
* ?Notifica