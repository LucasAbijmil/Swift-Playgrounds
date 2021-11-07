import Foundation
/*:
 # Actors – Remplace les class dans un environnement concurrents
 * Swift garantit que l'état mutable à l'intérieur de notre actor n'est acccessible que par un seul thread
 * Permet d'éliminer un certains nombre de bugs potentiels
 */
/*:
 * Dans un contexte multi-threads cette class a une `race condition` potentielle : 
    * Si la fonction `send(card:, to:)` est appellé plusieurs fois alors on peut transférer la carte plusieur fois
 */
final class RiskyCollector {
  var deck: Set<String>

  init(deck: Set<String>) {
    self.deck = deck
  }

  func send(card selected: String, to person: RiskyCollector) -> Bool {
    guard deck.contains(selected) else { return false }

    deck.remove(selected)
    person.transfer(card: selected)
    return true
  }

  func transfer(card: String) {
    deck.insert(card)
  }
}
/*:
 * Les `actor` résoudent ce problème grâce à l'*actor isolation* :
    * Les stored properties peuvent être lues à l'extérieur de manière asynchrone mais pas setter
    * Les fonctions doivent être exécutés de manière asynchrone à l'extérieur
 * Notre `class RiskyCollector` devient alors un `actor SafeCollector`
 */
actor SafeCollector {
  var deck: Set<String>

  init(deck: Set<String>) {
    self.deck = deck
  }

  func transfer(card: String) {
    deck.insert(card)
  }

  func send(card: String, to collector: SafeCollector) async -> Bool {
    guard deck.contains(card) else { return false }

    deck.remove(card)
    await collector.transfer(card: card)
    return true
  }
}
/*:
 * Plusieurs choses à remarquer :
    * `actor` est un nouveau concrete nominal type en Swift comme les struct, class et enum
    * La fonction `send(card:, to:)` doit être marquée `async` car elle suspendra son travail en attentant que le `transfert(card:)` soit terminée
    * La fonction `transfert(card:)` bien que non marquée `async` doit être appellé avec `await` car elle attendra que l'autre `actor` soit en mesure d'exéuter la demande
 */
/*:
 * En conclusion :
    * Un `actor` peut utiliser ses properties et méthodes librement de manière asynchrone ou non
    * Dès lors qu'un `actor` intéragie avec un autre `actor`, alors toutes les intéractions doivent être faites de manière asynchrone
    * Grâce à cela Swift s'assure que les états d'un `actor` ne soit jamais accédés de manière simultanée mais plutôt comme une file FIFO. Fait à la compilation pour plus de sécurité
 */
/*:
 * Similitudes entre `actor` et `class` :
    * Les deux sont des références types
    * Les deux peuvent avoir des methods, properties, initializers et subscripts
    * Les deux peuvent se conformer à des protocols et être générique
    * Les static properties et methods se comportent de la même manière, elles n'ont pas de concept de self et ne sont donc pas isolées
 */
/*:
 * Différences entre `actor` et `class` :
    * Les `actor` ne supportent pas l'héritage à l'instar des `class`, donc pas de `convenience init` ni de `final`. Cela pourrait portentiellement changé dans le futur
    * Les `actor` sont implicitement conformes au protocol `Actor`. Cela permet de restreindre certains protocol via la POP
 */
/*:
 * `actor` vs `class` : Les `actor` transmettent des messages, pas de la mémoire. À la place de modifié la propriété directement, on envoie un message dans une file FIFO et Swift va les gérer pour nous en toute sécurité
 */
/*:
 * Restreindre un protocol pour être utilisé avec des `actor`
 */
protocol Foo: Actor {
  func foo()
}
actor Fooo: Foo {

  func foo() { }
}
//: [< Previous: Structured Concurrency](@previous)           [Home](Home)           [Next: `@MainActor` >](@next)
