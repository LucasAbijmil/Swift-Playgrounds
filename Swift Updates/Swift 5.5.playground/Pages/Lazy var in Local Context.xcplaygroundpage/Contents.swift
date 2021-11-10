import Foundation
/*:
 # Lazy var dans un context local (fonction)
 * Désormais les fonctions supportent les `lazy var` dans leur scope
 * Voir [Lazy Property](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Lazy%20Property.playground)
 */
/*:
 * Exemple d'une fonction avec une `lazy var`. Cette fonction print dans l'ordre :
    * Before lazy
    * After lazy
    * In printGreeting()
    * Hello, Lucas
 */
func printGreeting(to name: String) -> String {
  print("In printGreeting()")
  return "Hello, \(name)"
}

func lazyDummyTest() {
  print("Before lazy")
  lazy var name = printGreeting(to: "Lucas")
  print("After lazy")
  print(name)
}

lazyDummyTest()
/*:
 * Exemple d'une fonction avec une `lazy var`. La variable sera calculée uniquement dans le cas où le `Bool.random()` renvoie true. La fonction print dans l'ordre :
    * Before lazy
    * After lazy
    * Si `bool` est à true :
        * In printGreeting()
        * Hello, Lucas
 */
func lazyDummyBoolTest(_ bool: Bool) {
  print("Before lazy")
  lazy var name = printGreeting(to: "Lucas")
  print("After lazy")
  if bool {
    print(name)
  }
}

lazyDummyBoolTest(Bool.random())
//: [< Previous: `Double` - `CGFloat` cast](@previous)           [Home](Home)           [Next: `#if` postfix member expressions >](@next)
