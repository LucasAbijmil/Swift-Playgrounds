import Foundation
/*:
 # Enum non conforme à RawRepresentable peuvent être Codable sans extra work
 * Avant cela on devait (voir [Enum Extensions & tricks](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Enum%20extensions%20%26%20tricks.playground)) :
    * Déclarer une enum conforme au protocol `CodingKey`
    * Déclarer une enum conforme au protocol `Error`
    * Ajouter l'init pour être conforme à `Decodable`
    * Ajouter la fonction `encode(to:)` pour être conforme à `Encodable`
 */
//: * Exemple d'une `Enum` sans `RawValue` et sans associated values
enum Device: Codable {
  case phone
  case pad
  case watch
  case tv
  case computer
}
//: * Exemple d'une `Enum` sans `RawValue` et avec associated values
enum Weather: Codable {
  case sun
  case wind(speed: Int)
  case rain(amount: Int, chance: Int)
}
//: [< Previous: Extending static member lookup](@previous)           [Home](Home)
