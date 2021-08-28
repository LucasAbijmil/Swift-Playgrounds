import Foundation
/*:
 # Grand Central Dispatch (GCD)
 * Le GCD permet de gérer une grande partie des performances d'une application
 * Il permet de faire de la programmation concurrente, du multi-threading, etc...
 */
/*:
 ## Exécution synchrone et asynchrone
 * **synchrone** :
    * Le programme attend que l'exécution d'une tâche se finisse avant de faire d'autres opérations. **Cette méthode bloque le processeur.**
    * Code qui s'exécute de "haut en bas" comme par exemple les fonctions avec des returns
 */
func presentationSynchrone() -> String {
  return "Lucas Abijmil"
}
/*:
 * **asynchrone** :
    * Le programme n'attends pas la fin de l'exécution d'une tâche pour faire d'autres opérations. **Cette méthode ne bloque pas le processeur.**
    * Le programme revient directemment sans attendre que la tâche soit finie, comme par exemple les fonctions sans return mais avec des @escaping closures
    * La méthode asynchrone est utilisé dans de très nombreux cas en informatique : fetch depuis API, accès à des Databases, lecture d'un fichier etc...
    * Souvent utilisé pour les tâches potentiellement longues
 */
func presentationAsynchrone(then completion: @escaping (String) -> Void) {
  completion("Lucas Abijmil")
}
/*:
 ## DispatchQueue
 * Les tâches du GCD s'organisent en queue (file d'attente), représentable par une file FIFO : First In, First Out
 * **Le GCD assure de lancer qu'une seule tâche à la fois**
 */
/*:
 ## Il existe deux types de queues :
 * **serial** : DispatchQueue.main
    * Lance une seule tâche à la fois (selon l'ordre de la file) et attend que cette tâche soit finit pour commencer l'exécution de la tâche suivante
    * **N'exécute qu'UNE SEULE tâche à la fois**
    * [n, n+1, n+2] ––> lancement de la tâche n ––> fin de la tâche n ––> lancement de la tâche n+1 ––> fin de la tâche n+1 ––> lancement de la tâche n+2 ––> fin de la tâche n+2 => à l'arrivée : [n, n+1, n+2]
 * **concurrent** : DispatchQueue.global
    * Lance une tâche à la fois (selon l'ordre de la file) MAIS n'attend PAS la fin de cette tâche pour lancer l'exécution de la tâche suivante
    * **Exécute PLUSIEURS tâches à la fois et l'ordre de fin d'exécution de chaque tâche n'est pas prévisible**
    * [n, n+1, n+2] ––> lancement de la tâche n ––> lancement de la tâche n+1 ––> lancement de la tâche n+2 => à l'arrivée : [????] on ne peut pas savoir
 */
/*:
 ## Voici l'ordre d'importance des DispatchQueue (du plus prioritaire au moins prioritaire) :
 * `DispatchQueue.main` : à utiliser uniquement pour update la UI – extrême priorité
 * `DispatchQueue.global(qos: .userInteractive)` : animations, event handling – très forte priorité
 * `DispatchQueue.global(qos: .userInitiated)` : résultats censés être immédiats (chargement de données depuis la UI, comme un boutton) – forte priorité
 * `DispatchQueue.global(qos: .default)` ou `DispatchQueue.global()` : tâche que l'application initie d'elle même – priorité par défaut
 * `DispatchQueue.global(qos: .utility)` : tâche longues (mise en réseau, recherche continue de données) – faible priorité
 * `DispatchQueue.global(qos: .background)` : tâches cachées à l'utilisateur (prefetch / tâches en background)
 */
DispatchQueue.main
DispatchQueue.global(qos: .userInteractive)
DispatchQueue.global(qos: .userInitiated)
DispatchQueue.global(qos: .default)
DispatchQueue.global()
DispatchQueue.global(qos: .utility)
DispatchQueue.global(qos: .background)
DispatchQueue.global(qos: .unspecified) // ??
/*:
 ## Créations de nos propres DispatchQueue
 * Création d'une **Serial queue**
 */
DispatchQueue(label: "serialCustomQueue")
//: * Création dune **Concurrent queue**
DispatchQueue(label: "ConcurrentCustomQueue", qos: .default, attributes: .concurrent)
//: ### Exemple : exécution d'une tâche dans le background qui va mettre à jour la UI tout ça en méthode asynchone
DispatchQueue.global(qos: .background).async {
  // some code here
  DispatchQueue.main.async {
    // update UI here
  }
}
/*:
 ## DispatchQueue + Delay
 * Possibilité de delay un block de code mais **uniquement en asynchrone**
 * Disponible pour les queues **serial** & **concurrent**
 */
DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { /* code executed after 2 seconds */ }
DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(5)) { /* code executed after 5 seconds */ }
/*:
 ## DispatchWorkItem
 * Le GCD n'est rien d'aute qu'une liste de tâches exécutées
 * Chaque tâche est donc par transition un `DispatchWorkItem` de type : `() -> Void`
 * Un `DispatchWorkItem` peut être inséré dans une `DispatchQueue` ou un `DispatchGroup`
 * Fonctions diponibles :
    * `perform` : exécution de la tâche
    * `wait` : applique un `DispatchTime` acvant tout prochaine action exécuté par le `DispatchWorkItem`
    * `notify` : permet de notifier une queue que l'exécution du `DispatchWorkItem` est finie et d'exécuter du code dans la closure
    * `cancel` : annule l'exécution du `DispatchWorkItem`
    * `workItem.isCancelled` : booléen qui indique si la tâche a été annulée ou non
 */
//: * Création d'un `DispatchWorkItem`
let workItem = DispatchWorkItem {
  print("workItem is computing a task....")
}
//: * Exécution d'un `DispatchWorkItem`
DispatchQueue.global(qos: .default).async {
  workItem.perform()
}
//: * Notification d'une queue que le `DispatchWorkItem` a finit son exécution
workItem.notify(queue: .main) {
  print("workItem has finished its work")
}
//: ### Exemple un peu plus complexe
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
DispatchQueue.global(qos: .default).async(execute: workItemBis!) // pareil que .async { workItemBis!.perform() }
// Annulation de la tâches après un delay de 2 secondes
DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .seconds(2)) { workItemBis?.cancel() }
/*:
 ## DispatchGroup
 * Permet d'attendre que toutes les tâches d'un groupe soient finies avant de conitunuer l'exécution
 * Rend un ensemble de tâches **asynchrones synchronisés**, tout en laissant chaque sous-tâches **asynchrones**
 * `DispatchGroup` est très utile pour fetch des datas depuis plusieurs APIs qui ont besoin d'être "rassebmlées"
 * Fonctions dispnibles :
    * `enter` : indique le début d'exécution d'une tâche du `DispatchGroup`
    * `leave` : indique la fin d'exécution d'une tâche du `DispatchGroup`
    * `notify` : permet de notifier une queue que l'exécution du `DispatchGroup` est finie et d'exécuter du code dans la closure
    * `wait` : permet d'appliquer un `DispatchTime` sur un `DispatchGroup`
 * Fonctionnement : le count du `DispatchGroup` doit toujours être à 9 à la fin d'exécution de toutes les tâches
    * `group.enter()` : +1 au count du groupe
    * `group.leaver()` : -1 au count du groupe

 */
//: * Création du `DispatchGroup`
let group = DispatchGroup()
func fetchSomeData(completion: @escaping () -> Void) { completion() }

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
//: * Note : exécution de la closure uniquement si le count du `DispatchGroup` est 0 et si toutes les tâches ont finis leur travail
group.notify(queue: .main) {
  print("All data from all APIs are fetched")
}
/*:
 ## DispatchSemaphore
 * Permet de restreindre l'accès à une ressource partagée (Database, cache...) par plusieurs thread (système concurrent)
 * Rend une tâche **asynchrone en synchrone** ––> les queues utilisent les sémaphores que de manière asynchrone
 * Fonctions disponibles :
    * `wait` : permet d'indiquer qu'on utilise la ressource partagée (si celle-ci es disponible, sinon on wait)
    * `signal` : permet d'indiquer la fin de l'utilisation de la ressource partagée
 * Fonctionnement :
    * à l'init du `DispatchSemaphore` on inidque le nombre de threads autorisés à utiliser ka ressource simultanément
    * `sempahore.wait` : -1 à la value du semaphore
    * `semaphore.signal` : +1 à la value du semaphore
    * Si **value > 0** : d'autres threads peuvent utiliser la ressource partagée
    * Si **value = 0** : aucun autre thread ne peut utiliser la ressource partagée
 * **Tip** : ne **jamais** utilisé `semaphore.wait()` sur le main thread sinon crash
 */
//: * Création d'un `DispatchSemaphore` avec une value de 1 👉 un seul thread est authorisé à accéder à la ressource partagée
let semaphore = DispatchSemaphore(value: 1)
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
  sleep(1)
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
/*:
 ## DispatchSource
 * Permet de surveiller des fichiers, ports, signaux...
 * Pas très utilisé dans la pratique car objet de bas niveau
 * Aller voir la doc d'Apple pour la suite
 */
let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now(), repeating: .seconds(1))
timer.setEventHandler {
  print("Hello there")
}
timer.resume()
