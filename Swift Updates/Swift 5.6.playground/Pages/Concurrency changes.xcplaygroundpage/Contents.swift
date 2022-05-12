import SwiftUI
/*:
 # Concurrency changes
 * Swift 5.5 a ajouté de nombreuses fonctionnalités autour de la *Concurrency* et Swift 5.6 continue le processus d'affinage de ces fonctionnalités pour les rendre plus sûres et cohérentes
 * Cela entraînera des changements plus importants et des **breaking changes avec Swift 6**
 */
/*:
 * [SE-0337](https://github.com/apple/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md) introduit une roadmap pour une vérification complète et stricte de la concurrence dans notre code
 * Cette roadmap est incrémentale :
    * On peut importer des modules entiers en utilisant `@preconcurrency` afin d'indiquer au compilateur que le module a été créé sans tenir compte de la *Concurrency*
    * Ou bien, on peut également marquer individuellement des `class`, `struct`, properties et fonctions et plus avec ce même attribute
 * Cela permettra de faciliter considérablement la migration de grands projets vers la *Concurrency*
 */
@preconcurrency final class Test {}
/*:
 * [SE-0327](https://github.com/apple/swift-evolution/blob/main/proposals/0327-actor-initializers.md) change également l'utilisation des `actor`
 * Swift 5.6 émet désormais un warning lorsqu'on instancie une property `@MainActor` en utilisant `@StateObject`
 */

@MainActor class Settings: ObservableObject {}

struct ContentView: View {

  @StateObject private var settings = Settings()

  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}
/*:
 * *Expression requiring global actor 'MainActor' cannot appear in default-value expression of property '_settings'; this is an error in Swift 6*
 * Ainsi, comme il est mentionné, **ce warning se transformera en une erreur avec Swift 6**
 * Il faudra remplacer le code précédent par celui-ci :
 */
struct NewContentView: View {
  @StateObject private var settings: Settings

  init() {
    _settings = StateObject(wrappedValue: Settings())
  }

  var body: some View {
    Text("Hello, world!")
  }
}
//: [< Previous: `#unavailable`](@previous)           [Home](Home)
