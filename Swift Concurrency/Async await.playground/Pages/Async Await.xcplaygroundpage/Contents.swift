import UIKit
/*:
 # Async await – Créer & appeler des fonctions (potentiellement) asynchrones
 */
/*:
 * `async` `await` fait partie de la *concurrence structurée* ce qui signifie que **plusieurs *morceaux* de code peuvent s'exécuter en même temps**
 * Grâce aux fonctions marquées `async`, on peut définir des méthodes asynchrones qui auparavant étaient représentées par des `@escaping` closures
 */
//: * `async` est l'abbréviation de asynchrone, cela indique qu'une fonction effectue un travail **potentiellement asynchrone** (on lui en laisse la possibilité)
func fetchString() async -> String {
  /* some code */
  return "async function"
}
/*:
 * De plus, les **fonctions marquées `async` sont généralement (mais pas toujours) marquées `throws`**
 * L'ordre pour la signature est `async throws`, à l'appel c'est `try await` 
 * Cela signifique que *nous attendons qu'un travail potentiellement asynchrone se termine, et quand il se termine, il peut potentiellement générer une erreur*
 * La fonction ci-dessous retourne un `[UIImage]` si tout s'est bien passé autrement elle `throw` une erreur si quelque chose s'est mal passé
 */
func fetchImages() async throws -> [UIImage] {
  /* some code */
  return []
}
/*:
 * **`await` est le mot clé utilisé pour appeller une fonction marquée `async`** – comme `try` pour `throws`
 * `async` et `await` sont les meilleurs amis car l'un ne va jamais sans l'autre, comme `throws` & `try` – *await is awaiting a callback from his buddy async*
 * En utilisant le mot clé `await` on demande à notre programme *d'attendre* le résultat d'une fonction marquée `async` et de ne continuer qu'après l'arrivé d'un résultat ou d'une erreur
 */
func fetchAsyncString() {
  let string = await fetchString()
  print(string)
}
/*:
 * En appellant une fonction marquée `async` dans une fonction *classique*, cela génère une erreur : *'async' call in a function that does not support concurrency*
 * **Cette erreur se produit quand nous essayons d'appeller une fonction `async` dans un environnement d'appel synchrone (qui ne supporte pas la concurrence)**
 * **Une fonction qui appel une ou plusieurs fonction marquées comme `async` doit également être marquée `async` si elle ne gère pas la concurrence grâce à une `Task`**
 * C'est le même raisonnement qu'une fonction qui appelle une `throws` fonction sans gérer le cas d'erreur dans un block `do catch`
 */
func fetchAsyncString() async {
  let string = await fetchString()
  print(string)
}
/*:
 * Si on souhaite que cette fonction ne soit pas marquée comme `async` mais qu'elle appelle tout de même la fonction `fetchString` on peut le faire grâce à une `Task` comme il suit
 * Une `Task` permet d'appeller et de gérer le contexte asynchrone d'une fonction marquée `async` – voir [Structured Concurrency](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Swift%20Concurrency/Structured%20Concurrency.playground)
 */
func fetchAsyncStringWithTask() {
  Task {
    let string = await fetchString()
    print(string)
  }
}
/*:
 * Lorsqu'on appelle une fonction marquée `async throws` plusieurs choix s'offre à nous :
    1. Ne pas gérer le context asynchrone ni la génération d'erreur. **La fonction appellante doit être donc marquée `async throws`**
    2. Gérer la génération d'erreur dans un block `do catch` mais pas le contexte asynchrone. **La fonction appellante doit être seulement marquée comme `async`**
    3. Gérer le contexte asynchrone grâce à une `Task` mais pas la génération d'erreur. **La fonction appellante doit être seulement marquée comme `throws`**
    4. Gérer le contexte asynchrone grâce à une `Task` et la génération d'erreur dans un block `do catch`. **La fonction appellante n'est ni marquée `async` ni `throws`**
 */
// 1.
func fetchAllImages() async throws {
  let images = try await fetchImages()
  print(images)
}

// 2.
func fetchAllImagesAsync() async {
  do {
    let images = try await fetchImages()
    print(images)
  } catch {
    print("Error : ", error.localizedDescription)
  }
}

// 3.
func fetchAllImagesThrows() throws {
  Task {
    let images = try await fetchImages()
    print(images)
  }
}

// 4.
func fetchAllImages() {
  Task {
    do {
      let images = try await fetchImages()
      print(images)
    } catch {
      print("Error : ", error.localizedDescription)
    }
  }
}
//:[Home](Home)           [Next: `async URLSession` >](@next)
