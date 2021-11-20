import Foundation
/*:
 # Async Throws functions – Création et appelle de fonctions asynchrones qui peuvent générer une erreur – Binding séquentiel
 * Odre de déclaration : `async` puis `throws`
 * Ordre d'appelle : `try` puis `await`
 * Lorsqu'on attend (`await`), la `Task` libère le thread
 */
enum UserError: Error {
  case invalideCount
}
//: * Création d'une fonction asynchrone (`async`) qui peut générer une erreur (`throws`)
func fetchUsers(count: Int) async throws -> [String] {
  if count > 3 {
    throw UserError.invalideCount
  }
  return Array(["Lucas", "Marc", "David"].prefix(count))
}
/*:
 * Appelle à une fonction `async` `throws`
    * La fonction `updateUsers` doit être marquée `async` (voir [Async await](Async%20Await))
    * À l'appelle de la fonction on inverse l'ordre : *nous attendons qu'un travail se termine, et quand il se termine, il peut potentiellement générer une erreur*
    * Ainsi à l'appelle l'ordre est : `try await`
 */
func updateUsers() async {
  do {
    let users = try await fetchUsers(count: 3)
    print("Users : ", users)
  } catch {
    print("Oops!")
  }
}
//: [< Previous: `async` functions](@previous)           [Home](Home)           [Next: `async URLSession` >](@next)
