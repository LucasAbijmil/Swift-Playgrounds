/*:
 # Contains(_:)
 * Renvoie un `Bool` indiquant si la `Sequence` contient au moins une fois l'élément passé en paramètre
 * Le type de la `Sequence` doit être conforme à `Equatable` autrement il faut utiliser `contains(where:)`
 * Principalement utilisé avec des types *primitifs*
 */
//: Avec des données *primitives*
let array = [1, 2, 3, 4, 5]
let three = array.contains(3)
let six = array.contains(6)
//: Avec des données *non primitives*
struct Person: Equatable {
  let name: String
  let age: Int
}

let persons = [Person(name: "Lucas", age: 22),
               Person(name: "Pierre", age: 30),
               Person(name: "Paul", age: 40),
               Person(name: "Jacques", age: 50)]

let lucas = persons.contains(Person(name: "Lucas", age: 22))
let lucas2 = persons.contains(Person(name: "Luka", age: 22))
/*:
 # Contains(where:)
 * Renvoie un `Bool` indiquant si la `Sequence` contient au moins un élément satisfaisant la ou les conditions passée(s) dans la closure
 * Contrairement à `contains(_:)` le type de la `Sequence` ne doit pas forcément être conforme à `Equatable`
 * Pratique pour tester des propriétés de types *non primitifs*
 */
struct Person2 {
  let name: String
  let age: Int
}
let persons2 = [Person2(name: "Lucas", age: 22),
                Person2(name: "Pierre", age: 30),
                Person2(name: "Paul", age: 40),
                Person2(name: "Jacques", age: 50)]

let lucas3 = persons2.contains(where: { $0.name == "Lucas" })
let lucas4 = persons2.contains(where: { $0.name == "Luka" })
//: [< Previous: `flatMap`](@previous)           [Home](Introduction)           [Next: >](@next)
