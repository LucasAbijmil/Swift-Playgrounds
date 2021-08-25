/*:
 # CompactMap
 * Permet d'unwrap les optionnels, supprimant les éléments `nil` d'une `Sequence`
 * Peut permettre de faire des transformations de type
 * Très puissant pour matcher un `case` d'une `Enum` et retourner `nil` pour les cas qui ne nous intéresse pas
 * Return une `Sequence` du **même type** que celui de la transformation (ou de la `Sequence` de base si pas de transformation)
 */
//: Avec des données *primitives*
let array = [1, 2, nil, nil, nil, 3, nil, 4, 5, nil, nil, 6, 7, 8, nil, 9, nil, 10]
//: * `compactMap` pour supprimer les éléments `nil` de l'`Array [Int?]`, `return : [Int]`
let elementNotNil = array.compactMap { $0 }
/*:
 * `compactMap` pour transformer `[String]` en `[Int]`, `return [Int]`
    * Pour chaque élément de la `Sequence` on a la chose suivante :
    * `String` ––> `Int?` (cast) ––> retourne `Int` ou `nil` et est donc supprimé
 */
let strings = ["1", "deux", "trois", "4", "5", "6", "sept", "huit", "9", "10"]
let intElements = strings.compactMap { Int($0) }
//: Avec des données *non primitives*
struct Store {
  let name: String
  var hardware: String?
}
let stores = [Store(name: "store 1", hardware: "Apple TV"),
              Store(name: "store 2", hardware: "MacBook"),
              Store(name: "store 3", hardware: "iPhone"),
              Store(name: "store 4", hardware: nil)]
//: * `compactMap` pour obtenir les hardwares sans optionnel, `return [String]`
let hardwares = stores.compactMap { $0.hardware }
//: * Exemple pour matcher un unique `case` d'une `Enum`
enum Footballeur {
  case gardient(String)
  case defenseur(Double)
  case milieu(Bool)
  case attaquant(Int)
}
let footballeurs: [Footballeur?] = [.gardient("Navas"), .gardient("Lloris"), nil,
                                    .defenseur(10.3), .defenseur(12.9), nil,
                                    .milieu(false), .milieu(true), nil,
                                    .attaquant(9), .attaquant(27), nil]
/*:
 * `compactMap` pour obtenir l'`associated value` pour les attaquants, les autres postes sont ignorés, `return [Int]`
    * Pour chaque élément de la `Sequence` on a la chose suivante :
    * On match le cas `attaquant` et on retourne son numéro, autrement on retourne `nil` et est donc supprimé
 */
let numeroAttaquants: [Int] = footballeurs.compactMap {
  if case .attaquant(let numero) = $0 {
    return numero
  } else {
    return nil
  }
}
//: [< Previous: `reduce`](@previous)           [Home](Introduction)           [Next: `flatMap` >](@next)
