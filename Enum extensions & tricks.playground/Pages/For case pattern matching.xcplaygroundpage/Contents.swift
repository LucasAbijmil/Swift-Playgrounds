import Foundation
/*:
 ## for case pattern matching avec `associated values`
 * Permet de boucler sur un cas spécifique d'une `enum` sans passer par un `switch`
 */

enum Media {
  case book(title: String, author: String, year: Int)
  case movie(title: String, director: String, year: Int)
  case website(title: String, url: URL)
}

let mediaList: [Media] = [
  .book(title: "Harry Potter and the Philosopher's Stone", author: "J.K. Rowling", year: 1997),
  .movie(title: "Harry Potter and the Philosopher's Stone", director: "Chris Columbus", year: 2001),
  .book(title: "Harry Potter and the Chamber of Secrets", author: "J.K. Rowling", year: 1999),
  .movie(title: "Harry Potter and the Chamber of Secrets", director: "Chris Columbus", year: 2002),
  .book(title: "Harry Potter and the Prisoner of Azkaban", author: "J.K. Rowling", year: 1999),
  .movie(title: "Harry Potter and the Prisoner of Azkaban", director: "Alfonso Cuarón", year: 2004),
  .movie(title: "J.K. Rowling: A Year in the Life", director: "James Runcie", year: 2007),
  .website(title: "Yo", url: URL(string:"https://en.wikipedia.org/wiki/List_of_Harry_Potter-related_topics")!)
]

//: Utilisation d'aucune `associated values`
for case .book in mediaList {
  print("This media is a book")
}
//: Utilisation de certaines `associated values`, celles non utilisées sont remplacées par `_`
for case let .book(title, _, _) in mediaList {
  print("This media is a book called \(title)")
}
//: Utilisation de toutes les `associated values`
for case let .book(title, author, year) in mediaList {
  print("This media is a book called \(title) wrote by \(author) in \(year)")
}

//: ## for case pattern matching avec conditions sur les `associated values`

//: Conditions **strictes** sur les `associated values`
for case .book(title: "Harry Potter and the Prisoner of Azkaban", author: "J.K. Rowling", year: 1999) in mediaList {
  print("This media is a book called Harry Potter and the Prisoner of Azkaban wrote by J.K. Rowling in 1999.")
}
//: Conditions sur les `associated values` avec le mot clé `where`
for case let .book(title, author, year) in mediaList where !title.isEmpty && !author.isEmpty && year >= 1_950 {
  print("This media is a book called \(title) wrote by \(author) in \(year)")
}

//: [< Previous: `guard case` pattern matching](@previous)           [Home](Introduction)           [Next: rendre une `enum` conforme au protocol `Codable` >](@next)
