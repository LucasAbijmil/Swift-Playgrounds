import Foundation
/*:
 ## if case pattern matching avec `associated values`
 * Permet de matcher un cas spécifique d'une `enum` sans passer par un `switch`
 */

enum Media {
  case book(title: String, author: String, year: Int)
  case movie(title: String, director: String, year: Int)
  case website(title: String, url: URL)
}

let mediaTest: Media = .book(title: "Me", author: "Lucas Abijmil", year: 2020)
//: Utilisation d'aucune `associated values`
if case .book = mediaTest {
  print("This media is a book")
}
//: Ou
if case .book(_, _, _) = mediaTest {
  print("This media is a book")
}
//: Utilisation de certaines `associated values`, celles non utilisées sont remplacées par `_`
if case let .book(title, author, _) = mediaTest {
  print("This media is a book called \(title) wrote by \(author)")
}
//: Utilisation de toutes les `associated values`
if case let .book(title, author, year) = mediaTest {
  print("This media is a book called \(title) wrote by \(author) in \(year)")
}
//: ## if case pattern matching avec conditions sur les `associated values`

//: Conditions **strictes** sur les `associated values`
if case .book(title: "Me", author: "Lucas", year: 2020) = mediaTest {
  print("This media is a book")
}
/*:
 Conditions sur les `associated values`
 * On remplace les `&&` par des `,` (même synaxe que pour un `if let`)
 */
if case let .book(title, author, year) = mediaTest, !title.isEmpty, !author.isEmpty, year >= 2_000 {
  print("This media is book called \(title) wrote by \(author) in \(year)")
}

//: [< Previous: `switch` pattern matching](@previous)           [Home](Introduction)           [Next: `guard case` pattern matching >](@next)
