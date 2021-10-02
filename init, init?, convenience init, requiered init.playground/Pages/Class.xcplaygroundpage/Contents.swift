import Foundation
/*:
 # Class initialization
 * À l'inverse des struct, les class ne profitent pas du **memberwise init** créer par le compilo
 */
//: * **Designated init** : créer un init pour une class (correspond ± à un **memberwise init**). Ne peut être déclaré en dehors de la définition du type
class Person {

  var name: String
  var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
}
let person = Person(name: "Lucas", age: 23)
/*:
  * Lorsqu'une class hérite d'une autre class, il faut d'abord initialiser toutes les *child propeties* avant d'appeler l'init de la class héritée
 */
final class ChildPerson: Person {

  var nickname: String

  init(name: String, age: Int, nickname: String) {
    self.nickname = nickname
    super.init(name: name, age: age)
  }
}
let child = ChildPerson(name: "Benjamin", age: 2, nickname: "Benji")
//: * On peut créer autant de **designated init** que souhaité
final class Celsius {

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
 * Lorsqu'on souhaite donner une valeur par défaut à certaines properties, deux solutions s'offre à nous :
    * Créer un `init` où les paramètres concernées ont une valeur par défaut
    * Donner une valeur par défaut aux properties concernées, et créer autant d'`init` que souhaité
    * Évidemment d'un point de vue pratique, le choix n°1 est souvent préféré
 */
final class PersonWithDefaultValueForInit {

  var name: String
  var age: Int

  init(name: String = "Lucas", age: Int) {
    self.name = name
    self.age = age
  }
}
let personWithDefaultValueForInit = PersonWithDefaultValueForInit(age: 23) // Produce: Lucas, 23
let personWithDefaultValueForInit2 = PersonWithDefaultValueForInit(name: "Benjamin", age: 23) // Produce: Benjamin, 23

final class PersonWithDefaultValueForProperty {

  var name = "Lucas"
  var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }

  init(age: Int) {
    self.age = age
  }
}
let personWithDefaultValueForProperty = PersonWithDefaultValueForProperty(age: 23) // Produce: Lucas, 23
let personWithDefaultValueForProperty2 = PersonWithDefaultValueForProperty(name: "Benjamin", age: 23) // Produce: Benjamin, 23
/*:
 * Même constat si toutes les properties ont une valeur par défaut
 */
final class PlayerWithDefaultValuesForInit {

  var name: String
  var numero: Int

  init(name: String = "Lucas", numero: Int = 0) {
    self.name = name
    self.numero = numero
  }
}
let playerWithDefaultValuesForInit = PlayerWithDefaultValuesForInit() // Produce: Lucas, 0
let playerWithDefaultValuesForInit1 = PlayerWithDefaultValuesForInit(name: "Benjamin") // Produce: Benjamin, 0
let playerWithDefaultValuesForInit2 = PlayerWithDefaultValuesForInit(numero: 7) // Produce: Lucas, 7
let playerWithDefaultValuesForInit3 = PlayerWithDefaultValuesForInit(name: "Benjamin", numero: 7) // Produce: Benjamin, 7

final class PlayerWithDefaultValuesForProperties {

  var name = "Lucas"
  var numero = 0

  init(name: String) {
    self.name = name
  }

  init(numero: Int) {
    self.numero = numero
  }

  // Un petit raccourci en combinant les deux init comme il suit (même si on revient au point n°1 😉)
  init(name: String = "Lucas", numero: Int = 0) {
    self.name = name
    self.numero = numero
  }
}
let playerWithDefaultValuesForProperties = PlayerWithDefaultValuesForProperties() // Produce: Lucas, 0
let playerWithDefaultValuesForProperties1 = PlayerWithDefaultValuesForProperties(name: "Benjamin") // Produce: Benjamin, 0
let playerWithDefaultValuesForProperties2 = PlayerWithDefaultValuesForProperties(numero: 7) // Produce: Lucas, 7
let playerWithDefaultValuesForProperties3 = PlayerWithDefaultValuesForProperties(name: "Benjamin", numero: 7) // Produce: Benjamin, 7
//: * **Remarque** : Si on donne une valeur par défaut pour toutes les properties alors un `init` sans paramètre est créé automatiquement uniquement si et seulement si aucun autre **designated init** n'est définie dans la définition de la class
final class DefaultPlayer {

  var name = "Lucas"
  var numero = 0
}
let defaultPlayer = DefaultPlayer() // Produce: Lucas, 0
//: * Attention, si un **designated init** est déclaré avec des paramètres dans la définition de class, nous devons rajouter un **designated init** sans paramètre pour utiliser les valeurs par défaut
final class DefaultPlayerOrRealPlayer {

  var name = "Lucas"
  var numero = 0

  init(name: String, numero: Int) {
    self.name = name
    self.numero = numero
  }

  init() { }
}
let defaultPlayerAndNotARealOne = DefaultPlayerOrRealPlayer(name: "Benjamin", numero: 7) // Produce: Benjamin, 7
let realPlayerAndNotNotADefaultOne = DefaultPlayerOrRealPlayer() // Produce: Lucas, 0
/*:
 * **Optional properties & designated init**
    * Les optional properties sont initialisées à nil par défaut
    * On peut créer deux init : un pour laisser la valeur de la property à nil, l'autre afin de l'initialiser avec une valeur
    * Tip : on peut faire les deux en un avec grâce à la valeur par défaut pour l'argument du **designated init**
 */
final class PlayerOptionalProperty {

  var name: String
  var numero: Int? // = nil

  init(name: String, numero: Int? = nil) {
    self.name = name
    self.numero = numero
  }
}
let playerOptionalProperty = PlayerOptionalProperty(name: "Lucas") // Produce: Lucas, nil (implicit)
let playerOptionalProperty2 = PlayerOptionalProperty(name: "Lucas", numero: nil) // Produce: Lucas, nil (explicit)
let playerOptionalProperty3 = PlayerOptionalProperty(name: "Lucas", numero: 7) // Produce: Lucas, Optional(7)
/*:
 * **Convenience init**
    * Permet de créer d'autre init en dehors de la définition de la class (extension)
    * Doit **obligatoirement** finir par appeler un **designated init**
    * 2 règles :
        *  Un **designated init** appelle toujours un **designed init** de sa superclass (si besoin) 👉 *delegate up*
        *  Un **convenience init** appelle toujours un **designed init** de sa class 👉 *delegate across*
 */
final class Civil {

  var firstName: String
  var lastName: String
  var age: Int

  init(firstName: String, lastName: String, age: Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
}

extension Civil {

  convenience init(firstName: String) {
    self.init(firstName: firstName, lastName: "Abijmil", age: 23) // delegate across
  }
}

let designatedCivil = Civil(firstName: "Lucas", lastName: "Abijmil", age: 23) // Produce: Lucas, Abijmil, 23
let convenienceCivil = Civil(firstName: "Benjamin") // Produce: Benjamin, Abijmil, 23
/*:
 * **Failable init**
    * Permet d'initialiser ou non un objet en fonctions de certaine(s) condition(s)
    * Créer un objet optional, il faudra donc l'unwrap quand on voudra l'utiliser
    * Peut être aussi être un **convenience init?**
 */
final class Animal {

  let name: String

  init?(name: String) {
    guard !name.isEmpty else { return nil }
    self.name = name
  }
}
extension Animal {

  convenience init?(_ name: String) {
    self.init(name: name)
  }
}
let notAnAnimal = Animal(name: "") // Produce: nil
let catAnimal = Animal(name: "cat") // Produce: Optional(Animal(name: cat))
/*:
 * **Inherited init** : Les sublcass peuvent hériter des inits de leur superclass en respectant une de ces deux conditions :
    * Si la subclass ne définit aucun **designated init** alors elle hérite de tous les **designated init** de la superclass
    * Si la subclass implémente tous les **designated init** de la superclass, alors elle hérite de tous les **convenience init** de la superclass.
      * Remarque : l'implémentation des **designated init** d'une superclass peut se faire par un **convenience init** dans la subclass
 */
/*:
 * **Required init**
    * Permet de déclaré un init qui doit être implémenté par chaque subclass (utilisation assez rare)
    * Les subclass ne sont pas obligé de faire une implémentation explicit du **requiered init** du moment qu'ils satisfassent la déclaration
 */
class Player {

  let numero: Int

  init(numero: Int) {
    self.numero = numero
  }

  required init() {
    self.numero = Int.random(in: 1...99)
  }
}

final class GoalKeeper: Player {

  let name: String

  init(name: String, numero: Int) {
    self.name = name
    super.init(numero: numero)
  }


  required init() {
    fatalError("init() has not been implemented")
  }
}
//: [< Previous: `Struct initialization`](@previous)           [Home](Introduction)
