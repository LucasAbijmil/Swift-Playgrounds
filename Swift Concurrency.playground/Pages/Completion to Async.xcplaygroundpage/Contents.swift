import Foundation
/*:
 # Completion to Async – Transformer des fonctions avec completions en fonctions marquées async
 * Les APIs de `Continuation` nous permettent de bridger des fonctions avec completions vers des fonctions `async`
 */
func fetchLatestNews(completion: @escaping (Result<[String], Error>) -> Void) {
  DispatchQueue.global().async {
    completion(.success(["Lucas", "Marc", "David"]))
  }
}
/*:
 * Pour wrapper une fonction, cela se passe en plusieurs étapes :
    * Le type de la completion devient le type de retour de la fonction qui doit être marquée `async`
    * Utilisation des APIs `withCheckedContinuation` et `withUnsafeContinuation` précédée d'un `await`
    * Ces APIs passe une *continuation* dans laquelle on appelle la fonction asynchrones avec completion a bridger
    * Appeller `resume(returning:)` grâce à la *continuation* pour renvoyer la valeur du résultat du call
 */
func fetchLatestNews() async -> Result<[String], Error> {
  await withCheckedContinuation { continuation in
    fetchLatestNews { result in
      continuation.resume(returning: result)
    }
  }
}

func fetchLastestNews2() async -> Result<[String], Error> {
  await withUnsafeContinuation { continuation in
    fetchLatestNews { result in
      continuation.resume(returning: result)
    }
  }
}

func printNews() async {
  let result = await fetchLatestNews()
  switch result {
  case .success(let news):
    news.forEach { print($0) }
  case .failure(let error):
    print(error.localizedDescription)
  }

  let result2 = await fetchLastestNews2()
  switch result2 {
  case .success(let news):
    news.forEach { print($0) }
  case .failure(let error):
    print(error.localizedDescription)
  }
}
/*:
 * Différences entre `withCheckedContinuation` & `withUnsafeContinuation` :
    * `withCheckedContinuation` : Swift vérifie qu'on appelle au minimum et maximum une fois le `resume(returning:)`. Cette vérification à un coup au runtime
    * `withUnsafeContinuation`: Aucune vérification peut causer des leaks / crashs si on appelle `resume(returning:)` moins ou plus d'une fois
 * Une bonne technique consiste à utiliser `withCheckedContinuation` puis de passer à `withUnsafeContinuation` une fois que tous les warnings / erreurs ont été fixés
 */
//: [< Previous: `AsyncSequence`](@previous)           [Home](Home)           [Next:  Structured Concurrency >](@next)
