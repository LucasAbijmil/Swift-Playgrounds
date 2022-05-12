import Foundation
/*:
 # CodingKeyRepresentable
 * [SE-0320](https://github.com/apple/swift-evolution/blob/main/proposals/0320-codingkeyrepresentable.md) introduit un nouveau protocol `CodingKeyRepresentable`
 * `CodingKeyRepresentable` permet aux dictionnaires dont la clé n'est pas une `String` ou un `Int` d'être encodé en tant que conteneurs à clé plutôt qu'en tant que conteneurs sans clé (array)
 */
/*:
 * Avant de voir l'intérêt de ce protocol, regardons d'abord le comportement sans `CodingKeyRepresentable` en place
 * Prenons des cas d'une `enum` en tant que clés d'un dictionnaire et on encode ce dictionnaire
 */
enum OldSettings: String, Codable {
  case name
  case twitter
}
let oldDict: [OldSettings: String] = [.name: "Lucas", .twitter: "@Lucas"]
let oldData = try JSONEncoder().encode(oldDict)
print(String(decoding: oldData, as: UTF8.self))
/*:
 * Bien que l'`enum` ait une `String` en tant que `rawValue`, comme les clés du dictionnaires ne sont pas des `String` ou des `Int`, on obtient le résultat suivant : `["name","Lucas","twitter","@Lucas"]`
 * C'est-à-dire qu'on obtient quatres `String` séparées (`[String]`), plutôt que quelque chose qui est de la forme clé/valeur (JSON classique)
 * Swift est suffisament intelligent pour **reconnaître cela lors du décodage**, et fera bien correspondre les cas grâce à la `rawValue`, **mais pas pour l'encoding**
 */
/*:
 * Ainsi, `CodingKeyRepresentable` **résout ce problème lors de l'encoding, permettant aux clés de dictionnaires d'être écrites correctement afin d'avoir des clé/valeur**
 * **⚠️ Warning : comme cela change la façon dont le JSON est généré, nous devons expliciter la conformité à `CodingKeyRepresentable` pour obtenir le nouveau comportemment**, comme il suit :
 */
enum NewSettingsSettings: String, Codable, CodingKeyRepresentable {
  case name
  case twitter
}
let newDict: [NewSettingsSettings: String] = [.name: "Lucas", .twitter: "@Lucas"]
let newData = try JSONEncoder().encode(newDict)
print(String(decoding: newData, as: UTF8.self))
/*:
 * Grâce à cela, on obtient donc le résultat suivant : `{"name":"Lucas","twitter":"@Lucas"}`, ce qui est bien plus utile
 * **Remarque** : si nous utilisons des `struct` customs comme clés, nous pouvons aussi les faire conformer à `CodingKeyRepresentable` et fournir nos propres méthodes pour convertir nos `Data` en `String`
 */
//: [< Previous: `Type placeholders`](@previous)           [Home](Home)           [Next: `#unavailable` >](@next)
