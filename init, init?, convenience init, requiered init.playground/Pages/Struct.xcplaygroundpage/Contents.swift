import Foundation
//: # Struct initialization
//: * **Memberwise init** : le compilo créer un `init` pour chacunes des properties de la struct si et seulement si aucun autre init n'est déclaré dans la définition de la struct
struct Person {

  var name: String
  var age: Int
}
let person = Person(name: "Lucas", age: 23)
//: * Tips : Si on souhaite définir un init custom tout en gardant le **memberwise init**, il faut déclaré cet init custom dans une extension
extension Person {

  init(name: String) {
    self.name = name
    self.age = 0
  }
}
let person2 = Person(name: "Lucas")
//: * On peut créer autant d'init custom que souhaité
struct Celsius {

  var temperature: Double

  init(fromFahrenheit fahrenheit: Double) {
    temperature = (fahrenheit - 32.0) / 1.8
  }

  init(fromKelvin kelvin: Double) {
    temperature = kelvin - 273.15
  }

  init(_ celsius: Double) {
    self.temperature = celsius
  }
}
let celsiusFromKelvin = Celsius(fromKelvin: 500)
let celsiusFromFahrenheit = Celsius(fromFahrenheit: 55)
let celsius = Celsius(30)
/*:
 * **Valeur par défaut pour certaines properties**
    * Si certaines properties ont une valeur par défaut, alors le compilo créer autant de **memberwise init** que de situation possible
 */
struct PersonWithDefaultValue {

  var name = "Lucas"
  var age: Int

  // Memberwise init sous-jacent
  // init(name: String = "Lucas", age: Int) {
  //   self.name = name
  //   self.age = age
  // }
}
let personWithDefaultName = PersonWithDefaultValue(age: 23) // Produce: Lucas, 23
let personWithoutDefaultName = PersonWithDefaultValue(name: "Benjamin", age: 23) // Produce: Benjamin, 23
//: * Même constat si toutes les properties ont une valeur par défaut
struct PersonWithDefaultValues {

  var name = "Lucas"
  var age = 0

  // Memberwise init sous-jacent
  // init(name: String = "Lucas", age: Int = 0) {
  //   self.name = name
  //   self.age = age
  // }
}
let personWithDefaultValues = PersonWithDefaultValues() // Produce: Lucas, 0
let personWithDefaultValues1 = PersonWithDefaultValues(name: "Benjamin") // Produce: Benjamin, 0
let personWithDefaultValues2 = PersonWithDefaultValues(age: 23) // Produce: Lucas, 23
let personWithDefaultValues3 = PersonWithDefaultValues(name: "Benjamin", age: 23) // Produce: Benjamin, 23
/*:
 * **Optional properties & memberwise init**
    * Les optional properties sont initialisées à nil par défaut
    * Même configuration que pour une valeur par défaut
 */
struct PlayerOptionalProperty {

  var name: String
  var numero: Int?

  // Memberwise init sous-jacent
  // init(name: String, numero: Int? = nil) {
  //   self.name = name
  //   self.numero = numero
  // }
}
let playerOptionalProperty = PlayerOptionalProperty(name: "Lucas") // Produce: Lucas, nil (implicit)
let playerOptionalProperty1 = PlayerOptionalProperty(name: "Lucas", numero: nil) // Produce: Lucas, nil (explicit)
let playerOptionalProperty2 = PlayerOptionalProperty(name: "Lucas", numero: 7) // Produce: Lucas, 7
/*:
 * **Failable init**
    * Permet d'initialiser ou non un objet en fonctions de certaine(s) condition(s)
    * Créer un objet optional, il faudra donc l'unwrap quand on voudra l'utiliser
    * Peut-être intéressant de le faire dans la déclaration de la struct afin de casser le **memberwise init**
 */
struct Animal {

  let name: String

  init?(name: String) {
    guard !name.isEmpty else { return nil }
    self.name = name
  }
}
let notAnAnimal = Animal(name: "") // Produce: nil
let catAnimal = Animal(name: "cat") // Produce: Optional(Animal(name: cat))
/*:
 * **Init delegation**
    * Un `init` qui appele un autre `init` afin d'éviter de dupliquer du code
 */
struct Size {

  var width = 0.0
  var height = 0.0
}

struct Point {

  var x = 0.0
  var y = 0.0
}

struct Rect {

  var origin = Point()
  var size = Size()

  init(origin: Point, size: Size) {
    self.origin = origin
    self.size = size
  }

  init(center: Point, size: Size) {
    let oriX = center.x - (size.width / 2)
    let oriY = center.y - (size.height / 2)
    self.init(origin: Point(x: oriX, y: oriY), size: size) // Appel de l'autre init
  }
}
let rectClassic = Rect(origin: Point(x: 7, y: 7), size: Size(width: 7, height: 7)) // init sans delegation
let rectDelefate = Rect(center: Point(x: 8, y: 8), size: Size(width: 7, height: 7)) // init avec delegation
//: [Home](Introduction)           [Next: `Class initialization` >](@next)
