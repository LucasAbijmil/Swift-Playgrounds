import SwiftUI
/*:
 # Async URLSession – Création d'un call API async avec URLSession
 * On utilise la fonction `data(from:)`
 */
//: * Création d'erreurs liés à des call réseaux
enum HTTPError: Error {
  case server
}
//: * La fonction doit être marquée `async throws` (voir [Async await](Async%20Await))
func fetchData() async throws -> Data {
  do {
    let url = URL(string: "https://www.apple.com")!
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
      throw HTTPError.server
    }
    return data
  }
}

func printData() {
  Task {
    do {
      let data = try await fetchData()
      print(data)
    } catch {
      print("An error occured", error.localizedDescription)
    }
  }
}
printData()
//: [< Previous: `async` `await`](@previous)           [Home](Home)           [Next: Structured Concurrency >](@next)
