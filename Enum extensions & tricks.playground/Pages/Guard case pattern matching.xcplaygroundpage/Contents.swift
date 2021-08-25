import Foundation
/*:
 ## guard case pattern matching avec `associated values`
 * Permet de matcher un cas spécifique d'une `enum` sans passer par un `switch`
 */
enum Media {
  case book(title: String, author: String, year: Int)
  case movie(title: String, director: String, year: Int)
  case website(title: String, url: URL)
}
//: Utilisation d'aucune `associated values`
func mediaIsABookWithoutAssociated(for media: Media) {
  guard case .book = media else { return }
  print("This media is a book")
}
//: Ou
func mediaIsABookWithoutAssociated2(for media: Media) {
  guard case .book(_, _, _) = media else { return }
  print("This media is a book")
}
//: Utilisation de certaines `associated values`, celles non utilisées sont remplacées par `_`
func mediaIsABook(for media: Media) {
  guard case let .book(title, author, _) = media else { return }
  print("This media is a book called \(title) wrote by \(author)")
}
//: Utilisation de toutes les `associated values`
func mediaIsABook2(for media: Media) {
  guard case let .book(title, author, year) = media else { return }
  print("This media is a book called \(title) wrote by \(author) in \(year)")
}
//: ## guard case pattern matching avec conditions sur les `associated values`

//: Conditions **strictes** sur les `associated values`
func mediaIsABook3(for media: Media) {
  guard case .book("Formation Swift", "Lucas Abijmil", 2020) = media else { return }
  print("This media is a book called Formation Swift wrote by Lucas Abijmil in 2020")
}
/*:
 Conditions sur les `associated values`
 * On remplace les `&&` par des `,` (même synaxe que pour un `guard let`)
 */
func mediaIsABook4(for media: Media) {
  guard case let .book(title, author, year) = media, !title.isEmpty, !author.isEmpty, year >= 2_000 else { return }
  print("This media is a book called \(title) wrote by \(author) in \(year)")
}

//: [< Previous: `if case` pattern matching](@previous)           [Home](Introduction)           [Next: `for case` pattern matching >](@next)
