//
//  Async & Await.swift
//  Await
//
//  Created by Lucas Abijmil on 08/03/2021.
//

import Foundation
import _Concurrency

 // MARK: - Exemple de fonction asynchrones classiques en iOS (mocks)
func getUserId(_ completion: @escaping (Int) -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    completion(42)
  }
}

func getUserFirtName(userID: Int, _ completion: @escaping (String) -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    completion("Lucas")
  }
}

func getUserLastName(userID: Int, _ completion: @escaping (String) -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    completion("Abijmil")
  }
}

func greetUser() {
  getUserId { id in
    getUserFirtName(userID: id) { firstName in
      getUserLastName(userID: id) { lastName in
        print(firstName, lastName)
      }
    }
  }
}

// MARK: Le problème des completions et qu'à chaque fois qu'on va fouloir faire des appels on est obligé de nester à cause de ces completions ––> devient vite le bordel (pyramid of Doom)

// MARK: Nouveau : utilisation des fonctions async / await
//  - async mot clé à ajouter aux fonctions asynchrones, de la même manière que throws
//  - Ces fonctions async sont autorisées à bloquer leur exécution et donc bloqué le thread qui les appelle. En appellant une fonction async on garantie qu'on ne bloque pas notre application par erreur

// MARK: "Traduction" des fonctions en version "async"
//  - Utilisation d'une fonction de bas niveau, en attendant que les DispatchQueues aient leurs versions async
//  - withUnsafeContinuation exécute une closure avec un objet "continuation" comme paramètre permettant d'appeler la fonction resume(returning:). En appelant with withUnsafeContinuation le thread de la fonction est bloqué et sera débloqué une fois l'appel à resume(returning:)
//  - await : indique que la fonction bloque le thread juqu'à ce que la fonction appellé par wait retourne une value, similair à try mais pour une async fonction

func getUserId() async -> Int {
  return await withUnsafeContinuation { continuation in
    getUserId { userID in
      continuation.resume(returning: userID)
    }
  }
}

func getUserFirstName(userID: Int) async -> String {
  return await withUnsafeContinuation { continuation in
    getUserFirtName(userID: userID) { firstName in
      continuation.resume(returning: firstName)
    }
  }
}

func getUserLastName(userID: Int) async -> String {
  return await withUnsafeContinuation { continuation in
    getUserLastName(userID: userID) { lastName in
      continuation.resume(returning: lastName)
    }
  }
}

//  MARK: Plusieurs steps :
//  - on appelle des fonctions async donc obligé de rajouter le async dans le signature de la fonction (comme une fonction qui throws)
//  - cependant les fonctions marquées async ne peuvent pas être appelées par des fonctions "normales" puisques ces fonctions async peuvent bloquer le thread qui les exécute
//  - geetUserAsync() est fonction async particulière : elle ne retourne aucune valeur, utilisation de @asyncHandler au lieu de async
//  - @asyncHandler permet d'appeler des fonctions async (qui ne retourne pas de valeur) et d'être appellé par des fonctions "normales"
@asyncHandler func geetUserAsync() /*async*/ {
  let userID = await getUserId()
  let firstName = await getUserFirstName(userID: userID)
  let lastName = await getUserLastName(userID: userID)
  print(firstName, lastName)
}

// MARK: Remarques & Optimisations  (Async en parallèle)
//  - Les appels sont fait les uns après les autres (getUserId ––> getUserFirstName ––> getUserLastName). Mais on pourrait exécuter getUserFirstName & getUserLastName en parallèle
//  - Analysons : let firstName = await getUserFirstName(userID: userID) (même logique pour getUserFirstName(userID: userID)
//    1) On créer une background task : getUserFirstName(userID: userID)
//    2) On exécute cette task (en bloquant le thread) grâce à l'utilisation du mot clé await et on débloque le thread une fois qu'une valeur est returned (storé dans firstName) 
//  - Ainsi pour exécuter des fonctions en parallèle on doit découpler ces deux étapes (création, exécution) :
//    1) On créer les tasks que nous avons besoins, grâce à la nouvelle expression : async let firstName = getUserFirstName(userID: userID)
//    2) On exécutes ces tasks d'une seule traite afin de les exécuter en parallèles
//  - async let firstName = getUserFirstName(userID: userID) : on store une task qui une fois appellée sera capable de nous retourner le firstName

@asyncHandler func getUserAsyncInParall() {
  let userID = await getUserId() // ici on garde le await (bloquant le thread) car on est obligé d'attendre d'avoir le userID pour la suite
  async let firstName = getUserFirstName(userID: userID) // création de la task
  async let lastName = getUserLastName(userID: userID) // création de la task
  await print(firstName, lastName) // await pour exécuter ces tasks en parallèles et une fois leurs exécution fini, le compilateur pourra exécuter ce qui suit (ici le print)
}


// MARK: - Transformer une fonction "classique" en async fonction
// Exemple avec la fonction URLSession.shared.dataTask
func regularPrintNetworkData() {

  let serviceURL = URL(string: "https://samples.openweathermap.org/data/2.5/weather?id=2172797&appid=b6907d289e10d714a6e88b30761fae22")!

  URLSession.shared.dataTask(with: serviceURL) { data, response, error in
    guard let data = data,
          let dataValue = String(data: data, encoding: .utf8)
    else { return }

    print(dataValue)
  }
  .resume()
}

// MARK: Extension sur URLSession
extension URLSession {

  func dataTask(with url: URL) async -> (Data?, URLResponse?, Error?) {
    return await withUnsafeContinuation { continuation in
      self.dataTask(with: url) { data, response, error in
        continuation.resume(returning: (data, response, error))
      }
      .resume()
    }
  }
}

@asyncHandler func asyncPrintNetworkData() {

  let serviceURL = URL(string: "https://samples.openweathermap.org/data/2.5/weather?id=2172797&appid=b6907d289e10d714a6e88b30761fae22")!

  let (data, _, _) = await URLSession.shared.dataTask(with: serviceURL)

  guard let data = data,
        let dataValue = String(data: data, encoding: .utf8)
  else { return }

  print(dataValue)
}
