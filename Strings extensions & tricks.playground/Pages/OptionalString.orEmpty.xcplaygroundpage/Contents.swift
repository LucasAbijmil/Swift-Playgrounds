import Foundation
/*: ### optionalString.orEmpty : Encapsuler la logique d'unwrap pour les `Optional String`
 * Extension sur les `Optional` où l'optionnel est une `String`
 * Gain en readability – évite des `nil coalscing`
 * `Optional` : **enum avec deux case**
    * `.some(let value)`
    * `.none`
 */
extension Optional where Wrapped == String {

  var orEmpty: String {
    switch self {
    case .some(let value):
      return value
    case .none:
      return ""
    }
  }
}

//: Exemple d'utilisation
var name: String? = "Lucas"
func someBussinessLogic(for name: String) {
  print(name)
}

//: * Sans l'utilisation de l'extension – nil coalscing
someBussinessLogic(for: name ?? "")

//: * Avec l'utilisation de l'extension
someBussinessLogic(for: name.orEmpty)

//: [Home](Introduction)           [Next: Custom `String Interpolation` >](@next)
