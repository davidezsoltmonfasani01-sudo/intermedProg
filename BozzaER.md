Diagramma Navigazione
(https://drive.google.com/file/d/1U-FWnjdfrfJFzupBRbnUzSBOBJXWlecL/view?usp=sharing)


# Bozza ER 
## Entità
* Scheda Anagrafica ID, Cognome, Nome, Codice Fiscale, Data Nascita
* Profilo : ID, Username, Password, Stato Account (Inoperativo, Attivo, Sospeso).
* Ruolo: ID (MN,DS,PZ,KC), nome (medico nutrizionista, paziente, ...)
* Schede professionali: ID, descrizione, Data_Conseguimento titolo, ....
* Prenotazione ID, Data Prenotazione, Data Visita,Stato (Confermata/In approvazione/Annullata/Rifiutata/Conclusa), Note
* Visita: ID, Data Visita, Data fine, Altezza, Peso Visita, Circonferenza Vita,Anamnesi Prossima, Anamnesi Alimentare, VALUTAZIONE ESAMI RECENTI, Diagnosi, Obiettivi,Metabolismo Basale stimato (MB), Fabbisogno Energetico Totale (TDEE), Apporto Calorico Prescritto, Carboidrati Prescritti, Proteine Prescritte, Grassi Prescritti, Idrazione Prescritta,Schema Alimentare, %Colazione %Pranzo %Cena, Note PRESCRIZIONE DIETETICA,
>Dobbiamo capire come rendere i dati autocoerenti e quali mettere, ad esempio i macro nutrienti che fanno la % del fabbisogno calorico totale, sarebbe ridondante mettere il peso dei macronutrienti e la % calorica, ma allo stesso tempo i totali dell'energia totale deve combaciare, inoltre se va stuttorata nel modo dell'allegato 1 vanno inseriti tot text per ogni sotto area tipo sotto anamnesi c'è sia Anamnesi Prossima: e Anamnesi alimentare , c'è da fare un altra entità giusto per ordine, c'è da vedere se inserire anche obbiettivo e diagnosi così o se lasciarle direttamente nella tambella essendo che ci devono essere per forza, mentre altre no
> Non sappiamo se mettere o meno data inzio che puo' non coincidere con data visita  questa tabella riguarda i referti
>c'è da vedere se magari è meglio separare visite e referti, anche se la relazione sarebbe 1 a 1.

>Quando MN compila un nuovo Referto Dietologico per PZ anche questo fa pensare che un medico possa fare un referto senza visita ma non ha senso 


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
* Tipo notifica ID, tipo (nuova annotazione, modifica annotazione, cancellazione, nuovo referto)
---
###  Tabbelle da Relazioni 
* Associazione MN_PZ ID, ID_MN, ID_PZ, Data_Inizio, Data_fine, Note
* Associazione KC_PZ ID, ID_KC, ID_PZ, Data inizio, Data Sostituzione, Motivazione.
>la associazione MN/KC alla  scheda professionale la si fa con una chiave esterna, (un campo nullable ?) o una tabella esterna? 
## Relazioni Modello ER

### Area Personale, Ruoli, Associazioni Professionali e Prenotazioni
* Profilo (1,1) AVERE (1,N) Scheda Anagrafica
>[NOTA]: ho dei dubbi riguardo alla cardinalità inferiore se far far completare la scheda anagrafica nel mentre si crea il profilo o meno 
>se la scheda si completa in un secondo momento mettiamo 0 al posto che 1
* Profilo (1,1) AVERE (0,N) Ruolo 
>[NOTA]: se la stessa persona fisica deve entrare nel sistema con un ruolo diverso, avrà un altro account 
* Profilo (MN) (0,N) — COMPILARE — (1,1) Scheda Professionale
* Profilo (KC) (0,N) — COMPILARE — (1,1) Scheda Professionale
>[NOTA]: È da vedere se ha senso associare la Scheda Professionale al profilo con il determinato ruolo, o se alla persona in se (scheda anagrafica)
* Profilo (PZ) (0,N) — EFFETTUARE — (1,1) Prenotazione

* Profilo (DS) (0,N) — GESTIRE — (0,N) Prenotazione
* Profilo (MN) (0,N) — GESTIRE — (0,N) Prenotazione
> [Nota]: Per la gestione degli stati, ha senso usare l'attributo "Stato" direttamente dentro l'entità Prenotazione. DS e MN modificano semplicemente quel campo senza bisogno di tabelle esterne.

* Profilo (PZ) (0,N) — ASSOCIAZIONE MN_PZ — (0,N) Profilo (MN)

> [Attributi della relazione]: ID, Data_Inizio, Data_fine, Note
* Profilo (PZ) (0,N) — ASSOCIAZIONE KC_PZ — (0,N) Profilo (KC)

> [Attributi della relazione]: ID Data inizio, Data_fine, Motivazione.

### Area Visite e Referti
* Prenotazione (0,1) — PORTARE — (1,1) Visita

* Profilo (PZ) (0,N) — EFFETTUARE — (1,1) Visita 
* Profilo (MN) (0,N) — EFFETTUARE — (1,1) Visita 

### Area Diario e Pasti
* Profilo (PZ) (0,N) — POSSEDERE — (1,1) Pagina Diario

* Pagina Diario (0,N) — RIFERIRE — (1,1) Visita/Referto

* Pagina Diario (4,4) — AVERE — (1,1) Pasto 
> [Nota]: I 4 pasti li generiamo sempre nel database al momento della creazione della pagina del diario, i dati all'inizio saranno tutti nulli (c'è solo ora).

* Pasto (0,N) — COMPORRE — (1,1) Porzione
* Alimento (0,N) — APPARTENERE — (1,1) Porzione


### Area Annotazioni e Chat
* Annotazione (1,1) — SCRIVERE — (0,N) Profilo (PZ)
* Annotazione (1,1) — SCRIVERE — (0,N) Profilo (KC)

* Annotazione (1,1) — RIFERIRE — (0,N) Pagina Diario 
> [Nota]: Conviene lasciarla riferita alla pagina in generale e non al singolo pasto, così è più semplice.

### Area Notifiche
* Notifica (1,1) — AVERE — (0,N) Profilo

* Notifica (1,1) - AVERE - (0,N) Tipo Notifica

* Notifica (0,1) — RIFERIRE — (2,2) Visita/Referto 

* Notifica (0,1) — RIFERIRE — (1,N) Annotazione
>ok capo
>rocks

>gdfasfsfsad