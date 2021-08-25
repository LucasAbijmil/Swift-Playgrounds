import Foundation
/*:
 # Rendre une `enum` conforme au protocol `Codable`
 * Rappel : `Codable` = `Decodable & Encodable`
 */

/*:
 ## `Enum` avec `RawValue` :
 * Depuis Swift 5 les `enum` avec `RawValue` sont par défaut conforme au protocol `Codable`
 */
enum Direction: String, Codable {
  case north
  case south
  case east
  case west
}
//: ## `Enum` sans `RawValue` et `associated value`
//: * *Step 1* : Déclaration de l'`enum`
enum Action {
  case run
  case walk
  case gym
  case talk
}
//: * *Step 2* : Rendre l'`enum` conforme au protocol `Codable`
extension Action: Codable {
/*:
   Déclaration d'une `enum` de type `CodingKey`, stockant les clés d'encodage et de décodage
   * Déclaration d'un unique cas, qui est ni plus ni moins qu'une `RawValue` mais non exposée
   * Ici, `rawValue` correspond à la n-ième position du cas
   */
  enum CodingKeys: CodingKey {
    case rawValue
  }
//: Déclaration d'une `enum` pour la gestion des erreurs (un unique cas d'erreur est suffisant)
  enum CodingError: Error {
    case uknown(String)
  }
/*:
   Rendre l'`enum` conforme au protocol `Decodable`
   * `container` : permet d'accéder à l'unique *clé de décodage* (le cas de l'`enum` conforme à `CodingKey`)
   * `switch` sur sa value et on assigne le bon cas en fonction
 */
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let rawValue = try container.decode(Int.self, forKey: .rawValue)
    switch rawValue {
    case 0:
      self = .run
    case 1:
      self = .walk
    case 2:
      self = .gym
    case 3:
      self = .talk
    default:
      throw CodingError.uknown("Quelque chose s'est mal passé durant le décodage")
    }
  }
/*:
   Rendre l'`enum` conforme au protocol `Encodable`
   * `container` : permet d'accéder à l'unique *clé d'encodage* (le cas de l'`enum` conforme à `CodingKey`)
   * On passe la position du cas pour la valeur d'encodage
 */
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .run:
      try container.encode(0, forKey: .rawValue)
    case .walk:
      try container.encode(1, forKey: .rawValue)
    case .gym:
      try container.encode(2, forKey: .rawValue)
    case .talk:
      try container.encode(3, forKey: .rawValue)
    }
  }
}
//: ## `Enum` avec `associated values` mais sans `RawValue`
//: * *Step 1* : Déclaration de l'`enum`
enum Footballeur {
  case gardient(name: String)
  case defenseur(km: Double)
  case milieu(isRecup: Bool)
  case attaquant(numero: Int)
}
//: * *Step 2* : Rendre l'`enum` conforme au protocol `Codable`
extension Footballeur: Codable {
/*:
   Déclaration d'une `enum` de type `CodingKey`, stockant les clés d'encodage et de décodage
   * Déclaration de chaque cas de l'`enum` mais sans le tuple des `associated types`
   */
  enum CodingKeys: CodingKey {
    case gardient
    case defenseur
    case milieu
    case attaquant
  }
//: Déclaration d'une `enum` pour la gestion des erreurs (un unique cas d'erreur est suffisant)
  enum CodingError: Error {
    case uknown(String)
  }
/*:
   Rendre l'`enum` conforme au protocol `Decodable`
   * `container` : permet d'accéder aux *clé de décodage* (les cas de l'`enum` conforme à `CodingKey`)
   * Principe : On essaye de decoder le tuple correspondant aux `associated values`
   * Si réussis alors on assigne et `return`, autrement `throw` une erreur
 */
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let name = try? container.decode(String.self, forKey: .gardient) { self = .gardient(name: name); return }
    else if let km = try? container.decode(Double.self, forKey: .defenseur) { self = .defenseur(km: km); return }
    else if let isRecup = try? container.decode(Bool.self, forKey: .milieu) { self = .milieu(isRecup: isRecup); return }
    else if let numero = try? container.decode(Int.self, forKey: .attaquant) { self = .attaquant(numero: numero); return }
    throw CodingError.uknown("Quelque chose s'est mal passé durant le décodage")
  }
/*:
   Rendre l'`enum` conforme au protocol `Encodable`
   * `container` : permet d'accéder aux *clé d'encodage* (les cas de l'`enum` conforme à `CodingKey`)
   * On passe le tuple pour la valeur d'encodage et la clé correspondant au cas associé
 */
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .gardient(let name):
      try container.encode(name, forKey: .gardient)
    case .defenseur(let km):
      try container.encode(km, forKey: .defenseur)
    case .milieu(let isRecup):
      try container.encode(isRecup, forKey: .milieu)
    case .attaquant(let numero):
      try container.encode(numero, forKey: .attaquant)
    }
  }
}

//: [< Previous: `for case` pattern matching](@previous)           [Home](Introduction)           [Next: `indirect enum` >](@next)
