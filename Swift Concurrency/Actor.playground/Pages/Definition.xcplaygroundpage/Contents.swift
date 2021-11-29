import SwiftUI
/*:
 # Définition d'un actor
 */
/*:
 * Les `actor` **protègent leurs données mutables** (`property` marquée en tant que `var`) contre les Data Races en ayant toute cette logique de *verrou sous-jacent de protection* built-in (cachée par Swift)
 * Cela permet d'**empêcher l'accès simultané aux données mutables** et donc d'éviter d'introduire des Datas Races
 * Le compilateur applique statiquement les limitations qui accompagnent les `actor` permettant de créer des erreurs à la compilation :
    * Il peut par exemple forcer un accès synchronisé, ce qui empêche d'introduire des Datas Races dans la majorité des cas
 */
/*:
 * `actor` est un **nouveau concrete nominal type** en Swift comme les `struct`, `class` et `enum` :
    * Il peut ainsi être composé de : `properties`, `inits`, `methods` et `subscripts`
    * Les `static property` et `static method` n'ont pas de concept de `self` et ne sont donc pas isolées
 * Un `actor` est une **reference type** c'est à dire que c'est un objet avec une **adresse mémoire** (comme une `class`)
 * Ils peuvent être **conformes à des protocoles et supportent l'utilisation de génériques**
 * Les `actor` sont **implicitement conformes** au protocol `Actor`. Cela permet de restreindre les protocols via la POP (*Protocol Oriented Programming*)
 */
/*:
 * **La responsabilité d'un `actor` est d'isoler l'accès à ses données mutables**
 * Ainsi, **les *stored properties* peuvent être lues mais pas setter à l'extérieur de la définition de l'`actor`**
 * Tous les accès à un `actor` sont **synchronisés dans une File FIFO** (*First In First Out*), ce qui implique qu'**un `actor` travaille de manière sérialisée**
 * Ainsi dès qu'on souhaite **lire la valeur d'une `property` ou appeller** une `method` d'un `actor`, cela devra se faire dans un **contexte asynchrone** c'est à dire que cet **appel devra être précédé de mot clé `await`**
 */
/*:
 * Bonus : Swift optimise les accès synchronisés autant que possible
 */
actor CatFeeder: Actor {
  let food = "kibble"
  var numerOfEatingCats: Int
  
  init(numerOfEatingCats: Int) {
    self.numerOfEatingCats = numerOfEatingCats
  }
  
  func catStartsEating() {
    numerOfEatingCats += 1
  }
  
  func catStopsEating() {
    numerOfEatingCats -= 1
  }
}
//: * Exemple d'un protocol restreint au protocol `Actor` (même fonctionnement que les protocols restreints à `AnyObject` pour les `class`)
protocol WhatEverProtocol: Actor {}
/*:
 * Bien que les `actor` soient des references types, ils **ne supportent pas l'héritage** à l'inverse des `class` (sauf à `NSObject`)
 * Cela veut dire que les mots clés suivants ne seront jamais utilisés au sein de la définition d'un `actor` :
    * `final actor`
    * `convenience init` & `required init`
    * `override func`
    * `open`
 */
actor MainFeeder {}
actor Feeder: MainFeeder {} // Error : Actor types do not support inheritance
//: [< Previous: Quel problème résout l'utilisation des `actor` ?](@previous)           [Home](Home)           [Next: Exemple d'implémentation d'un `actor` >](@next)
