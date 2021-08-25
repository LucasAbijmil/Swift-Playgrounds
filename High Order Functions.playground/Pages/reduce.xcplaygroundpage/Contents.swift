/*:
 ## Reduce :
 * Combine tous les éléments d'une `Sequence` dans une valeur et la retourne, qui peut être de n'importe quel type
 * Fonction qui prend deux paramètres :
    * `initialResult` : la valeur de départ, premier paramètre de la fonction
    * `nextPartialResult` : closure qui applique une opération en utilisant l'`initialResult` ($0) et un élément de la `Sequence` ($1)
 * Principalement utilisé pour des opérations arithmétiques
 */
//: Avec des données *primitives*
let array = [1, 2, 3, 4]
//: * `for` loop pour obtenir 10
var reduceLoop = 0
for number in array {
  reduceLoop += number
}
/*:
 * `reduce` pour obtenir 10.
    * `initialResult` : 0
    * `nextPartialResult` : closure utilisant l'`initialResult` et un élément de la `Sequence`. Ici l'opération est l'addition
 */
let reduce = array.reduce(0, { $0 + $1 })
//: * Si l'élément de la `Sequence` est du même type que l'`initialResult`, l'expression de la closure peut être simplifié en indiquant uniquement l'opération de celle-ci
let reduce2 = array.reduce(0, +)
//: Avec des données *non primitives*
struct Device {
  var type: String
  var price: Float
  var color: String
}

var myDevices = [
  Device(type: "iMac Pro", price: 4_999, color: "Space Grey"),
  Device(type: "iPhone", price: 799, color: "White"),
  Device(type: "iPhone", price: 699, color: "Black"),
  Device(type: "iPad", price: 599, color: "Space Grey"),
  Device(type: "Apple Watch", price: 349, color: "Space Grey"),
  Device(type: "Apple TV", price: 199, color: "Black")
]
/*:
 * `reduce` pour obtenir la somme du prix de tous les produits
 * Ici l'expression n'est pas réductible, car l'élément de la `Sequence` est d'un type différent de celui de l'`initialResult`
 */
let totalPrice = myDevices.reduce(0, { $0 + $1.price })
//: [< Previous: `map`](@previous)           [Home](Introduction)           [Next: `compactMap` >](@next)
