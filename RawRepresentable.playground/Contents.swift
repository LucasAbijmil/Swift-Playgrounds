import Foundation
/*:
 # Protocol RawRepresentable
 * Permet de storer une valeur sous-jacente au sein d'un type (plus bas niveau que le type lui-même)
 * Cette propriété / valeur est nommé `rawValue` (de la même manière qu'une `enum` avec une `rawValue`)
 * *Requierement du protocol* : implémentation d'une propriété nommé `rawValue` du **type que l'on souhaite**
 */
//: Création d'une `enum` dont la `rawValue` est de type `String`
enum Numbers: String {
  case zero
  case one
}
//: Accès à la `rawValue` de chaque cas
Numbers.zero.rawValue
Numbers.one.rawValue
/*:
 Création d'une `struct` conforme au protocol `RawRepresentable`
 * Conformance au protocol grâce à la propriété `rawValue`, ici de type `String`
 */
struct LocalizedKey: RawRepresentable {
  var rawValue: String

  var localizedString: String {
    return NSLocalizedString(rawValue, comment: "")
  }

  // MARK: Utile pour faire de la data validation lors de l'init
  /*init?(rawValue: String) {
    // Bussiness logic here
  }*/
}
/*:
 Avantage par rapport à une `enum` qui a une `rawValue` :
 * Pour une `enum` tous les cas doivent être listés dans la déclaration de l'`enum`. Les `enum` ont besoin d'être exhaustive (type safety)
 * Tandis qu'avec un type conforme à `RawRepresentable` n'a pas besoin d'être exhaustif, car il y a peu de chance qu'on ai besoin de switcher sur tous les cas de ce type (ici `LocalizedKey`)
 * À l'inverse on veut garder le `type safety` du type et avoir accès à sa `rawValue` lorsqu'on en a besoin
 */
//: De plus on peut définir nos cas dans une extension, ce qui n'est pas possible avec une `enum`
extension LocalizedKey {
  static let firstScreenTitle = LocalizedKey(rawValue: "first.screen.title")
}

extension LocalizedKey {
  static let secondScreenTitle = LocalizedKey(rawValue: "second.screen.title")
}

LocalizedKey.firstScreenTitle.localizedString
LocalizedKey.secondScreenTitle.localizedString
//: Ressemble de très près (100 %) à la déclaration lorsqu'on accède à la `rawValue` d'une `enum`
LocalizedKey.firstScreenTitle.rawValue
LocalizedKey.secondScreenTitle.rawValue
