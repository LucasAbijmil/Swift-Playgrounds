import Foundation
//: ### Création d'une custom `String Interpolation`
struct User {
  let firstName: String
  let lastName: String
}

let user = User(firstName: "Lucas", lastName: "Abijmil")

//: String Interpolation pour utiliser le prénom & nom du user (classique)
print("My name is \(user.firstName) \(user.lastName)")

/*: Si la même string revient souvent avec les mêmes arguments d'interpolations :
 * Implémentons une custom String Interpolation qui nous facilitera la vie

 **Extension sur le type `String.StringInterpolation` via la fonction `appendInterpolation` (convention)**
 */

extension String.StringInterpolation {
  mutating func appendInterpolation(userPresented: User) {
    appendInterpolation("My name is \(userPresented.firstName) \(userPresented.lastName)")
  }
}

//: Exemple d'utilisation :
print("\(userPresented: user)")


//: [< Previous: `optionalString.orEmpty`](@previous)           [Home](Introduction)           [Next: `Localized String` with `String Interpolation` >](@next)
