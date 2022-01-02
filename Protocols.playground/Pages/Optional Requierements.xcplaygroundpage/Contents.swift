import Foundation
/*:
 # Protocol & Optional Requierements
 * Les requierements d'un `protocol` en Swift sont par défaut **obligatoires**
 * Cependant il existe deux techniques permettant de rendre ces requierements *optional*
 */
/*:
 **La première technique** est de transformer notre protocol en `@objc protocol`, qui permet d'avoir des requierements *optional*

 Cela se fait en plusieurs étapes :
 * Marquer le protocol comme `@objc`
 * Marquer les properties et / ou les methods commme `@objc optional`

 *Behind the scenes* Swift change le types des requierements en optional, et ce, même pour les fonctions

 ⚠️ L'inconvénient est que seules les `class` pourront se conformer à ce protocol
 */
@objc protocol ObjcCounter {
  @objc optional var count: Int { get set }
  @objc optional func printCounter()
}
//: Les `struct` ne peuvent pas se conformer à des `@objc protocol` autrement génération d'une erreur : *Non-class type 'xxxx' cannot conform to class protocol 'xxxx'*
struct StructCounterObjc: ObjcCounter {}
//: Comme les properties et methods sont marquées comme `optional` il n'y pas besoin de faire d'implémentation
//: * Exemple d'une `class` qui ne fait aucune implémentation pour les `optional` requierements
final class ClassCounterObjc: ObjcCounter {}
//: * Exemple d'une `class` qui fait une implémentation uniquement pour la property `count` – mais n'en fait pas pour les methods
final class ClassCounterObjcPropertiesImplementation: ObjcCounter {
  var count: Int = 99
}
//: * Exemple d'une `class` qui fait une implémentation uniquement pour la method `printCounter`  – mais n'en fait pas pour les properties
final class ClassCounterObjcMethodsImplementation: ObjcCounter {
  func printCounter() {
    print("The count is currently at : 99")
  }
}
//: * Exemple d'une `class` qui fait une implémentation pour les properties & methods
final class ClassCounterObjcFullImplementation: ObjcCounter {

  var count: Int = 99

  func printCounter() {
    print("The count is currently at : \(count)")
  }
}
/*: L'inconvénient d'utiliser des `@objc optional` requierements est qu'**on devra unwrap la property / method lorsqu'on souhaitera l'utiliser** */
let classCounterObjC = ClassCounterObjcFullImplementation()
if let counterObjC = classCounterObjC as? ObjcCounter {

  if let count = counterObjC.count {
    print("count is : \(count)")
  }

  if let printCounter = counterObjC.printCounter {
    printCounter()
  }
}
/*:
 **La deuxième technique** est plus recomandé car plus *Swifty*, il s'agit de faire une implémentation par défaut grâce à une extension sur le `protocol` (voir [Protocol Extension](Protocol%20Extension))

 **L'avantage est que les `struct` pourront aussi se conformer à ce `protocol`**

 Si une `class` ou `struct` ne fait pas d'implémentation pour un requierement, elle utilisera alors l'implémentation par défaut (ie : celle présente dans l'extension du `protocol`)
 */
protocol Counter {
  var count: Int { get set }
  func printCounter()
}
/*:
 `extension` sur le `protocol` qui définit les implémentations par défaut

 Noter que lorsqu'une property est `get set`, il faut expliciter le `set` qu'on laisse généralement vide dans une implémentation par défaut
 */
extension Counter {

  var count: Int {
    get {
      return 0
    } set {}
  }

  func printCounter() {
    print("Default implementation – the count is currently at : \(count)")
  }
}
//: * Exemple d'une `class` qui ne fait aucune implémentation pour les requierements – toutes les implémentations par défaut seront utilisées
final class ClassCounterDefaultImplementations: Counter {}
//: * Exemple d'une `class` qui fait une implémentation uniquement pour les properties – seules les implémentations par défaut pour les methods seront utilisées
final class ClassCounterPropertiesImplementation: Counter {
  var count: Int = 99
}
//: * Exemple d'une `class` qui fait une implémentation uniquement pour les methods – seules les implémentation par défaut pour les properties seront utilisées
final class ClassCounterFunctionsImplementation: Counter {
  func printCounter() {
    print("The count is currently at : \(count)")
  }
}
//: * Exemple d'une `struct` qui fait une implémentation pour tous les requierements – aucune implémentation par défaut ne sera utilisée
struct StructCounterFullImplementation: Counter {

  var count: Int = 99

  func printCounter() {
    print("The count is currently at : \(count)")
  }
}
//: À l'utilisation l'avantage de cette statégie est que **nous n'avons pas besoin d'unwrap les properties / methods pour les utiliser**
let classCounterSwift = StructCounterFullImplementation()
if let counterSwift = classCounterSwift as? Counter {

  print("count is : \(counterSwift.count)")
  counterSwift.printCounter()
}
//: [< Previous: Déclaration & conformance à un protocol](@previous)           [Home](Introduction)           [Next: Protocol & implémentation par défaut >](@next)
