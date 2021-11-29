import Foundation
/*:
 # Async URLSession – Création d'un call API avec URLSession
 * On utilise la fonction `data(from:)`
 */
//: * Création d'erreurs liés à des call réseaux
enum HTTPError: Error {
  case server
}
//: * La fonction doit être marquée `async` (voir [Async await](Async%20Await))
func fetchData() async -> Result<Data, Error> {
  do {
    let url = URL(string: "https://www.apple.com")!
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
      return .failure(HTTPError.server)
    }
    return .success(data)
  } catch {
    return .failure(error)
  }
}
//: [< Previous: `async throws` function](@previous)           [Home](Home)           [Next: `async let` binding >](@next)
