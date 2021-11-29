import Foundation
/*:
 # @MainActor / Global actors – Éxécuter du code sur le main thread
  * Permet d'isoler l'état global des states des datas race en utilisant des `actor`
  * `@MainActor` permet de marquer les propriétés, fonctions et autres qui être uniquement accédé depuis le main thread
  * Principalement pour de la UI
 */
//: * Exemple où on devait checker si on était sur le main thread
final class OldDataController {
  func save() -> Bool {
    guard Thread.isMainThread else { return false }
    print("Saving data...")
    return true
  }
}
//: En utilisant le wrapper `@MainActor`, on garantit que la fonction sera appellé sur le main thread, comme un `DispathchQueue.main.async`
final class NewDataController {
  @MainActor func save() {
    print("Saving data...")
  }
}
//: On peut également marqué une `class` comme étant `@MainActor`, indiquant que tout sera exécuté sur le main thread
@MainActor final class DataController {
  func save() {
    print("Saving data...")
  }
}
//: Remarque : puisque `@MainActor` est un `actor`, lorsqu'on appellera la fonction `save` cela devra se fait en utilisant `await`, `async let` ou similaires
/*:
 * `@MainActor` est un wrapper d'`actor` global, qui est la struct MainActor.
 * Très utile, car cette même struct définie une fonction statique `run` qui permet d'exécuter du code sur le main thread
 */
final class Foo {

  func onMainThread() async {
    await MainActor.run {
      print("Saving data...")
    }
  }
}
//: [< Previous: `actors`](@previous)           [Home](Home)           [Next: `Sendatable` protocol & `@Sendable` >](@next)
