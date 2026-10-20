Diagramma Navigazione
(https://drive.google.com/file/d/1U-FWnjdfrfJFzupBRbnUzSBOBJXWlecL/view?usp=sharing)


# Bozza ER 
## Entità
* Persona (Scheda Anagrafica): ID, Username, Password, Ruolo (DS, MN, KC, PZ), Cognome, Nome, Codice Fiscale, Data Nascita, Stato Account (Inoperativo, Attivo, Sospeso).
* Schede professionali: ID, descrizione, ... (boh)
* Prenotazione ID, Data Prenotazione, Data Visita,Stato (Confermata/In approvazione/Annullata/Rifiutata/Conclusa), Note
* Visita: ID, Data Visita, Data fine, Altezza, Peso Visita, Circonferenza Vita,Anamnesi Prossima, Anamnesi Alimentare, VALUTAZIONE ESAMI RECENTI, Diagnosi, Obiettivi,Metabolismo Basale stimato (MB), Fabbisogno Energetico Totale (TDEE), Apporto Calorico Prescritto, Carboidrati Prescritti, Proteine Prescritte, Grassi Prescritti, Idrazione Prescritta,Schema Alimentare, %Colazione %Pranzo %Cena, Note PRESCRIZIONE DIETETICA,
>Dobbiamo capire come rendere i dati autocoerenti e quali mettere, ad esempio i macro nutrienti che fanno la % del fabbisogno calorico totale, sarebbe ridondante mettere il peso dei macronutrienti e la % calorica, ma allo stesso tempo i totali dell'energia totale deve combaciare, inoltre se va stuttorata nel modo dell'allegato 1 vanno inseriti tot text per ogni sotto area tipo sotto anamnesi c'è sia Anamnesi Prossima: e Anamnesi alimentare , c'è da fare un altra entità giusto per ordine, c'è da vedere se inserire anche obbiettivo e diagnosi così o se lasciarle direttamente nella tambella essendo che ci devono essere per forza, mentre altre no
> Non sappiamo se mettere o meno data inzio che puo' non coincidere con data visita  questa tabella riguarda i referti
>c'è da vedere se magari è meglio separare visite e referti, anche se la relazione sarebbe 1 a 1.

>Quando MN compila un nuovo Referto Dietologico per PZ anche questo fa pensare che un medico possa fare un referto senza visita ma non ha senso 

~~Pasto prescritto: ID, Tipologia (Colazione, Pranzo, Cena, Fuori Pasto), Energia, Proteine, Lipidi, Glucidi, liquidi~~ 
>Cancellato in quanto deve essere prensente nell'entità visita/referto
 
* Pagina Diario: ID, Data Pagina (riferimento), Data Compilazione , Peso.
* Pasto: ID, Tipo Pasto (Colazione, Pranzo, Cena, Fuori Pasto), Ora
> PZ legge le Annotazioni di KC ed in
>caso di necessita’ puo’ fare seguito con altre Annotazioni, creando con il KC un thread associato
>alla pagina del Diario Alimentare. ecco qui che cosa intende ? una pagina di chat o solo annotazioni associate? 
* Porzione: ID, quantità 
> come li conteggiamo i liquidi?
* Alimento: ID, Codice Alimento, Alimento, Energia, Proteine, Lipidi, Glucidi, liquido (si no).
* Annotazione: ID, Testo, Data Inserimento.
* Notifica: ID, messaggio, path risorsa (Schede, Pagine diario, ecc), Stato (visualizzata si,no attiva/disattivata)

###  Tabbelle da Relazioni 
* Associazione MN_PZ ID, ID_MN, ID_PZ, Data_Inizio, Data_fine, Note
* Associazione KC_PZ ID, ID_KC, ID_PZ, Data inizio, Data Sostituzione, Motivazione.
>la associazione MN/KC alla  scheda professionale la si fa con una chiave esterna, (un campo nullable ?) o una tabella esterna? 
## Relazioni
* Persona (MN/KC) (0,N) — COMPILARE — (1,1) Scheda Professionale
* Persona (PZ) (1,1) — EFFETTUARE — (0,N) Prenotazione:
* Persona (DS/MN) (0,N) — GESTIRE — (0,N) Prenotazione:
> Può aver senso la gesione degli stati o si modifica e basta ? 
* Prenotazione (0,1) — PORTARE — (1,1) Visita
* Pagina Diario (1,1)-RIFERIRE-(1.N) Visita/Referto
* Pagina Diario (4,4)-AVERE-(1.1) Pasto 
* Persona (PZ/MN) (0,N) — EFFETTUARE — (1,1) Visita 
* Persona (PZ) (0,N) — POSSEDERE — (1,1) Pagina Diario:
>I 4 pasti li generiamo sempre nel database al momento della creazione della pagina del diario, i dati all'inizio saranno tutti nulli (c'è solo ora)
* Pasto (0,N)-COMPORRE-(0,M) Alimento
* Notifica (1,1) <-Avere-> (0,N) Persona
* Notifica (0,1)<-RIFERIRE->(2,2) Visita/Referto (uno al PZ 1 al KC)
* Notifica (0,1)<-RIFERIRE->(1,N) Annotazione (se avviene una modifica viene inviata una nuova notifica)

>Da completare
