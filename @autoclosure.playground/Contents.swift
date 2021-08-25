import Foundation
/*:
 # **@autoclosure**
 * Permet de créer automatiquement une closure à partir d'un argument
 * Transformer l'argument en closure permet de retarder et d'éviter potentiellement le compute de l'argument
 * ⚠️ La documentation de Swift recommande d'utiliser les `@autoclosure` avec parcimonie
 */
let isDebug = false
struct Person {

  let name: String

  var description: String {
    print("Asking for \(name) description")
    return "Person name is : \(name)"
  }
}
let person = Person(name: "Lucas")
//: Sans `@autoclosure` l'argument est computé à l'appel de la fonction même si non utilisé
func log(_ message: String) {

  if isDebug {
    print("DEBUG : \(message)")
  }
}
log(person.description)
//: On peut éviter ce compute inutile en tranformant l'argument en une closure
func log1(_ message: () -> String) {
  if isDebug {
    print("DEBUG ", message())
  }
}
log1 { person.description }
/*:
 * Pas super car on passe une closure pour une simple `String`
 * `@autoclosure` est là pour transformer la `String` en une closure :
    * permet d'éviter des computes inutiles
    * garde une syntaxe classique
 */
func log2(_ message: @autoclosure () -> String) {
  if isDebug {
    print("DEBUG ", message())
  }
}
log2(person.description)
print("ok")
