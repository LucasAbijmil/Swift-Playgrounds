import Foundation
/*:
 # **`Typealias`** :
 * Permet de renommer un type déjà existant
 */

//: `typealias` sur le type `Int`
typealias ID = Int
func fetchUserName(userID: Int, completion: @escaping (Result<String, Error>) -> Void) { }
func fetchUserName1(userID: ID, completion: @escaping (Result<String, Error>) -> Void) { }
//: ## Création de `typealias` pour le `Result` de fonction asynchrones 👍
//: * `typealias` non optimisé car le type du `Result` est hard-codé (`String`)
typealias CompletionString = (Result<String, Error>) -> Void
func fetchUserName2(userID: ID, completion: @escaping CompletionString) { }
//: * `typealias` générique, optimisé car on pourra déclarer le type du `Result`
typealias Completion<T> = (Result<T, Error>) -> Void
func fetchUserName3(userID: ID, completion: @escaping Completion<String>) { }
func fetchUserIsPremium(userID: ID, completion: @escaping Completion<Bool>) { }
func fetchUserFriends(userID: ID, completion: @escaping Completion<[String]>) { }
