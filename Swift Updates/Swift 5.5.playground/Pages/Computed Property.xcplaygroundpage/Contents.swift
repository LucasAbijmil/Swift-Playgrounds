import Foundation
/*:
 # Computed property get only – Support async throws
 * Les computed properties `get` only peuvent être `throws` **et / ou** `async`
 */
//: * Exemple de `get` `throws` :
enum FileError: Error {
  case missing
  case unreadable
}

struct BundleFile {

  let filename: String

  var contents: String {
    get throws {
      guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
        throw FileError.missing
      }

      do {
        return try String(contentsOf: url)
      } catch {
        throw FileError.unreadable
      }
    }
  }
}
//: * Exemple de `get` `async`
struct UserService {

  let username: String

  var id: String? {
    get async {
      return await fetchUserId(for: username)
    }
  }

  private func fetchUserId(for username: String) async -> String? { return nil }
}
//: * Exemple de `get` `async` `throws`
struct FetchService {

  let url: URL

  var result: Result<Data, Error> {
    get async throws {
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        return .success(data)
      } catch {
        return .failure(error)
      }
    }
  }
}
//: [Home](Home)           [Next: `Double` - `CGFloat` cast >](@next)
