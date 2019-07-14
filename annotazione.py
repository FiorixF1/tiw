"""
Script Python per la simulazione dell'algoritmo di scelta delle immagini.
Lo scopo di questo programma è verificare se l'algoritmo di scelta delle immagini che vogliamo
implementare nel progetto di Tiw permette di realizzare l'obiettivo che ogni immagine venga
votata/annotata il numero minimo di volte richiesto, simulando anche i casi in cui più utenti fanno
una richiesta al server in contemporanea oppure alcuni di loro chiudono il browser senza 
inviare il voto/l'annotazione dell'immagine corrente.
"""

import threading
import time
import random
import collections

NUMBER_OF_IMAGES = 100              # numero di immagini della campagna
NUMBER_OF_USERS = 100               # numero di lavoratori
LEAST_NUMBER_OF_ANNOTATIONS = 25    # parametro M
EXECUTION_TIME = 200                # tempo d'esecuzione del programma in secondi
MINIMUM_TIME_BEFORE_REQUEST = 2     # tempo minimo perché un utente faccia un'annotazione
MAXIMUM_TIME_BEFORE_REQUEST = 4     # tempo massimo perché un utente faccia un'annotazione
WAITING_TIME = 3            # tempo di pausa quando l'utente non ha più immagini
REQUEST_TIMEOUT = 7         # tempo oltre il quale un'annotazione può considerarsi abbandonata
                            # nell'implementazione reale questo parametro DEVE ASSOLUTAMENTE VALERE ALMENO QUANTO LA DURATA DELLA SESSIONE
                            # altrimenti possono succedere cose assurde
                            # capire questa cosa mi è costato ore di debugging
PROBABILITY_OF_SUCCESS = 85         # probabilità che un'immagine riceva un'annotazione dall'utente che l'ha richiesta
START_TIME = time.time()            # momento di inizio del programma

serverLock = threading.Lock()       # necessario per garantire l'accesso esclusivo al server, altrimenti si spacca tutto
writerLock = threading.Lock()       # necessario per l'accesso esclusivo alla print(), altrimenti su computer lenti l'output si rompe malamente

def printLock(*arg):
  writerLock.acquire(True)
  arg = [str(i) for i in arg]
  print(" ".join(arg))
  writerLock.release()

# ---------------------------------------- #

"""
Classe che rappresenta un'immagine. E' identificata da un numero e contiene due contatori:
uno è il numero di annotazioni ricevute e l'altro è il numero di volte che è stata richiesta
quell'immagine. Quest'ultima variabile viene usata per la scelta delle immagini da consegnare
e rappresenta un valore di richieste fittizio (può essere decrementato).
L'immagine contiene anche una lista degli utenti che hanno fatto le annotazioni.
Diamo per scontato che le immagini appartengono ad una sola campagna, a cui tutti gli utenti
stanno contribuendo. Lo scopo dell'algoritmo di scelta è fare in modo che annotation_counter
sia il più possibile uguale (se non esattamente uguale) al parametro M della campagna.
"""
class Image:
  def __init__(self, id):
    self.id = id
    self.annotation_counter = 0
    self.request_counter = 0
    self.workers_who_annotated_it = []

  def add_request(self):
    self.request_counter += 1

  def remove_request(self):
    self.request_counter -= 1

  def add_annotation(self, user_id):
    self.annotation_counter += 1
    self.workers_who_annotated_it.append(user_id)

# ---------------------------------------- #

"""
Rappresenta il server che riceve richieste. Contiene un riferimento alle immagini e le richieste
che si possono fare sono l'aggiunta di una annotazione e la ricezione della prossima immagine.
La richiesta della prossima immagine rappresenta il cuore dell'algoritmo che vogliamo implementare.
EDIT: è stato trovato l'algoritmo perfetto. Esso prevede l'aggiunta di una lista che memorizza le richieste
fatte (nella realtà sarà una tabella del db). Ogni richiesta contiene l'immagine, l'utente e il timestamp.
Quest'ultimo viene usato per capire se un'annotazione è stata abbandonata o meno. Ogni volta che un utente
fa una richiesta, si controlla in questa lista se una richiesta precedente è "scaduta" (cioè è passata una certa
quantità di tempo senza ricevere l'annotazione) e nel caso si decrementa il contatore delle richieste dell'immagine
associata e si cancella la richiesta dalla lista. Nauralmente poi, prima di consegnare l'immagine all'utente,
la nuova richiesta viene registrata nella lista. La durata del timeout nell'implementazione reale DEVE essere
maggiore o uguale alla durata della sessione web. Inoltre un'ottimizzazione prevede che quando l'utente fa una richiesta
di una nuova immagine, il server cancella subito le richieste precedenti fatte dallo stesso utente, perché
si sa già che questo utente non potrà fornire l'annotazione delle immagini precedenti. Stessa cosa quando arriva
una richiesta di logout, che invalida la sessione.
"""
class Server:
  def __init__(self):
    self.images = []
    self.pending_annotations = []  # tabella nel db

  def get_image(self, user):
    serverLock.acquire(True)
    
    # --- CORE DELL'ALGORITMO: deve ritornare una Image --- #

    # Prima di scegliere l'immagine, controllo le richieste pendenti
    # Se sono presenti richieste "scadute" decremento il contatore di richieste e le elimino
    # ATTENZIONE: QUESTO IN JAVA LO FAREMO ANCHE AL LOGOUT PER OTTIMIZZAZIONE
    current_time = time.time()
    for line in self.pending_annotations:
      if current_time - line.timestamp > REQUEST_TIMEOUT:
        line.image.remove_request()
    self.pending_annotations = [i for i in self.pending_annotations if current_time - i.timestamp <= REQUEST_TIMEOUT]

    # Inoltre, se l'utente corrente ha altre richieste pendenti in attivo, posso già cancellarle prima del timeout
    # perché è impossibile che l'utente possa inviarmi annotazioni delle immagini precedenti
    # Questa operazione evita che persistano per troppo tempo numerose richieste di un utente su una stessa immagine
    # che poi alla fine ha annotato
    for line in self.pending_annotations:
      if line.user == user:
        line.image.remove_request()
    self.pending_annotations = [i for i in self.pending_annotations if i.user != user]
    
    # Cerco le immagini che hanno un numero di RICHIESTE inferiore a M (sì, richieste e non annotazioni!)
    not_enough_requests = [x for x in self.images if x.request_counter < LEAST_NUMBER_OF_ANNOTATIONS]

    # Tra queste cerco le immagini non annotate dall'utente attuale
    not_annotated_by_user = [x for x in not_enough_requests if user.id not in x.workers_who_annotated_it]

    # Cerco le immagini con meno richieste tra quelle rimaste: il risultato sarà l'insieme di immagini candidate
    least_number_of_requests = float("+inf")
    for x in not_annotated_by_user:
      if x.request_counter < least_number_of_requests:
        least_number_of_requests = x.request_counter
    candidates = [x for x in not_annotated_by_user if x.request_counter == least_number_of_requests]

    # Se non ci sono candidati, abbiamo finito
    if len(candidates) == 0:
      serverLock.release()
      return None
    # Altrimenti tra i candidati rimasti ne scegliamo uno a caso
    resulting_image = random.choice(candidates)

    # Registriamo la richiesta
    this_request = collections.namedtuple("Request", ["image", "user", "timestamp"])
    this_request.image = resulting_image
    this_request.user = user
    this_request.timestamp = time.time()
    self.pending_annotations.append(this_request)

    resulting_image.add_request()

    # --- FINE ALGORITMO --- #

    serverLock.release()
    return resulting_image

  def annotate(self, image, user):
    serverLock.acquire(True)
    
    # Caso limite estremamente subdolo ma che nasconde disastrosi bug se non gestito:
    # se un utente invia l'annotazione dopo che la sua richiesta è stata considerata scaduta
    # NON bisogna cancellare richieste, altrimenti viene un macello, al contrario bisogna aggiungerne
    # una, cioè quella che ha fatto ma che non è più registrata.
    # Questo problema si risolve ponendo il tempo di timeout uguale al tempo di sessione
    # ed è ciò che bisogna fare: altrimenti tutto il senso di questo algoritmo così complesso si perde,
    # ovvero decrementando (erroneamente) una richiesta che successivamente riceverà un'annotazione dà
    # la possibilità agli altri utenti di fare annotazioni extra.
    # Questo codice che controlla se decrement == 0 è solo un'ulteriore sicurezza, ma la soluzione è
    # appunto avere un timeout pari alla durata della sessione.
    is_request_present = len([i for i in self.pending_annotations if i.image == image and i.user == user])
    if is_request_present == 0:
      image.add_request()

    # Dal registro delle richieste pendenti invece cancelliamo tutte le n richieste dell'utente
    annotations_to_remove = [i for i in self.pending_annotations if i.image == image and i.user == user]
    for elem in annotations_to_remove:
      self.pending_annotations.remove(elem)
      
    # Aggiungo l'annotazione vera e propria
    image.add_annotation(user.id)

    serverLock.release()

  def add_new_image(self):
    serverLock.acquire(True)
    l = len(self.images)
    self.images.append(Image(l))
    serverLock.release()

# ---------------------------------------- #

"""
Rappresenta l'utente che fa le annotazioni. E' identificato da un numero, contiene un riferimento
al server e all'immagine che sta attualmente annotando. L'utente annota l'immagine e poi invia
l'annotazione al server per ricevere la prossima immagine. Tuttavia in alcuni casi (che si
verificano casualmente) l'utente potrebbe richiedere una nuova immagine senza annotare la precedente.
Questo simula l'evento in cui un utente reale chiude il browser oppure preme in continuazione F5
senza inviare alcuna annotazione. Inoltre, siccome le immagini arrivano mano a mano che vengono selezionate,
se un utente non ha immagini da annotare, se ne va via per un po' in attesa che arrivino nuove immagini.
"""
class User:
  def __init__(self, id, server):
    self.id = id
    self.server = server
    self.current_image = None

  def __request_image(self):
    self.current_image = self.server.get_image(self)

  def __annotate(self, image, user):
    self.server.annotate(image, user)

  def work(self):
    # Richiedi la prossima immagine
    printLock("Richiesta di", self.id)
    self.__request_image()
    # Se non ha ricevuto immagini, l'utente "se ne va" per un po'
    if self.current_image == None:
      printLock("L'utente", self.id, "non ha ricevuto immagini...")
      time.sleep(WAITING_TIME)
      return

    # Aspetta un po' di tempo (quello necessario per annotare) calcolato casualmente
    random_time = random.random()*100000 % (MAXIMUM_TIME_BEFORE_REQUEST - MINIMUM_TIME_BEFORE_REQUEST) + MINIMUM_TIME_BEFORE_REQUEST
    time.sleep(random_time)

    # Invia l'annotazione con una certa probabilità
    random_annotation = random.random()*100000 % 100
    if random_annotation < PROBABILITY_OF_SUCCESS:
      printLock("Annotazione di", self.id)
      self.__annotate(self.current_image, self)
    else:
      printLock("ANNOTAZIONE MANCATA di", self.id)

# ---------------------------------------- #

"""
Siccome i lavoratori operano in contemporanea, ognuno di essi è rappresentato da un thread che lavora
in parallelo.
"""
class userThread(threading.Thread):
   def __init__(self, id, server):
      threading.Thread.__init__(self)
      self.id = id
      self.server = server
   def run(self):
      user = User(self.id, self.server)
      # finché non è scaduto il tempo...
      while time.time() - START_TIME < EXECUTION_TIME:
        user.work()

# ---------------------------------------- #

"""
Per simulare l'arrivo asincrono di nuove immagini dal task di selezione, creiamo un thread che aggiunge nuove immagini.
Ad ogni immagine viene assegnato un numero casuale che rappresenta il secondo di esecuzione in cui verrà caricata
nel server. Man mano che i timer scattano, le immagini vengono aggiunte.
"""
class serverThread(threading.Thread):
   def __init__(self, server):
      threading.Thread.__init__(self)
      self.server = server
   def run(self):
      randomizer = [random.random()*100000 % int(EXECUTION_TIME*3/4) for i in range(NUMBER_OF_IMAGES)]
      randomizer.sort()
      current_index = -1
      # finché non è scaduto il tempo...
      while time.time() - START_TIME < EXECUTION_TIME:
        time_so_far = time.time() - START_TIME
        for i in range(NUMBER_OF_IMAGES):
          if randomizer[i] < time_so_far and i == current_index+1:
            current_index = i
            #print("Aggiungo immagine...")
            server.add_new_image()
            break

# ---------------------------------------- #

# Crea il server e spawna i thread
server = Server()
threads = []

this_server = serverThread(server)
threads.append(this_server)
this_server.start()

for i in range(NUMBER_OF_USERS):
  this_user = userThread(i, server)
  threads.append(this_user)
  this_user.start()

# Attendi la conclusione di ogni thread (cioè lo scadere del tempo).
for t in threads:
    t.join()

# Una volta terminato il tempo di simulazione, mostriamo i dati grezzi.
printLock("\nID immagine", "\tNumero annotazioni", "\tNumero richieste")
for image in server.images:
  printLock(image.id, "\t\t", image.annotation_counter, "\t\t\t", image.request_counter)

# E poi calcoliamo un po' di dati elaborati...
num_immagini_con_almeno_M_annotazioni = 0
num_immagini_con_esattamente_M_annotazioni = 0
num_massimo_di_annotazioni_extra = 0

somma_annotazioni_extra = 0

for image in server.images:
  if image.annotation_counter >= LEAST_NUMBER_OF_ANNOTATIONS:
    num_immagini_con_almeno_M_annotazioni += 1
  else:
    continue
  if image.annotation_counter == LEAST_NUMBER_OF_ANNOTATIONS:
    num_immagini_con_esattamente_M_annotazioni += 1
  if image.annotation_counter - LEAST_NUMBER_OF_ANNOTATIONS > num_massimo_di_annotazioni_extra:
    num_massimo_di_annotazioni_extra = image.annotation_counter - LEAST_NUMBER_OF_ANNOTATIONS
  somma_annotazioni_extra += image.annotation_counter - LEAST_NUMBER_OF_ANNOTATIONS

try:
  num_medio_di_annotazioni_extra_maggiore_di_M = float(somma_annotazioni_extra)/(num_immagini_con_almeno_M_annotazioni - num_immagini_con_esattamente_M_annotazioni)
except:
  num_medio_di_annotazioni_extra_maggiore_di_M = 0
try:
  num_medio_di_annotazioni_extra_uguale_a_M = float(somma_annotazioni_extra)/num_immagini_con_almeno_M_annotazioni
except:
  num_medio_di_annotazioni_extra_uguale_a_M = "+inf"

try:
  percentuale_almeno_M = float(num_immagini_con_almeno_M_annotazioni)/NUMBER_OF_IMAGES*100
except:
  percentuale_almeno_M = "+inf"
try:
  percentuale_uguale_a_M = float(num_immagini_con_esattamente_M_annotazioni)/numero_immagini_con_almeno_M_annotazioni*100
except:
  percentuale_uguale_a_M = "+inf"

# E stampiamo tutto!
printLock("Numero di immagini con almeno M annotazioni\t\t\t\t\t", num_immagini_con_almeno_M_annotazioni, "\t", percentuale_almeno_M, "%")
printLock("Numero di immagini con esattamente M annotazioni\t\t\t\t", num_immagini_con_esattamente_M_annotazioni, "\t", percentuale_uguale_a_M, "%")
printLock("Numero massimo di annotazioni extra\t\t\t\t\t\t", num_massimo_di_annotazioni_extra)
printLock("Numero medio di annotazioni extra (solo immagini con più di M annotazioni)\t", num_medio_di_annotazioni_extra_maggiore_di_M)
printLock("Numero medio di annotazioni extra (tutte le immagini con almeno M annotazioni\t", num_medio_di_annotazioni_extra_uguale_a_M)
