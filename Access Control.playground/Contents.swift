/*:
 # Access Control :
 * Permet de restreindre (ou non) l'accès à certaines parties du code, d'un fichier à l'autre, d'un module à l'autre.
 * On peut attribuer des niveaux d'accès pour différents types (`class`, `struct`, `enum`) ainsi qu'aux propriétés, initializers et méthodes.
 * Le niveau d'accès s'applique également aux extensions
 * Il existe 5 types d'access control (du plus fermé au plus ouvert) :
    * `private`
    * `fileprivate`
    * `internal`
    * `public`
    * `open`
 */

/*:
 ## Private : un des plus utilisé
 * La propriété est accessible uniquement dans la déclaration du type
 * Une extension dans le même fichier que la déclaration du type aura tout de même accès à cette propriété
 * Conclusion : *Je veux que cette donnée ne soit accessible par personne*
 */
final class Person {

  var name: String
  private var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }

  private func printName() {
    print(name)
  }
}

let lucas = Person(name: "Lucas", age: 22)
// lucas.age // KO
// lucas.printName() // KO
/*:
 ## Fileprivate : pas très utilisé
 * Très similaire à `private`, mais la propriété reste accessible dans le même fichier (un peu moins fermé que `private`)
 * Conclusion : *Je veux que cette donnée soit accessible uniquement dans le fichier de sa déclaration*
 */

final class Personn {
  var name: String
  fileprivate var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }

  fileprivate func printName() {
    print(name)
  }
}

let lucas2 = Personn(name: "Lucas", age: 22)
lucas2.age // Ok car dans le même fichier
lucas2.printName() // Ok car dans le même fichier
/*:
 ## internal : par défaut (pas besoin de le déclarer)
 * La propriété est accessible dans tout le module / projet (SwiftUI, UIKit par exemple)
 * Conclusion : *Cette donnée est accessible à travers toute ma code base, mais pas pour les autres modules*
 */
final class Personnn {
  internal var name: String
  internal var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }

  func printName() { // internal par défaut
    print(name)
  }
}

let lucas3 = Personnn(name: "Lucas", age: 22)
lucas3.name
lucas3.age
lucas3.printName()
/*:
 ## public : accessible par tout le monde (principalement dans les frameworks)
 * La propriété est accessible partout, d'un module à l'autre
 * On peut subclasser une `class public` que dans le même module, impossible à l'extérieur de celui-ci
 * Conclusion : *Cette donnée est accessible à n'importe qui, mais ne peut pas être subclassé à l'extérieur du module*
 */
public class Personnnn {
  public var name: String
  public var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }

  public func printName() { // internal par défaut
    print(name)
  }
}
/*:
 ## open : plus ouvert que public (principalement utilisé dans les frameworks)
 * La propriété est accessible partout, d'un module à l'autre et peut être subclassé à l'extérieur de son module
 * Conclusion : *Cette donnée est accessible à n'importe qui, et peut être subclassé par n'importe qui*
 */

open class Personnnnn {
  open var name: String
  open var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }

  open func printName() { // internal par défaut
    print(name)
  }
}
