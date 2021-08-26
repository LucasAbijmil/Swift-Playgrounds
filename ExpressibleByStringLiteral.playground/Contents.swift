import Foundation
/*:
 # Protocol ExpressibleByStringLiteral
 * Permet de créer un objet de n'importe quel type à partir d'une `String`
 * Doit obligatoirement implémenter `init(stringLiteral value: StringLiteralType)` :
    * Le type de value peut être n'importe lequel du moment qu'il s'agit d'une `String` :
    * String, StaticString...
 */
//: Exemple avec `URL`, pour créer une `URL` sans avoir à force unwrap à chaque fois
extension URL: ExpressibleByStringLiteral {

  public init(stringLiteral value: String) {
    self.init(string: value)!
  }
}
//: On peut maintenant déclarer une `URL` grâce à une `String` en le précisant au compilateur (autrement ça sera une `String`)
let url: URL = "https://www.google.com"
let otherUrl = URL(stringLiteral: "https://www.google.com")
let notUrl = "https://www.google.com"
print(type(of: url))
print(type(of: otherUrl))
print(type(of: notUrl))
//: Exemple avec un type custom
struct User {
  let name: String
  let age: Int
}
//: Ajout de la conformance au protocol `ExpressibleByStringLiteral` grâce à l'implémentation de l'init
extension User: ExpressibleByStringLiteral {

  init(stringLiteral value: String) {
    self.init(name: value, age: 0)
  }
}

let user: User = "David"
let secondUser = User(stringLiteral: "Marc")
print(user.name, user.age)
print(secondUser.name, secondUser.age)
