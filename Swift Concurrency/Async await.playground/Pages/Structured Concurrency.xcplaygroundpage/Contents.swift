import SwiftUI
import UIKit
/*:
 # Structured concurrency – Faciliter la compréhension et le raisonnement sur l'ordre d'exécution de fonctions asynchrones
 */
/*:
 * Avant `async` `await` on utilisait **les completions / closures, mais possèdent de nombreux inconvénients** :
    * On doit s'**assurer que la completion est bien appellé pour tous les cas. Si ce n'est pas le cas, notre application attend un résultat... qui n'arrivera jamais**
    * **Les closures sont dures à lire**, il n'est pas aussi facile de lire / raisonner sur l'ordre d'exécution qu'avec une *concurrence structurée*
    * **On peut créer des retains cycle**, pour les éviter on doit utiliser `[weak self]` au sein de la completion / callback
    * Les fonctions appelantes doivent `switch` sur le résultat du call (à cause du type `Result<T, Error>`). **Il n'est pas possible d'utiliser un block `do catch` pour gérer l'erreur**
 */
func fetchImages(completion: @escaping (Result<[UIImage], Error>) -> Void) {
  /* some code */
  completion(.success([]))
}
func decodeImages(_ images: [UIImage], completion: @escaping (Result<[UIImage], Error>) -> Void) {
  /* some code */
  completion(.success([]))
}
/*:
 * **La *concurrence structurée* notamment avec `async` & `await` facilite le raisonnement / écriture / lecture sur l'ordre d'exécution**
 * Les méthodes (et la lecture du code) sont **exécutées de manière linéaire sans aller et venir comme avec les closures**
 */
//: * Pour mieux comprendre cela, voici l'exemple d'un fetch avant l'arrivé de la *concurrence structurée*
func fetchAllImages() {
  // 1. Appel de la fonction fetchImages
  fetchImages { result in
    // 3. La fonction asynchrone retourne dans le closure
    switch result {
    case .success(let images):
      print("Fetch \(images.count) images")
    case .failure(let error):
      print("Fetching images failed with error \(error.localizedDescription)")
    }
  } // 2. L'appel à la fonction fetchImages se termine
}
/*:
 * Comme on peut le voir, la fonction se termine avant que les images ne soit totalement fetchées
 * Après un certain temps, un résultat est reçu et nous retournons dans notre flow au sein de la closure
 * Il s'agit d'un **ordre d'exécution non structuré le rendant (potentiellement) difficile à suivre & à comprendre**
 */
//: * C'est encore plus vrai si nous devions exécuter une autre méthode asynchrone dans la completion d'une première fonction, rajoutant un autre callback (*pyramid of doom & callback hell*) comme il suit
func fetchAllImagesAndResize() {
  // 1. Appel de la fonction fetchImages
  fetchImages { result in
    // 3. La fonction asynchrone retourne dans la closure
    switch result {
    case .success(let images):
      print("Fetched \(images.count) images")
      // 4. Appel de la fonction decodeImages
      decodeImages(images) { result in
        // 6. La fonction asynchrone decodeImages retourne dans la closure
        switch result {
        case .success(let images):
          print("Decoded \(images.count) images")
        case .failure(let error):
          print("Decoding images failed with error \(error.localizedDescription)")
        }
      } // 5. La fonction decodeImages se termine
    case .failure(let error):
      print("Fetching images failed with error \(error.localizedDescription)")
    }
  } // 2. L'appel à la fonction fetchImages se termine
}
/*:
 * Chaque closure ajoute un nouveau niveau d'indentation, ce qui rend le suivit d'**ordre d'exécution de plus en plus complexe (complexité proche de l'exponentielle)**
 * Réécrivons le même code que ci-dessus mais en utilisant `async` & `await` afin de démontrer tout les avantages de la *concurrence structurée* (complexité linéaire)
 */
func fetchImages() async throws -> [UIImage] {
  /* some code */
  return []
}
func decodeImages(_ images: [UIImage]) async throws -> [UIImage] {
  /* some code */
  return []
}

func fetchAllImagesAndResizeWithAsyncAwait() {
  Task {
    do {
      // 1. Appel de la contion fetchImages
      let images = try await fetchImages()
      // 2. L'appel à la fonction fetchImages se termine
      print("Fetched \(images.count) images")
      // 3. Appel de la fonction decodeImages
      let decodedImages = try await decodeImages(images)
      // 4. Appel à la fonction fetchImages
      print("Decoded \(decodedImages.count) images")
    } catch {
      print("An error occured : ", error.localizedDescription)
    }
  }
}
/*:
 * **L'odre d'exécution est linéaire, par conséquent cela est beaucoup plus facile à écrire / comprendre / raisonner**
 * La compréhension du code asynchrone est plus facile, bien qu'il peut être parfois un peu plus complexe
 */
//: * Est-ce que le type `Result` va être abandonné avec les fonction `async throws` ? Très probablement, puisque les erreurs des fonctions `throw` une `Error`

//: [< Previous: `async URLSession`](@previous)           [Home](Home)           [Next: Adopter `async` `await` dans un projet existant >](@next)
