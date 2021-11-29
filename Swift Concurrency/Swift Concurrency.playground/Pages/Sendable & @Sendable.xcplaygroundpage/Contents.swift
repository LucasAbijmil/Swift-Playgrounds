import Foundation
/*:
 # Sendable protocol & @Sendable fonctions – Permet de transmettre des données à un autre thread
 * Le type peut être utilisée en tout sécurité dans un code concurrent c'est à dire dans un contexte asynchrone

 */
/*:
 * Beaucoup de types sont par défaut conformes à `Sendable` et donc sûres à être envoyés à d'autres threads :
    * Tous les core types de Swift : `Bool`, `Int`, `String` ...
    * `Optional` lorsque la `Wrapped` value est une value type
    * Les `Collection` qui contiennent des value type
    * Les tuples où les élément sont des value type
 * Pour les custom types cela dépend :
    * Les `actor` et types conforme au protocol `Actor` sont automatiquement conforme à `Sendable` car ils gèrent leur synchronisation en interne
    * Les customs structs et enums seront automatiquement conformes à `Sendable` s'ils ne contiennent que des types conformes eux-mêmes à `Sendable`, de la même manière que pour la conformance à `Codable`
    * Les customs class peuvent être conformes à `Sendable` :
      * Hérite soit de `NSObject` soit de rien
      * Toutes les properties sont des constantes, leurs types conforme à `Sendable` et qu'elles soient marquées comme `final` pour ne pas faire hériter
 */
/*:
 * L'attribut `@Sendable` est utilisé pour des fonctions ou closures afin d'indiquer qu'elles travaillent dans un contexte de concurrence
    * Par exemple la closure d'une `Task` est marquée comme `@Sendable` : `init(priority: TaskPriority? = nil, operation: @escaping @Sendable () async -> Success)` (voir [Structured Concurrency](Structured%20Concurrency))
    * De manière générale les closures marquées `@Sendable` sont également `@escaping` car la tâche pourrait y accéder pendant qu'une autre modifie sa valeur
 */
func runLater(_ function: @escaping @Sendable () -> Void) -> Void {
  DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: function)
}
//: [< Previous: `@MainActor`](@previous)           [Home](Home)   
