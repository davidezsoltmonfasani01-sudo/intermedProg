Diagramma Navigazione
(https://drive.google.com/file/d/1U-FWnjdfrfJFzupBRbnUzSBOBJXWlecL/view?usp=sharing)


# Bozza ER 
## Entità
* Scheda Anagrafica: ID, Username, Password, Ruolo (DS, MN, KC, PZ), Cognome, Nome, Codice Fiscale, Data Nascita, Stato Account (Inoperativo, Attivo, Sospeso).
* Schede professionali: ID, descrizione, ... (boh)
* Prenotazione ID, Data Prenotazione, Data Visita,Stato (Confermata/In approvazione/Annullata/Rifiutata), Note
* Visita: ID, Data Visita, Data fine, Altezza, Peso Visita, Circonferenza Vita,Anamnesi Prossima, Anamnesi Alimentare, VALUTAZIONE ESAMI RECENTI, Diagnosi, Obiettivi,Metabolismo Basale stimato (MB), Fabbisogno Energetico Totale (TDEE), Apporto Calorico Prescritto, Carboidrati Prescritti, Proteine Prescritte, Grassi Prescritti, Idrazione Prescritta,Schema Alimentare, %Colazione %Pranzo %Cena, Note PRESCRIZIONE DIETETICA,
>Dobbiamo capire come rendere i dati autocoerenti e quali mettere, ad esempio i macro nutrienti che fanno la % del fabbisogno calorico totale, sarebbe ridondante mettere il peso dei macronutrienti e la % calorica, ma allo stesso tempo i totali dell'energia totale deve combaciare, inoltre se va stuttorata nel modo dell'allegato 1 vanno inseriti tot text per ogni sotto area tipo sotto anamnesi c'è sia Anamnesi Prossima: e Anamnesi alimentare , c'è da fare un altra entità giusto per ordine 
> Non sappiamo se mettere o meno data inzio che puo' non coincidere con data visita  questa tabella riguarda i referti
>c'è da vedere se magari è meglio separare visite e referti, anche se la relazione sarebbe 1 a 1.
>Quando MN compila un nuovo Referto Dietologico per PZ anche questo fa pensare che un medico possa fare un referto senza visita ma non ha senso 
>Probabilmente c'è da vedere se inserire i dati tipo Anamnesi Alimentare etc come entità, collegate al referto, ognuna con le sue categorie specifiche, c'è da vedere se inserire anche obbiettivo e diagnosi così o se lasciarle direttamente nella tambella essendo che ci devono essere per forza, mentre altre no
~~Pasto prescritto: ID, Tipologia (Colazione, Pranzo, Cena, Fuori Pasto), Energia, Proteine, Lipidi, Glucidi, liquidi~~ 
>Cancellato in quanto deve essere prensente nell'entità visita/referto

* Prenotazione: ID, Data Prenotazione , Stato (Attiva, Conclusa). 
* Pagina Diario: ID, Data Pagina (riferimento), Data Compilazione , Peso.
* Pasto: ID, Tipo Pasto (Colazione, Pranzo, Cena, Fuori Pasto) 
> PZ legge le Annotazioni di KC ed in
>caso di necessita’ puo’ fare seguito con altre Annotazioni, creando con il KC un thread associato
>alla pagina del Diario Alimentare. ecco qui che cosa intende ? una pagina di chat o solo annotazioni associate? 
* Porzione: ID, quantità 
> come li conteggiamo i liquidi?
* Alimento: ID, Codice Alimento, Alimento, Energia, Proteine, Lipidi, Glucidi, liquido (si no).
* Annotazione: ID, Testo, Data Inserimento.
* Storico Assegnazione KC: ID, Data inizio, Data Sostituzione, Motivazione.
* Notifica: ID, messaggio, path risorsa (Schede, Pagine diario, ecc), Stato (visualizzata si,no attiva/disattivata)


* Referto ID, 