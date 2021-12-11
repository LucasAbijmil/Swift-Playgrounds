import SwiftUI
import UIKit
/*:
 # Adopter async await dans un projet existant
 */
/*:
 * En adoptant `async` `await` dans un projet existant il faut **faire attention à ne pas casser tout le code**
 * Lors de refacto comme celui-ci, l'optimal est de **maintenir les anciennes APIs pour un certain temps, avant de les supprimer, afin de ne pas avoir à mettre à jour toute la code base**
 * Cela peut s'apparenter à la dépréciation de méthode dans un SDK qui est utilisé par des développeurs
 */
/*:
 * Xcode facilite grandement la refactorisation de notre code à travers plusieurs mécanismes (cmd + clic gauche)
 * Nous nous baserons sur cette exemple plutôt simple qui est un fetch avec une completion contenant un `Result<[UIImage], Error>`
 */
struct ImageFetcher {
  func fetchImages(completion: @escaping (Result<[UIImage], Error>) -> Void) { /* some network call */ }
}
//: * Le premier mécanisme est *Convert Function to async* **permettant de transformer la signature de la fonction en une version `async throws` – ⚠️ Cela ne modifie pas le code à l'intérieur !**
struct ImageFetchConvert {
  func fetchImages() async throws -> [UIImage] { /* some network call */ return [] }
}
/*:
 * Le deuxième mécanisme est *Add Async Alternative*, qui fait plusieurs choses à la fois :
    * Garde l'ancienne signature de l'API mais en utilisant à l'intérieur la version `async` de cette même API via une `Task`
    * Créer la fonction `async` pour vous tout en y conservant le même code qu'avant – il peut donc être nécessaire de faire des modifications
 * Le `@available` avec le `deprecated` est très pratique pour savoir où mettre à jour le code avec la nouvelle version `async` de l'API
 */
/*:
 * **L'avantage de ce mécanisme est qu'il permet d'adapter progressivement notre code à la *concurrence structurée* sans avoir à tout changer en une seule fois**
 * Un autre avantage est que Xcode peut fix les warnings (de depreciation) en convertissant automatiquement notre code avec la nouvelle implémentation
 */
//: * ⚠️ Il peut être intéressant de build le projet avant / après le refacto afin de voir si les modifications fonctionnent comme prévu
struct ImageFetchAlternative {
  @available(*, deprecated, message: "Prefer async alternative instead")
  func fetchImages(completion: @escaping (Result<[UIImage], Error>) -> Void) {
    Task {
      do {
        let result = try await fetchImages()
        completion(.success(result))
      } catch {
        completion(.failure(error))
      }
    }
  }

  func fetchImages() async throws -> [UIImage] { /* some network call */ return [] }
}
/*:
 * Le troisième mécanisme est *Add Async Wrapper* qui créer une API `async throws` de notre fonction en wrappant la completion
 * Pour cela dans on utilise **`withCheckedThrowingContinuation` qui permet de wrapper des fonctions avec completion de type `Result<T, Error>`**. S'il y a une erreur dans la completion, celle-ci est `throw` dans la fonction `async`
 * Les completions *juste* `T` peuvent être wrapper avec la méthode `withCheckedContinuation` qui fonctionne de la même manière mais ne supporte pas les erreurs
 * **Ces deux méthodes suspendent la tâche en cours jusqu'à ce que la closure soit trigger pour déclencer la `continuation` de la méhtode `async`**
 */
struct ImageFetcherWrapper {
  func fetchImages(completion: @escaping (Result<[UIImage], Error>) -> Void) { }

  func fetchImages() async throws -> [UIImage] {
    return try await withCheckedThrowingContinuation { continuation in
      fetchImages() { result in
        continuation.resume(with: result)
      }
    }
  }
}
/*:
 * Il existe deux autres fonctions similaires qui sont `withUnsafeThrowingContinuation` & `withUnsafeContinuation`
 * On peut réécrire donc la fonction ci-dessus comme il suit
 */
struct ImageFetcherWrapperUnsafe {
  func fetchImages(completion: @escaping (Result<[UIImage], Error>) -> Void) { }

  func fetchImages() async throws -> [UIImage] {
    return try await withUnsafeThrowingContinuation { continuation in
      fetchImages() { result in
        continuation.resume(with: result)
      }
    }
  }
}
/*:
 * Différences entre ces deux types de fonctions :
    * `withCheckedThrowingContinuation` & `withCheckedContinuation` : Swift vérifie qu'on appelle au minimum et au maximum une fois le `resume`. **⚠️ Cette vérification a un coup au runtime**
    * `withUnsafeThrowingContinuation` & `withUnsafeContinuation` : Aucune vérification faite au runtime – **peut provoquer des leaks / crashs** si on appelle `resume` moins ou plus d'une fois
 * Une bonne technique consiste à utiliser les `checked` version puis de passer aux `unsafe` une fois que tous les warnings / erreurs ont été fixé
 */

//: [< Structured Concurrency](@previous)           [Home](Home)
