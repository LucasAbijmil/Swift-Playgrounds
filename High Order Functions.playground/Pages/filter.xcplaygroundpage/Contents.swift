/*:
 ## Filter
 * Filtre et retourne les éléments d'une `Sequence` satisfaisant la ou les conditions passée(s) dans la closure
 * Return une `Sequence` du **même type** que celle qui est filtrée
 */
//: Avec des données *primitives*
let array = [1, 2, 3, 4, 3, 3]
//: * `for` loop pour obtenir [3, 3, 3] (pas optimisé)
var filteredLoop = [Int]()
for number in array where number == 3 {
    filteredLoop.append(number)
}
//: * `filter` pour obtenir [3, 3, 3] (optimisé), `return : [Int]`
let threes = array.filter { $0 == 3 }
//: * `filter` pour obtenir [2, 4], `return : [Int]`
let multipleOf2 = array.filter { $0.isMultiple(of: 2) }
//: * `filter` avec plusieurs conditions, `return : [Int] `
let result = array.filter { $0 == 3 && !$0.isMultiple(of: 2) }
let result2 = array.filter { $0 == 3 || $0 == 2 }
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
//: * `filter` pour obtenir un tableau de `Device` avec uniquement des "iPhone" en `type`, `return : [Device]`
let iphones = myDevices.filter { $0.type == "iPhone" }
//: [Home](Introduction)           [Next: `map` >](@next)
