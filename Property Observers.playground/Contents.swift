/*:
 # Property Observers
 * Observe les changements de la valeur d'une propriété
 * Appellé à chaque fois que la valeur est modifiée, même si pour une même valeur
 * Permet d'exécuter du code à chaque modification
 */

/*:
 * Une property observers peut être composée de deux blocks
    * `willSet` : exécute du code juste avant que la propriété change de valeur (rarement utilisé). Paramètre par défaut : `newValue`
      * `myProperty` : valeur avant modification.
      * `newValue` : valeur de la propriété après modification. **Immutable**
    * `didSet` : exécute du code juste après que la propriété ait changé de valeur. Paramètre par défaut : `oldValue`
      * `myProperty` : valeur après la modification. **Mutable**
      * `oldValue` : valeur de la propriété avant la modification. **Immutable**
 */
struct Username {

  var name: String {
    willSet {
//      newValue = "Something new" // KO
      print("Current Value : \(name) ||", "Next Value : \(newValue)")
    } didSet {
//      oldValue = "Something new" // KO
      print("Current Value : \(name) ||", "Old Value : \(oldValue)")
    }
  }
}
var username = Username(name: "Lucas")
username.name = "Marc"
/*:
 * Même s'il est préférable d'utiliser les conventions de Swift, il est possible de renommer les paramètres de `willSet` et `didSet`. Il suffit de déclarer le nom entre parenthèses.
 */
struct UserNameBis {

  var name: String {
    willSet(newName) {
      print("Current Value : \(name) ||", "Next Value : \(newName)")
    } didSet(oldName) {
      print("Current Value : \(name) ||", "Old Value : \(oldName)")
    }
  }
}
/*:
 * Exemple plus proche d'une business logic "réelle"
 */
struct Person {
  var firstName: String
  var lastName: String
  var age: Int {
    didSet {
      age = max(0, age)
    }
  }
}
/*:
 * **Remarque** : `didSet` n'est pas appellé lors de la première initialisation de la propriété, qui fait sens puisque `self` n'est pas encore totalement initialisé
 */
final class PersonObservers {

  var person: Person {
    didSet {
      print("Person has received new value(s)")
      print("OLD VALUES :" , oldValue.firstName, oldValue.lastName, oldValue.age)
      print("NEW VALUES :" , person.firstName, person.lastName, person.age)
    }
  }

  init(person: Person) {
    self.person = person
  }
}

let lucas = Person(firstName: "Lucas", lastName: "Abijmil", age: 22)
let lucasObserver = PersonObservers(person: lucas)
lucasObserver.person.age = -4
lucasObserver.person.age // 0 grâce à la logique du didSet du model
