import Foundation

// MARK: -                                              Grand Central Dispatch :
// Le Grand Central Dispatch (GCD) permet de gérer une grande partie des performances d'une application.
// Il permet de faire de la programmation concurrente, du multi-threading etc...


// MARK: -                                        I : Exécution Synchrone et Asynchrone

// Synchrone : Le programme attend que l'exécution d'une tâche se finisse avant de faire d'autres opérations. Cette méthode bloque le processeur.
// Code qui s'exécute de "haut en bas" comme par exemple les fonctions avec des returns

func presentationSynchrone() -> String {
  return "Lucas Abijmil"
}


// –––––––––––


// Asynchrone : Le programme n'attends pas la fin de l'exécution d'une tâche pour faire d'autres opérations. Cette méthode ne bloque pas le processeur.
// Le programme revient directemment sans attendre que la tâche soit finie, comme par exemple les fonctions sans return mais avec des closures (@non•escaping)
// La méthode asynchrone est utilisé dans de très nombreux cas en informatique : fetch d'API, accès à des DataBase, lecture d'un Fichier etc...
// Souvent utilisé pour des tâches potentiellement longues (en fonctions de nombreux paramètres)

func presentationAsynchrone(then completion: (String) -> Void) {
  completion("Lucas Abijmil")
}



// MARK: -                    II : DispatchQueue, "Custom DispatchQueue", DispatchQueue + delay

// Les tâches du GCD s'organises en Queue (file d'attente), représentable par une file FIFO First In, First Out
// Le GCD assure de ne lancer qu'une seule tâche à la fois

// Il existe deux types de Queues :
//  - Serial: DispatchQueue.main
//    • Lance une seule tâche à la fois (selon l'ordre de la file) et attend que cette tâche soit finit pour commencer l'exécution de la tâche suivante
//    • N'exécute qu'UNE SEULE tâche à la fois
//    • [n, n+1, n+2] ––> lancement de la tâche n ––> fin de la tâche n ––> lancement de la tâche n+1 ––> fin de la tâche n+1 ––> lancement de la tâche n+2 ––> fin de la tâche n+2
//      => à l'arrivée : [n, n+1, n+2]

//  - Concurrent : DispatchQueue.global
//    • Lance une tâche à la fois (selon l'ordre de la file) MAIS n'attend PAS la fin de cette tâche pour lancer l'exécution de la tâche suivante
//    • Exécute PLUSIEURS tâches à la fois et l'ordre de fin d'exécution de chaque tâche n'est pas prévisible
//    • [n, n+1, n+2] ––> lancement de la tâche n ––> lancement de la tâche n+1 ––> lancement de la tâche n+2
//      => à l'arrivée : [????] on ne peut pas savoir


// –––––––––––


// Voici les DispatchQueue selon leur ordre d'importance (du + important au - important)
DispatchQueue.main // MARK: À utiliser pour update la UI
DispatchQueue.global(qos: .userInteractive) // Très forte priorité : UI update (main thread) & animations
DispatchQueue.global(qos: .userInitiated) // Forte priorité : résultats immédiats (chargement de données depuis la UI genre un Button )
DispatchQueue.global(qos: .default) // Defaut, tâche que l'application initie
DispatchQueue.global() // Si pas de précision pour la qos ––> default par défaut (LMAO le jeu de mot)
DispatchQueue.global(qos: .utility) // Faible priorité : tâches longues (mise en réseau, recherche continue de donnée)
DispatchQueue.global(qos: .background) // Très faible priorité : tâches cachés à l'utilisateur (prefetch / tâches en background)
DispatchQueue.global(qos: .unspecified) // ?? / Plus faible des priorités ––> rien trouvé à propos de cette queue 


// –––––––––––


// MARK: Création de nos propre DispatchQueue

// - Création d'une Serial Queue
DispatchQueue(label: "serialCustomQueue")

// - Création d'une Concurrent Queue
// Plein d'init possible, nottament pour définir la QOS (par défaut : en fonction de ce qui est disponible comme ressource)
DispatchQueue(label: "ConcurrentCustomQueue", attributes: .concurrent)


// –––––––––––


// MARK: Exemple – exécution d'une tâche dans le background qui va par la suite mettre à jour la UI tout ça en méthode asynchrone
DispatchQueue.global(qos: .background).async {
  // some code here
  DispatchQueue.main.async {
    // update UI here
  }
}


// –––––––––––

// MARK: De temps à autre, il est possible de vouloir faire quelque chose après un delay (uniquement possible en asynchrone)
// Disponible pour les 2 types de Queue (serial & concurrent)

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
  // code executed after 2 seconds
}

DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(5)) {
  // code executed after 5 secod
}


// –––––––––––


// MARK: Exécution de tâches concurrentes, l'ordre de fin d'exécution est donc totalement alétoire
DispatchQueue.concurrentPerform(iterations: 5) { task in
  print(task)
}


// MARK: -                                       III : DispatchWorkItem

// Le GCD n'est rien d'autre qu'une liste de tâches exécutée
// une tâche est donc un DispatchWorkItem de type : () -> Void
// Cette tâche peut être inséré dans une DispatchQueue ou un DispatchGroup

// Méthodes disponibles :
//    - perform : exécution de la tâche
//    - wait : applique un DispatchTime avant toute prochaine action exécuté par le DispatchWorkItem
//    - notify : permet d'informer à une DispatchQueue que l'exécution du DispatchWorkItem est finie
//    - cancel : annule l'exécution d'un DispatchWorkItem
// workItem.isCancelled : bool qui indique si la tâche a été annulée


// –––––––––––


let workItem = DispatchWorkItem {
  print("workItem is computing a task....")
}

// Tâche sera exécuté sur la default queue et de manière asynchrone
DispatchQueue.global(qos: .default).async {
  workItem.perform() // exécution de la tâche
}

// Lorsque l'exécution de la tâche est finie, on notify la main queue pour run du code
workItem.notify(queue: .main) {
  print("workItem has finished its work")
}


// –––––––––––


// MARK: Exemple un peu plus complexe

var workItemBis: DispatchWorkItem?

workItemBis = DispatchWorkItem {
  // La tâche est composée de "5 sous tâches"
  for task in 0...5 {

    // unwrap de l'optionnel + vérification que la tâche n'est pas cancelled
    guard let workItem = workItemBis, !workItem.isCancelled else { print("workItemBis has been canceled"); break }

    // exécution de la tâche après un delay de 1 secondes
    workItem.wait(timeout: .now() + .seconds(1))
    print("workItemBis is computing task n°\(task)")
  }
}

// Exécution de la tâche
DispatchQueue.global(qos: .default).async(execute: workItemBis!) // pareil que .async { workItemBis!.perform() }

// Annulation de la tâches après un delay de 2 secondes
DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(2)) { workItemBis?.cancel() }



// MARK: -                                               IV : DispatchGroup


// DispatchGroup permet d'attendre que toutes les tâches d'un group soit fini avant de continuer l'exécution
// "Rend un ensemble de tâches asynchrones synchronisé, tout en laissant chaque sous-tâche asynchrone"
// DispatchGroup est très utile pour fetch des datas depuis plusieurs APIs qui ont besoin d'être "rassemblées"


// Méthodes disponibles :
//    - enter : indique le début d'exécution d'une tâche du DispatchGroup
//    - leave : indique la fin d'exécution d'une tâche du DispatchGroup
//    - notify : exécution d'une closure () -> Void lorsque le count du DispatchGroup est de 0 | indique que toutes les tâches d'un DispatchGroup sont finies
//    - wait : permet d'appliquer un DispatchTime sur un DispatchGroup


// MARK: Obligation - Le "count" d'un DispatchGroup doit toujours être de 0 à la fin d'exécution de toutes les tâches
//    - group.enter() : +1 au count du group
//    - group.leaver() : -1 au count du group

let group = DispatchGroup()

func fetchSomeData(completion: () -> Void) { completion() }

func fetchAllData() {
  group.enter() // group += 1
  fetchSomeData {
    print("Fetching some data from API n°1 ...")
    sleep(1)
    print("Fetch n°1 completed")
    group.leave() // group -= 1
  }

  group.enter() // group += 1
  fetchSomeData {
    print("Fetching some data from API n°2 ...")
    sleep(2)
    print("Fetch n°2 completed")
    group.leave() // group -= 1
  }

  group.enter() // group += 1
  fetchSomeData {
    print("Fetching some data from API n°3 ...")
    sleep(3)
    print("Fetch n°3 completed")
    group.leave() // group -= 1
  }
}

fetchAllData()

// Exécution de la closure uniquement si le count du DipatchGroup est 0 et si toutes les tâches ont finis leur travail
group.notify(queue: .main) {
  print("All data from all APIs are fetched")
}


// MARK: -                                                  V : DispatchSemaphore

// DispatchSemaphore permet de restreindre l'accès à une ressource partagée (DB, cache...)  par plusieurs thread (système concurrent)
// Permet de rendre une tâche asynchrone en synchrone ––> les queues utilisent les sémaphores que de manière asynchrone (assez logique, relire début)

// Méthodes disponibles :
//    - wait : permet d'indiquer qu'on utilise la ressource partagée (si celle-ci es disponible, sinon on wait)
//    - signal : permet d'indiquer la fin de l'utilisation de la ressource partagée

// MARK: Fonctionnement :
//    - À l'init du semaphore on indique le nombre de threads authorisé à utilisé simulatanement la ressource
//    - wait : -1 à la value du semaphore
//    - signal : +1 à la value du semaphore

// MARK: Fonction - Value du semaphore :
//    - value > 0 : d'autres threads peuvent utilisée la ressource partagée
//    - value = 0 : aucun autre thread ne peut utilisé la ressource partagée

// MARK: Tips: ne JAMAIS utilisé semaphore.wait() sur le main thread sinon crash de l'app / codes


let semaphore = DispatchSemaphore(value: 1) // value = 1 ––> 1 seul thread autorisé à accéder à la ressource partagé

DispatchQueue.global(qos: .default).async {
  print("Task 1 – wait")
  semaphore.wait() // value -= 1 (value = 0 ––> ressource partagée plus accessible par les autres threads)
  sleep(1) // comme un DispatchTime de 1 seconde
  semaphore.signal() // value += 1 (value = 1 ––> ressource partagée à nouveau accessible par les autres threads)
  print("Task 1 – done")
}

DispatchQueue.global(qos: .default).async {
  print("Task 2 – wait")
  semaphore.wait() // value -= 1 (value = 0 ––> ressource partagée plus accessible par les autres threads)
  sleep(1) // comme un DispatchTime de 1 seconde
  semaphore.signal() // value += 1 (value = 1 ––> ressource partagée à nouveau accessible par les autres threads)
  print("Task 2 – done")
}

DispatchQueue.global(qos: .default).async {
  print("Task 3 – wait")
  semaphore.wait() // value -= 1 (value = 0 ––> ressource partagée plu saccessible par les autres threads)
  sleep(1)
  semaphore.signal() // value += 1 (value = 1 ––> ressource partagée à nouveau accessible par les autres threads)
  print("Task 3 – done")
}




// MARK: -                                                  VI : DispatchSource

// Pas très utilisé dans la pratique car objet de bas niveau
// DispatchSource permet de surveiller des fichiers, ports, signaux (avec des sources de répartitions)
// Pour plus d'info aller voir la doc d'Apple

// Petit exemple avec un dispatchSource timer

let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now(), repeating: .seconds(1))
timer.setEventHandler {
  print("Hello there")
}
timer.resume()


