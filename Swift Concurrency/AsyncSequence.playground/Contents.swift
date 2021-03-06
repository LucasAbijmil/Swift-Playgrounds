import SwiftUI
/*:
 # AsyncSequence – Un protocol qui permet un accès asynchrone, séquentiel et d'itérer sur une Sequence
 * Principalement utilisé pour des valeurs dans une séquence disponible asynchroniquement
 */
/*:
 * `AsyncSequence` est assez similaire à `Sequence` :
 * Notre type doit être conforme à `AsyncSequence` & `AsyncIteratorProtocol`
 * La méthode `next()` doit être marquée `async`
 * Si on retire le `async`, on a une `Sequence` valide faisant la même chose
 */
struct DoubleGenerator: AsyncSequence {
  typealias Element = Int

  struct AsyncIterator: AsyncIteratorProtocol {
    var current = 1

    mutating func next() async -> Int? {
      defer { current &*= 2 }

      if current < 0 {
        return nil
      } else {
        return current
      }
    }
  }

  func makeAsyncIterator() -> AsyncIterator {
    return AsyncIterator()
  }
}
//: * Grâce à `AsyncSequence`, on peut looper en utilisant `for await` dans un contexte asynchrone
func printAllDoubles() async {
  for await number in DoubleGenerator() {
    print(number)
  }
}
//: * De plus `AsyncSequence` fournit des implémentations par défaut pour les fonctions `map()`, `compactMap()`, `allSatisfy()` et plus
//: * Par exemple on peut vérifier si l'output de notre générateur est un nombre spécifique, comme il suit
func containsExactNumber() async {
  let doubles = DoubleGenerator()
  let match = await doubles.contains(16_777_216)
  print(match)
}
