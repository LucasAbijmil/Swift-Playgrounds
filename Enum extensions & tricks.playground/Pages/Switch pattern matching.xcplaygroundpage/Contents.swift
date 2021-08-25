import Foundation
//: ## Pattern matching dans un `switch` avec `associated values`
enum Media {
  case book(title: String, author: String, year: Int)
  case movie(title: String, director: String, year: Int)
  case website(title: String, url: URL)
}
/*:
 Deux solutions possibles pour **ne pas utiliser** les `associated values` :
 * Ne déclarer aucunes `associated values` ➡️ utilisation d'un `case` *brut* (à favoriser)
 * Remplacer la déclaration des `associated values` par des `_`
 */
extension Media {

  var type: String {
    switch self {
    case .book:
      return "Book"
    case .movie(_, _, _):
      return "Movie"
    case .website:
      return "Website"
    }
  }
}
/*:
 Utilisation des `associated values` dans un switch
 * Ajout du mot clé `let` pour la déclaration des `associated values`
 * Remplacement des `associated values` non utilisées par `_`
 */
extension Media {

  var mediaTitle: String {
    switch self {
    case let .book(title, _, _):
      return title
    case let .movie(title, director, _):
      return title + director
    case let .website(title, _):
      return title
    }
  }
}
/*:
 Si plusieurs `case` retourne la même valeur (avec ou sans `associated values`), on peut les déclarer sur une seule ligne
 * Si `associated values` : il faut que les labels aient les mêmes noms
 */
extension Media {

  var mediaTitle2: String {
    switch self {
    case let .book(title, author, _), let .movie(title, author, _):
      return title + author
    case let .website(title, _):
      return title
    }
  }
}
/*:
 Conditions **strictes** sur les `associated values`
 * Doit obligatoirement avoir un `default`
 */
extension Media {

  var isFromMe: Bool {
    switch self {
    case .book(title: "Lucas", author: "Me", _):
      return true
    case .movie(title: "", director: "Me", year: _):
      return true
    case .website(title: "Me", url: _):
      return true
    default:
      return false
    }
  }
}
/*:
 Conditions sur les `assiociated values`
 * Utilisation du mot clé `where`
 * Doit obligatoirement avec un `default`
 */
extension Media {

  var published: Bool {
    switch self {
    case let .book(title, author, year) where !title.isEmpty && !author.isEmpty && year >= 2_000:
      return true
    case let .movie(_, director, year) where !director.isEmpty && year >= 1_950:
      return true
    case let .website(_, url) where url.isFileURL && url.relativeString != "" :
      return true
    default:
      return false
    }
  }
}

//: [< Previous: `enum` avec `associated value`](@previous)           [Home](Introduction)           [Next: `if case` pattern matching >](@next)
