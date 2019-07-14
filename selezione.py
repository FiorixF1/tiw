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
LEAST_NUMBER_OF_RATINGS = 25        # parametro N
EXECUTION_TIME = 100                # tempo d'esecuzione del programma in secondi
MINIMUM_TIME_BEFORE_REQUEST = 2     # tempo minimo perché un utente voti un'immagine
MAXIMUM_TIME_BEFORE_REQUEST = 4     # tempo massimo perché un utente voti un'immagine
REQUEST_TIMEOUT = 7     # tempo oltre il quale un voto può considerarsi abbandonato
                        # nell'implementazione reale questo parametro DEVE ASSOLUTAMENTE VALERE ALMENO QUANTO LA DURATA DELLA SESSIONE
                        # altrimenti possono succedere cose assurde
                        # capire questa cosa mi è costato ore di debugging
PROBABILITY_OF_SUCCESS = 85         # probabilità che un'immagine riceva un voto dall'utente che l'ha richiesta
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
uno è il numero di voti ricevuti e l'altro è il numero di volte che è stata richiesta
quell'immagine. Quest'ultima variabile viene usata per la scelta delle immagini da consegnare
e rappresenta un valore di richieste fittizio (può essere decrementato).
L'immagine contiene anche una lista degli utenti che hanno dato un voto.
Diamo per scontato che le immagini appartengono ad una sola campagna, a cui tutti gli utenti
stanno contribuendo. Lo scopo dell'algoritmo di scelta è fare in modo che rating_counter
sia il più possibile uguale (se non esattamente uguale) al parametro N della campagna.
"""
class Image:
  def __init__(self, id):
    self.id = id
    self.rating_counter = 0
    self.request_counter = 0
    self.workers_who_rated_it = []

  def add_request(self):
    self.request_counter += 1

  def remove_request(self):
    self.request_counter -= 1

  def add_rating(self, user_id):
    self.rating_counter += 1
    self.workers_who_rated_it.append(user_id)

# ---------------------------------------- #

"""
Rappresenta il server che riceve richieste. Contiene un riferimento alle immagini e le richieste
che si possono fare sono l'aggiunta di un voto e la ricezione della prossima immagine.
La richiesta della prossima immagine rappresenta il cuore dell'algoritmo che vogliamo implementare.
EDIT: è stato trovato l'algoritmo perfetto. Esso prevede l'aggiunta di una lista che memorizza le richieste
fatte (nella realtà sarà una tabella del db). Ogni richiesta contiene l'immagine, l'utente e il timestamp.
Quest'ultimo viene usato per capire se un voto è stato abbandonato o meno. Ogni volta che un utente
fa una richiesta, si controlla in questa lista se una richiesta precedente è "scaduta" (cioè è passata una certa
quantità di tempo senza ricevere il voto) e nel caso si decrementa il contatore delle richieste dell'immagine
associata e si cancella la richiesta dalla lista. Nauralmente poi, prima di consegnare l'immagine all'utente,
la nuova richiesta viene registrata nella lista. La durata del timeout nell'implementazione reale DEVE essere
maggiore o uguale alla durata della sessione web. Inoltre un'ottimizzazione prevede che quando l'utente fa una richiesta
di una nuova immagine, il server cancella subito le richieste precedenti fatte dallo stesso utente, perché
si sa già che questo utente non potrà fornire un voto alle immagini precedenti. Stessa cosa quando arriva
una richiesta di logout, che invalida la sessione.
"""
class Server:
  def __init__(self):
    self.images = [Image(i) for i in range(NUMBER_OF_IMAGES)]
    self.pending_ratings = []  # tabella nel db

  def get_image(self, user):
    serverLock.acquire(True)
    
    # --- CORE DELL'ALGORITMO: deve ritornare una Image --- #

    # Prima di scegliere l'immagine, controllo le richieste pendenti
    # Se sono presenti richieste "scadute" decremento il contatore di richieste e le elimino
    # ATTENZIONE: QUESTO IN JAVA LO FAREMO ANCHE AL LOGOUT PER OTTIMIZZAZIONE
    current_time = time.time()
    for line in self.pending_ratings:
      if current_time - line.timestamp > REQUEST_TIMEOUT:
        line.image.remove_request()
    self.pending_ratings = [i for i in self.pending_ratings if current_time - i.timestamp <= REQUEST_TIMEOUT]

    # Inoltre, se l'utente corrente ha altre richieste pendenti in attivo, posso già cancellarle prima del timeout
    # perché è impossibile che l'utente possa inviarmi annotazioni delle immagini precedenti
    # Questa operazione evita che persistano per troppo tempo numerose richieste di un utente su una stessa immagine
    # che poi alla fine ha annotato
    for line in self.pending_ratings:
      if line.user == user:
        line.image.remove_request()
    self.pending_ratings = [i for i in self.pending_ratings if i.user != user]
    
    # Cerco le immagini che hanno un numero di RICHIESTE inferiore a N (sì, richieste e non annotazioni!)
    not_enough_requests = [x for x in self.images if x.request_counter < LEAST_NUMBER_OF_RATINGS]

    # Tra queste cerco le immagini non votate dall'utente attuale
    not_rated_by_user = [x for x in not_enough_requests if user.id not in x.workers_who_rated_it]

    # Cerco le immagini con meno richieste tra quelle rimaste: il risultato sarà l'insieme di immagini candidate
    least_number_of_requests = float("+inf")
    for x in not_rated_by_user:
      if x.request_counter < least_number_of_requests:
        least_number_of_requests = x.request_counter
    candidates = [x for x in not_rated_by_user if x.request_counter == least_number_of_requests]

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
    self.pending_ratings.append(this_request)

    resulting_image.add_request()

    # --- FINE ALGORITMO --- #

    serverLock.release()
    return resulting_image

  def rate(self, image, user):
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
    is_request_present = len([i for i in self.pending_ratings if i.image == image and i.user == user])
    if is_request_present == 0:
      image.add_request()

    # Dal registro delle richieste pendenti invece cancelliamo tutte le n richieste dell'utente
    annotations_to_remove = [i for i in self.pending_ratings if i.image == image and i.user == user]
    for elem in annotations_to_remove:
      self.pending_ratings.remove(elem)
      
    # Aggiungo il voto vero e proprio
    image.add_rating(user.id)

    serverLock.release()

  # Non utilizzato in questo script
  def add_new_image(self):
    serverLock.acquire(True)
    l = len(self.images)
    self.images.append(Image(l))
    serverLock.release()

# ---------------------------------------- #

"""
Rappresenta l'utente che da' i voti. E' identificato da un numero, contiene un riferimento
al server e all'immagine che sta attualmente votando. L'utente vota l'immagine e poi invia
il voto al server per ricevere la prossima immagine. Tuttavia in alcuni casi (che si verificano
casualmente) l'utente potrebbe richiedere una nuova immagine senza votare la precedente.
Questo simula l'evento in cui un utente reale chiude il browser oppure preme in continuazione F5
senza inviare alcun voto.
"""
class User:
  def __init__(self, id, server):
    self.id = id
    self.server = server
    self.current_image = None

  def __request_image(self):
    self.current_image = self.server.get_image(self)

  def __rate(self, image, user):
    self.server.rate(image, user)

  def work(self):
    # Richiedi la prossima immagine
    printLock("Richiesta di", self.id)
    self.__request_image()
    if self.current_image == None:
      printLock("L'utente", self.id, "non ha ricevuto immagini...")
      return

    # Aspetta un po' di tempo (quello necessario per votare) calcolato casualmente
    random_time = random.random()*100000 % (MAXIMUM_TIME_BEFORE_REQUEST - MINIMUM_TIME_BEFORE_REQUEST) + MINIMUM_TIME_BEFORE_REQUEST
    time.sleep(random_time)

    # Invia il voto con una certa probabilità
    random_annotation = random.random()*100000 % 100
    if random_annotation < PROBABILITY_OF_SUCCESS:
      printLock("Annotazione di", self.id)
      self.__rate(self.current_image, self)
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

# Crea il server e spawna i thread
server = Server()
threads = []

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
  printLock(image.id, "\t\t", image.rating_counter, "\t\t\t", image.request_counter)

# E poi calcoliamo un po' di dati elaborati...
num_immagini_con_almeno_N_voti = 0
num_immagini_con_esattamente_N_voti = 0
num_massimo_di_voti_extra = 0

somma_voti_extra = 0

for image in server.images:
  if image.rating_counter >= LEAST_NUMBER_OF_RATINGS:
    num_immagini_con_almeno_N_voti += 1
  else:
    continue
  if image.rating_counter == LEAST_NUMBER_OF_RATINGS:
    num_immagini_con_esattamente_N_voti += 1
  if image.rating_counter - LEAST_NUMBER_OF_RATINGS > num_massimo_di_voti_extra:
    num_massimo_di_voti_extra = image.rating_counter - LEAST_NUMBER_OF_RATINGS
  somma_voti_extra += image.rating_counter - LEAST_NUMBER_OF_RATINGS

try:
  num_medio_di_voti_extra_maggiore_di_N = float(somma_voti_extra)/(num_immagini_con_almeno_N_voti - num_immagini_con_esattamente_N_voti)
except:
  num_medio_di_voti_extra_maggiore_di_N = 0
try:
  num_medio_di_voti_extra_uguale_a_N = float(somma_voti_extra)/num_immagini_con_almeno_N_voti
except:
  num_medio_di_voti_extra_uguale_a_N = "+inf"

try:
  percentuale_almeno_N = float(num_immagini_con_almeno_N_voti)/NUMBER_OF_IMAGES*100
except:
  percentuale_almeno_N = "+inf"
try:
  percentuale_uguale_a_N = float(num_immagini_con_esattamente_N_voti)/numero_immagini_con_almeno_N_voti*100
except:
  percentuale_uguale_a_N = "+inf"

# E stampiamo tutto!
printLock("Numero di immagini con almeno N voti\t\t\t\t\t", num_immagini_con_almeno_N_voti, "\t", percentuale_almeno_N, "%")
printLock("Numero di immagini con esattamente N voti\t\t\t\t", num_immagini_con_esattamente_N_voti, "\t", percentuale_uguale_a_N, "%")
printLock("Numero massimo di voti extra\t\t\t\t\t\t", num_massimo_di_voti_extra)
printLock("Numero medio di voti extra (solo immagini con più di N voti)\t\t", num_medio_di_voti_extra_maggiore_di_N)
printLock("Numero medio di voti extra (tutte le immagini con almeno N voti\t\t", num_medio_di_voti_extra_uguale_a_N)
