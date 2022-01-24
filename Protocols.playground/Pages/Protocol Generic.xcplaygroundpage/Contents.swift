//: # Protocol Generics – Utiliser les generics dans des protocols
/*:
 * Créons un `protocol` générique qui permet de créer une pile FILO (First In, Last Out) :
    * Peut contenir n'importe quel type
    * Possède une propriété `count` qui retournera le nombre d'élément présent dans la pile
    * Possède deux fonctions `push(_:)` et `pop()` pour respectivement ajouter un élément et retirer le dernier élément
 * En utilisant les génériques de *manière classique* on aurait fait quelque chose dans ce style
 */
protocol Stacke<T> {
  var count: Int { get }

  mutating func push(_ element: T)
  mutating func pop() -> T?
}
/*:
 * Cependant, la définition des `protocol` ne supportent pas l'utilisation de générique comme on le fait ailleurs dans le language
 * Regardons l'erreur générée : *Protocols do not allow generic parameters; use associated types instead*
 * En effet, pour déclarer un (ou plusieurs) type générique dans une définition d'un `protocol` on utilisera le mot clé `associatedtype`
 */
protocol Stack {
  associatedtype Element

  var count: Int { get }
  mutating func push(_ element: Element)
  mutating func pop() -> Element?
}
/*:
 * Lorsqu'on fait conformer un type à un `protocol` avec `associatedtype` et qu'on laisse le compilo générer les erreurs, cela se fera en 2 étapes :
    * Définission du (ou des) `associatedtype` grâce à des `typealias`
    * Ajout des conformances requiert par le `protocol`
 * Note: On pourra retirer la déclaration du `typealias` après la seconde étape
 */
struct IntStack: Stack {

  typealias Element = Int

  var count: Int {
    return values.count
  }

  private var values: [Int] = []

  mutating func push(_ element: Int) {
    values.append(element)
  }

  mutating func pop() -> Int? {
    return values.popLast()
  }
}
/*:
 * Lorsqu'on le fait *à la main*, nous n'avons pas besoin de déclarer le `typealias`
 * Cependant les implémentations doivent **contenir les même types attendus autrement cela généra une erreur**
 */
struct DoubleStack: Stack {

  var count: Int {
    return values.count
  }

  private var values: [Double] = []

  mutating func push(_ element: Double) {
    values.append(element)
  }

  mutating func pop() -> Double? {
    return values.popLast()
  }
}

var doubleStack = DoubleStack()
doubleStack.push(0)
doubleStack.push(1)
doubleStack.push(2)
doubleStack.push(3)
doubleStack.push(4)
doubleStack.push(5)
doubleStack.pop()
/*:
 * On peut également restreindre des `associatedtype` de la même manière qu'on le ferait avec des génériques dans le language
 * Ici notre type générique `Element` doit être conforme au `protocol Decodable`
 */
protocol StackDecodable {
  associatedtype Element: Decodable

  mutating func push(_ element: Element)
  mutating func pop() -> Element?
}
//: * Note: Cela fonctionne aussi avec des `protocol` customs
protocol CustomProtocol {}

protocol StackCustomProtocol {
  associatedtype Element: CustomProtocol

  mutating func push(_ element: Element)
  mutating func pop() -> Element?
}
//: [< Previous: Protocol Restriction](@previous)           [Home](Introduction)           [Next >](@next)
