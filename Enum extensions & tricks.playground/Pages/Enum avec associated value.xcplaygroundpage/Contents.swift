import Foundation
/*:
 ## Création d'une `enum` avec **associated values** :
 * Les `associated values` sont considérées comme un tuple
 * On peut donc les préfixer par un label (rajoute du context)
 */
//: `Associated values` non préfixées
enum Mediaa {
  case book(String, String, Int)
  case movie(String, String, Int)
  case website(String, URL)
}
//: `Associated values` préfixées
enum Media {
  case book(title: String, author: String, year: Int)
  case movie(title: String, director: String, year: Int)
  case website(title: String, url: URL)
}

//: [< Previous: `enum` sans `associated value`](@previous)           [Home](Introduction)           [Next: `switch` pattern matching >](@next)
