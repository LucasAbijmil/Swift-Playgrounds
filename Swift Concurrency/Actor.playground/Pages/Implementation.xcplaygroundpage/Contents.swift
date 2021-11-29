import SwiftUI
/*:
 # Exemple d'implémentation d'un actor
 */
//: * L'implémentation d'un `actor` est **beaucoup plus facile** que celle d'une `class` qui doit gérer elle même les accès à ses données mutables
actor DogFeeder {
  let food = "kibble"
  var numberOfEatingDogs: Int
  
  init(numberOfEatingDogs: Int) {
    self.numberOfEatingDogs = numberOfEatingDogs
  }
  
  func dogStartsEating() {
    numberOfEatingDogs += 1
  }
  
  func dogStopEating() {
    numberOfEatingDogs -= 1
  }
}
let dogFeeder = DogFeeder(numberOfEatingDogs: 0)
//: * Lorsqu'on accède à une `property` mutable ou appellons une `method` d'un `actor` cela doit se faire dans un **context asynchrone : l'appel doit être précédé du mot clé `await`** (voir [Définition d'un actor](Definition))
dogFeeder.dogStartsEating() // Error: Actor-isolated instance method 'dogStartsEating()' can not be referenced from a non-isolated context
dogFeeder.dogStopEating() // Error: Actor-isolated instance method 'dogStopEating()' can not be referenced from a non-isolated context
dogFeeder.numberOfEatingDogs // Error: Actor-isolated property 'numberOfEatingDogs' can not be referenced from a non-isolated context
//: * Obligé de wrapper ce code dans une `Task` car les playgrounds ne supportent pas le context asynchone au top level
Task {
  await dogFeeder.dogStartsEating()
  await dogFeeder.dogStopEating()
  await dogFeeder.numberOfEatingDogs
}
//: * On peut **accéder aux constantes d'un `actor` sans être dans un context asynchone car une constante est immutable et est donc *thread safe***. Aucun risque d'introduire des Data Races
dogFeeder.food
//: [< Previous: Définition & utilisation d'un `actor`](@previous)           [Home](Home)           [Next: Exploration & limitations des `actor` >](@next)
