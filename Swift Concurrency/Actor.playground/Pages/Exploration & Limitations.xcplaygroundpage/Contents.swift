import SwiftUI
/*:
 # Exploration & limitations des actors
 */
/*:
 * Avec les `actor` **nous ne savons pas quand l'accès à une `property` mutable est *autorisé***, il y deux use cases possible :
    * **Si aucun thread n'accède à cette donnée, nous y aurons directement accès (sans attendre)**
    * **Si un thread est actuellement en train d'accéder à cette donnée, nous devons attendre jusqu'à ce que cet accès soit de nouveau possible**
 */
actor BunnyFeeder {
  let food = "carrot"
  var numberOfEatingBunny: Int
  
  init(numberOfEatingBunny: Int) {
    self.numberOfEatingBunny = numberOfEatingBunny
  }
  
  func bunnyStartsEating() {
    numberOfEatingBunny += 1
  }
  
  func bunnyStopEating() {
    numberOfEatingBunny -= 1
  }
}
let bunnyFeeder = BunnyFeeder(numberOfEatingBunny: 0)
Task {
  await bunnyFeeder.bunnyStartsEating()
  let numberOfEatingBunny = await bunnyFeeder.numberOfEatingBunny
  print(numberOfEatingBunny) // ou print(await bunnyFeeder.numberOfEatingBunny)
}
/*:
 * Dans l'exemple ci-dessus, on **accède à deux parties distinctes de notre `actor`** :
    * On met à jour le nombre de lapin en train de manger, via `bunnyStartsEating()`
    * On accède à la `property numberOfEatingBunny` qui est mutable puisque c'est une `var`
 * Chacune de ces attentes, marquée par `await`, **peut entraîner une suspension de notre code pour attendre l'accès à la ressource demandée**
 * **⚠️ On doit tenir compte qu'un autre thread pourrait avoir accès à cette `property` entre ces deux opérations ⚠️**
    * Si c'est le cas alors `numberOfEatingBunny` pourrait être potentiellement faux au moment où on le print
 */
/*:
 * Combinons deux opérations en une seule méthode pour éviter des suspensions supplémentaires, via `await`
 * Imaginons que notre `actor` possède une fonction de notification qui informe des observers qu'un nouveau lapin a commencé à manger, comme il suit
 */
actor BunnnyFeeder {
  let food = "carrot"
  var numberOfEatingBunny: Int
  
  init(numberOfEatingBunny: Int) {
    self.numberOfEatingBunny = numberOfEatingBunny
  }
  
  func bunnyStartsEating() {
    numberOfEatingBunny += 1
    notifyObservers()
  }
  
  func bunnyStopEating() {
    numberOfEatingBunny -= 1
    notifyObservers()
  }
  
  func notifyObservers() {
    NotificationCenter.default.post(name: .init(rawValue: "bunny.started.eating"), object: numberOfEatingBunny)
  }
}
/*:
 * **Au sein d'un même `actor` l'accès est déjà synchronisé, il n'y a donc pas besoin d'utiliser `await` lorsqu'une `method` appelle une autre `method` du même `actor`**
 * Ces améliorations sont à prendre en compte car elles **peuvent avoir un réel impact sur les résultats & les perfomances attendus**
 */
//: [< Previous: Exemple d'implémentation d'un `actor`](@previous)           [Home](Home)           [Next: `actor` isolation >](@next)
