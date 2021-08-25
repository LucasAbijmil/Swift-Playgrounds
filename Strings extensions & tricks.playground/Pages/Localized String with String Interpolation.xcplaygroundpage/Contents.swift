import Foundation
/*:
 ### Utilisation d'une `Localized String` via `String Interpolation` pouvant prendre des paramètres
 * En rapport avec les [Customs String Interpolation](@previous)
 * **Extension sur le type `String.StringInterpolation` via la fonction `appendInterpolation` (convention)**
 */
extension String.StringInterpolation {
  mutating func appendInterpolation(localized key: String, _ args: CVarArg...) {
    let localized = String(format: NSLocalizedString(key, comment: ""), arguments: args)
    appendLiteral(localized)
  }
}

/*: Exemple d'utilisation pour une `Localized String` sans paramètre :
 * "welcome.screen" = "Bienvenue sur notre application !"
 */

print("\(localized: "welcome.screen")")

/*: Exemple d'utilisation pour une `Localized String` avc paramètre :
 * "welcome.screen.greetings" = "Hello %@ !", où %@ = format pour une string
 * Résultat : "Hello Lucas !"
 */

struct User {
  let firstName: String
}
let user = User(firstName: "Lucas")

print("\(localized: "welcome.screen.greetings", user.firstName)")
//: [< Previous: Custom `String Interpolation`](@previous)           [Home](Introduction)           [Next: `StaticString` & `URL init` custom>](@next)
