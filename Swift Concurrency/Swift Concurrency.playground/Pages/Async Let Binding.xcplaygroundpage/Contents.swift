import Foundation
/*:
 # Async let binding – Permet d'exécuter des fonctions async en parallèle – Binding concurrentiel
 * Retourne une fois que tous les calls sont finis
 * Fonctionne comme un un `DispatchGroup` ou un `zip` en Combine
 * Créer une child `Task` sur un autre thread, hérite de la priorité de sa tâche parent
 */
struct UserData {
  let username: String
  let friends: [String]
  let highScores: [Int]
}

func getUser() async -> String {
  // some complex work
  return "Taylor Swift"
}

func getHighScores() async -> [Int] {
  // some complex work
  return [42, 40]
}

func getFriends() async -> [String] {
  // some complex work
  return ["Lucas", "Marc", "David"]
}
/*:
 * `async let` permet de créer un binding qui stockera le return du call
 * Le scope de la fonction `printUserDetails` doit être marqué `async` dûe au contexte asynchrone avec les bindings
 * Les calls sont déclanchés dès qu'on utilise le binding, et ils doivent être précédés d'un `await` comme l'appelle d'une fonction `async` classique
 * Les calls sont fait en parallèles et on attend que le dernier soit fini
 */
func printUserDetails() async {
  async let username = getUser()
  async let scores = getHighScores()
  async let friends = getFriends()

  let user = await UserData(username: username, friends: friends, highScores: scores)
  print("I GOT MY FIRST USER", user)
}
//: * `async` `let` binding avec des fonctions qui `throws`
func getUserThrowing() async throws -> String {
  // some complex work
  return "Taylor Swift"
}

func getHighScoresThrowing() async throws -> [Int] {
  // some complex work
  return [42, 40]
}

func getFriendsThrowing() async throws -> [String] {
  // some complex work
  return ["Lucas", "Marc", "David"]
}
/*:
 * Les déclarations des bindings via les `async` `let` sont inchangés
 * Dès lors qu'on va utiliser un binding on doit le faire dans un `do` `catch` block
 */
func printUserDetailsThrowing() async {
  async let username = getUserThrowing()
  async let scores = getHighScoresThrowing()
  async let friends = getFriendsThrowing()

  do {
    let user = try await UserData(username: username, friends: friends, highScores: scores)
    print("I GOT MY FIRST USER", user)
  } catch {
    print("Error ", error.localizedDescription, " ...")
  }
}
//: [< Previous: `async URLSession`](@previous)           [Home](Home)           [Next: `AsyncSequence` >](@next)
