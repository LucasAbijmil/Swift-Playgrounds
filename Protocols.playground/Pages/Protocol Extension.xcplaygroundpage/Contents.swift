/*:
 # Protocol & Implémentation par défaut
 * Les `protocols` sont très puissant en Swift, selon Apple, Swift est un POP
 * La puissance des implémentations par défaut est que cela permet d'avoir le concept d'héritage mais avec tout type d'objet : `value` ou `reference` type
 * Une implémentation par défaut ce fait dans une `extension` du `protocol`
 */
/*:
 Création d'un `protocol` `ColorChangable` et implémentation par 3 objets
 */
protocol ColorChangable {
  func changeColor()
}

final class MyButton: ColorChangable {

  func changeColor() {
    print("Changing to white...")
  }
}

struct MyLabel: ColorChangable {

  func changeColor() {
    print("Changing to white...")
  }
}

final class MyView: ColorChangable {

  func changeColor() {
    print("Changing to white...")
  }
}
/*:
 ⚠️ On fait trois fois la même implémentation
 * Pour éviter cela, on va faire une implémentation par défaut pour la fonction `changeColor` dans une `extension` du `protocol`
 * Les objets conformes à ce `protocol` n'ont plus nécessairement besoin d'implémenter `changeColor`
 * Si les objets implémentent `changeColor` alors on utilise cette implémentation, autrement on prend l'implémentation par défaut (faite dans l'`extension` du `protocol`)
 */
protocol ColorChangable1 {
  func changeColor()
}

extension ColorChangable1 {

  func changeColor() {
    print("Changing to white...")
  }
}

final class MyButton1: ColorChangable1 {

  // implémentation propre à MyButton1
  func changeColor() {
    print("Changing to black...")
  }
}

struct MyLabel1: ColorChangable1 {

  // implémentation propre à MyLabel1
  func changeColor() {
    print("Changing to red...")
  }
}

final class MyView1: ColorChangable1 { }

let myButton1 = MyButton1()
myButton1.changeColor() // utilisation de l'implémentation de l'objet
let myLabel1 = MyLabel1()
myLabel1.changeColor() // utilisation de l'implémentation de l'objet
let myView1 = MyView1()
myView1.changeColor() // utilisation de l'implémentation par défaut
//: Exemple avec deux `protocols` qui font chacun une implémentation par défaut
protocol ColorChangable2 {
  func changeColor()
}

extension ColorChangable2 {

  func changeColor() {
    print("Changing to white...")
  }
}

protocol TextClearable2 {
  func clearText()
}

extension TextClearable2 {

  func clearText() {
    print("Clearing text...")
  }
}

final class MyButton2: ColorChangable2, TextClearable2 {

  // implémentation propre à MyButton2
  func changeColor() {
    print("Changing to black...")
  }
}

struct MyLabel2: ColorChangable2, TextClearable2 {

  // implémentation propre à MyLabel2
  func changeColor() {
    print("Changing to red...")
  }

  // Implémentation propre à MyLabel2
  func clearText() {
    print("Clearing last character...")
  }
}

final class MyView2: ColorChangable2, TextClearable2 { }

let myButton2 = MyButton2()
myButton2.changeColor() // utilisation de l'implémentation de l'objet
myButton2.clearText() // utilisation de l'implémentation par défaut
let myLabel2 = MyLabel2()
myLabel2.changeColor() // utilisation de l'implémentation de l'objet
myLabel2.clearText() // utilisation de l'implémentation de l'objet
let myView2 = MyView2()
myView2.changeColor() // utilisation de l'implémentation par défaut
myView2.clearText() // utilisation de l'implémentation par défaut
/*:
 Combiner des `protocols` grâce au `protocol inheritance`
 * Création d'un `protocol` qui hérite de `ColorChangable3` & `TextClearable3`
 * `ColorAndTextUpdatable3` hérite de tous les requirements et implémentation par défaut de `ColorChangable3` & `TextClearable3`
 * On décide de ne pas rajouter de requierements *propre* à `ColorAndTextUpdatable3`
 */
protocol ColorChangable3 {
  func changeColor()
}

extension ColorChangable3 {

  func changeColor() {
    print("Changing to white...")
  }
}

protocol TextClearable3 {
  func clearText()
}

extension TextClearable3 {

  func clearText() {
    print("Clearing text...")
  }
}
//: Utilisation du [protocol composition](Protocol%20Composition)
typealias ColorAndTextUpdatable3 = ColorChangable3 & TextClearable3

final class MyButton3: ColorAndTextUpdatable3 /* = ColorChangable3, TextClearable3 */ {

  // implémentation propre à MyButton2
  func changeColor() {
    print("Changing to black...")
  }
}

struct MyLabel3: ColorAndTextUpdatable3 /* = ColorChangable3, TextClearable3*/ {

  // implémentation propre à MyLabel2
  func changeColor() {
    print("Changing to red...")
  }

  // Implémentation propre à MyLabel2
  func clearText() {
    print("Clearing last character...")
  }
}

final class MyView3: ColorAndTextUpdatable3 { }

let myButton3 = MyButton3()
myButton3.changeColor() // utilisation de l'implémentation de l'objet
myButton3.clearText() // utilisation de l'implémentation par défaut
let myLabel3 = MyLabel3()
myLabel3.changeColor() // utilisation de l'implémentation de l'objet
myLabel3.clearText() // utilisation de l'implémentation de l'objet
let myView3 = MyView3()
myView3.changeColor() // utilisation de l'implémentation par défaut
myView3.clearText() // utilisation de l'implémentation par défaut
//: [< Previous: Protocol & optional requierements](@previous)           [Home](Introduction)           [Next: Protocol inheritance & POP >](@next)
