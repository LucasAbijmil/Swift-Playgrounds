/*:
 ## Map :
 * Applique la transformation passé dans la closure (nouveau type, opération arithmétique) à chaque élément de la `Sequence` et le retourne
 * Return le **même type** que celui de la transformation
 */
//: Avec des données *primitives*
let array = [1, 2, 3, 4, 5]
//: * `for` loop pour obtenir [2, 4, 6, 8, 10] (pas optimisé)
var mapLoop = [Int]()
for number in array {
  mapLoop.append(number * 2)
}
//: * `map` pour obtenir [2, 4, 6, 8, 10] (optimisé), `return : [Int]`
let doubleElement = array.map { $0 * 2 }
//: * `map` pour obtenir ["1", "2", "3", "4", "5"], `return : [String]`
let stringElement = array.map { String($0) }
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
//: * `map` pour doubler chaque prix, `return : [Float]`
let doublePrice = myDevices.map { $0.price * 2 }
//: [< Previous: `filter`](@previous)           [Home](Introduction)           [Next: `reduce` >](@next)
