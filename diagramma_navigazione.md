# Diagramma di Navigazione Ottimizzato
# Pagine Presentazione
## 1. Autenticazione e Accessi (Comuni)
Pagine di ingresso e gestione della sessione per tutti gli utenti del sistema.
* **index.jsp / login.jsp**: Schermata di login globale (reindirizza alla dashboard corretta in base al ruolo).
* **registrazione.jsp**: Form di auto-registrazione per il Paziente, DS la usa per genere credenziali.
* **attesa-approvazione.jsp**: Schermata di blocco per i pazienti registrati ma non ancora abilitati dal DS.

## 2. Gestione Profili e Anagrafiche (Unificati)

### Area Modifica (Edit)
* **form-scheda-anagrafica.jsp**: Form per i dati personali del Paziente.
* **form-scheda-professionale.jsp**: Pagina Unica per MN e KC. Mostra un'area di testo precompilata con il messaggio di presentazione.

### Area Sola Lettura (Read-Only)
* **visualizza-anagrafica.jsp**: Scheda anagrafica del paziente (usata da PZ, ed accessibile in modo contestuale da MN e KC).
* **lista-collaboratori.jsp**: Pagina Unica usata dal Paziente per visualizzare le schede professionali del personale ed effettuare le scelte (filtra dinamicamente per ruolo KC o MN tramite parametri nell'URL, es: ?ruolo=KC).

## 3. Direzione Sanitaria (DS)
Pannello di controllo ad accesso esclusivo per la gestione del sistema e le metriche di business.
* **dashboard-ds.jsp**: Menu principale e hub di controllo del DS.
* **approvazione-pazienti.jsp**: Lista delle richieste di registrazione dei PZ (approva/rifiuta/sospende).
* **gestione-personale-ds.jsp**: Elenco dei medici e dei coach in servizio (permette la creazione, sospensione o cancellazione degli account).
* **statistiche-sistema.jsp**: Vista aggregata dei contatori richiesti (totale visite per MN, pagine diario per PZ, annotazioni per KC).
* **registro-sostituzioni.jsp**: Storico cronologico dei cambi di coach con le relative motivazioni scritte dai pazienti.

## 4. Area Prenotazioni e Visite
* **prenota-visita.jsp**: Form di prenotazione per il Paziente. Controlla che siano passati almeno 30 giorni dall'ultimo referto.
* **lista-prenotazioni.jsp**: Pagina Unica con filtri logici. 
  * Per il Paziente: mostra le sue richieste.
  * Per il Medico (MN): mostra l'elenco delle visite attive che lo coinvolgono.
* **dettaglio-prenotazione.jsp**: Schermata di gestione per accettare, rifiutare o annullare una prenotazione.

## 5. Referti Dietologici
* **compila-referto.jsp**: Form compilabile esclusivamente da MN durante una visita attiva (contiene i campi in rosso: diagnosi, obiettivi, parametri antropometrici e macronutrienti).
* **visualizza-referto.jsp**: Pagina in sola lettura del referto (accessibile da PZ, KC e da MN all'interno dello storico visite).

## 6. Diario Alimentare
Il nucleo interattivo dell'applicazione, basato sulla gestione rigida del tempo simulato.
* **diario-calendario.jsp**: Interfaccia a calendario per selezionare la giornata del diario (impedisce l'accesso alle date antecedenti il primo referto).
* **diario-giornata.jsp**: La tabella vera e propria del diario.
  * Mostra il peso e calcola automaticamente il BMI estraendo l'altezza dall'ultimo referto.
  * Calcola i totali parziali (righe gialle) e stampa sotto le prescrizioni del referto (righe verdi).
  * È modificabile per il Paziente; è in sola lettura per KC e MN.
  * Contiene il link/pulsante contestuale "Diet" per aprire il referto associato.
* **ricerca-alimento.jsp**: Schermata di popup o sezione integrata per cercare gli alimenti nella Tabella Alimenti e indicare i grammi consumati.

## 7. Notifiche e Annotazioni (Thread)
* **lista-notifiche.jsp**: Hub dei messaggi ricevuti. Cliccando su un elemento si viene reindirizzati alla risorsa contestuale disattivando la notifica.
  * Per PZ: notifiche di nuovi referti o annotazioni del coach.
  * Per KC: notifiche di diari compilati, annotazioni del paziente o assegnazione di un nuovo paziente.
* **thread-annotazioni.jsp**: Area di discussione collegata alla specifica giornata del diario alimentare per permettere lo scambio di messaggi motivazionali e chiarimenti tra KC e PZ.

## 8. Utility ed Errori
* **errore-validazione.jsp**: Pagina di atterraggio generica quando falliscono i controlli di sequenza temporale (es: data diario antecedente al referto o referto nel passato della prenotazione).

# Pagine Action

## 1. Autenticazione e Accessi (Comuni)
Pagine di ingresso e gestione della sessione per tutti gli utenti del sistema.
* **index.jsp / login.jsp**: Schermata di login globale (reindirizza alla dashboard corretta in base al ruolo).
* **registrazione.jsp**: Form di auto-registrazione per il Paziente, DS la usa per genere credenziali.
* **attesa-approvazione.jsp**: Schermata di blocco per i pazienti registrati ma non ancora abilitati dal DS.

## 2. Gestione Profili e Anagrafiche (Unificati)

### Area Modifica (Edit)
* **form-scheda-anagrafica.jsp**: Form per i dati personali del Paziente.
* **form-scheda-professionale.jsp**: Pagina Unica per MN e KC. Mostra un'area di testo precompilata con il messaggio di presentazione.

### Area Sola Lettura (Read-Only)
* **visualizza-anagrafica.jsp**: Scheda anagrafica del paziente (usata da PZ, ed accessibile in modo contestuale da MN e KC).
* **lista-collaboratori.jsp**: Pagina Unica usata dal Paziente per visualizzare le schede professionali del personale ed effettuare le scelte (filtra dinamicamente per ruolo KC o MN tramite parametri nell'URL, es: ?ruolo=KC).

## 3. Direzione Sanitaria (DS)
Pannello di controllo ad accesso esclusivo per la gestione del sistema e le metriche di business.
* **dashboard-ds.jsp**: Menu principale e hub di controllo del DS.
* **approvazione-pazienti.jsp**: Lista delle richieste di registrazione dei PZ (approva/rifiuta/sospende).
* **gestione-personale-ds.jsp**: Elenco dei medici e dei coach in servizio (permette la creazione, sospensione o cancellazione degli account).
* **statistiche-sistema.jsp**: Vista aggregata dei contatori richiesti (totale visite per MN, pagine diario per PZ, annotazioni per KC).
* **registro-sostituzioni.jsp**: Storico cronologico dei cambi di coach con le relative motivazioni scritte dai pazienti.

## 4. Area Prenotazioni e Visite
* **prenota-visita.jsp**: Form di prenotazione per il Paziente. Controlla che siano passati almeno 30 giorni dall'ultimo referto.
* **lista-prenotazioni.jsp**: Pagina Unica con filtri logici. 
  * Per il Paziente: mostra le sue richieste.
  * Per il Medico (MN): mostra l'elenco delle visite attive che lo coinvolgono.
* **dettaglio-prenotazione.jsp**: Schermata di gestione per accettare, rifiutare o annullare una prenotazione.

## 5. Referti Dietologici
* **compila-referto.jsp**: Form compilabile esclusivamente da MN durante una visita attiva (contiene i campi in rosso: diagnosi, obiettivi, parametri antropometrici e macronutrienti).
* **visualizza-referto.jsp**: Pagina in sola lettura del referto (accessibile da PZ, KC e da MN all'interno dello storico visite).

## 6. Diario Alimentare
Il nucleo interattivo dell'applicazione, basato sulla gestione rigida del tempo simulato.
* **diario-calendario.jsp**: Interfaccia a calendario per selezionare la giornata del diario (impedisce l'accesso alle date antecedenti il primo referto).
* **diario-giornata.jsp**: La tabella vera e propria del diario.
  * Mostra il peso e calcola automaticamente il BMI estraendo l'altezza dall'ultimo referto.
  * Calcola i totali parziali (righe gialle) e stampa sotto le prescrizioni del referto (righe verdi).
  * È modificabile per il Paziente; è in sola lettura per KC e MN.
  * Contiene il link/pulsante contestuale "Diet" per aprire il referto associato.
* **ricerca-alimento.jsp**: Schermata di popup o sezione integrata per cercare gli alimenti nella Tabella Alimenti e indicare i grammi consumati.

## 7. Notifiche e Annotazioni (Thread)
* **lista-notifiche.jsp**: Hub dei messaggi ricevuti. Cliccando su un elemento si viene reindirizzati alla risorsa contestuale disattivando la notifica.
  * Per PZ: notifiche di nuovi referti o annotazioni del coach.
  * Per KC: notifiche di diari compilati, annotazioni del paziente o assegnazione di un nuovo paziente.
* **thread-annotazioni.jsp**: Area di discussione collegata alla specifica giornata del diario alimentare per permettere lo scambio di messaggi motivazionali e chiarimenti tra KC e PZ.

## 8. Utility ed Errori
* **errore-validazione.jsp**: Pagina di atterraggio generica quando falliscono i controlli di sequenza temporale (es: data diario antecedente al referto o referto nel passato della prenotazione).
