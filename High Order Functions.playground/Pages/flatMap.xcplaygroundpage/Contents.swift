/*:
 # FlatMap
 * Permet de concaténer plusieurs `Sequence` entre elles
 * Réduit d'une dimension la `Sequence` *"mère"*
 * Retourne le **même type** que celui de la `Sequence` avec une dimension en moins
 */
//: Avec des données *primitives*
//: * `flatMap` pour obtenir un `Array` à une seule dimension, `return [Int]`
let deuxDimensions: [[Int]] = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]
let uneDimension = deuxDimensions.flatMap { $0 }
//: * `flatMap` pour obtenir un `Array` à une seule dimension, `return [Int]`
let troisDimensions: [[[Int]]] = [
[ [1, 2, 3],
  [4, 5, 6] ],
[ [1, 2, 3],
  [4, 5, 6] ]
]
let oneDimension = troisDimensions.flatMap { $0.flatMap { $0 } }
let oneDimensionBis = troisDimensions.flatMap { $0 }.flatMap { $0 }
//: Avec des données *non primitives*
struct Store {
  let name: String
  let hardware: [String]
}
let stores = [Store(name: "store 1", hardware: ["iPhone", "iPad", "Apple TV"]),
              Store(name: "store 2", hardware: ["MacBook", "MacBook Pro", "Mac Pro"]),
              Store(name: "store 3", hardware: [])]
//: * `flatMap` pour les `hardware` dans un tableau unique, `return [String]`
let hardwares = stores.flatMap { $0.hardware }


let somthing = [1, 2, 3, 4, 5]
//: [< Previous: `compactMap`](@previous)           [Home](Introduction)           [Next: `contains` >](@next)
