import Foundation
/*:
 # **`rethrows` functions**
 * À utiliser lorsqu'une fonction A prend comme paramètre une fonction B qui peut `throws`
 */
let data = [1, 2, 3, 4, 5]
/*: **Réimplémentons la fonction `map` pour comprendre `rethrows`**
 * Équivaut à la fonction A
 * (Utilisation de générique et fonction non optimisée)
 */
extension Sequence {

  func map2<T>(_ transformed: (Element) -> T) -> [T] {

    var result: [T] = []

    for element in self {
      let transformedElement = transformed(element)
      result.append(transformedElement)
    }

    return result
  }
}
//: Création d'une `Enum` pour les `Error` de la fonction B qui `throws`
enum TransformedError: Error {
  case uknown
}
/*: Décalaration d'un fonction qui `throws` (pas grand intérêt uniquement pour l'exemple)
 * Équivaut à la fonction B
 */
func transformed(_ number: Int) throws -> Int {
  if Bool.random() {
    return number
  } else {
    throw TransformedError.uknown
  }
}
/*:
 * Appel de la fonction A (`map2`) qui appelle la fonction B (`transformed`)
 * Génération d'une erreur : `Invalid conversion from throwing function of type '(Int) throws -> Int' to non-throwing function type '(Int) -> Int`
 */
//_ = data.map2 { try transformed($0) }
/*: Le paramètre B dans la fonction `map2` ne `throws` pas, nous devons donc faire les modifications suivantes :
 * Ajouter `throws` à la fonction B
 * Ajouter `throws` à la fonction A (autrement génération de l'erreur `Errors thrown from here (try transformed(element)) are not handled`)
 */
extension Sequence {

  func map2Prime<T>(_ transformed: (Element) throws -> T) throws -> [T] {

    var result: [T] = []

    for element in self {
      let transformedElement = try transformed(element)
      result.append(transformedElement)
    }

    return result
  }
}

//: On obtient donc le résultat suivant, lorsque la fonction B throws`
_ = try data.map2Prime { try transformed($0) }
/*: Cependant lorsqu'on appelle une fonction B qui ne `throws` pas on doit ajouter le mot `try` devant la fonction A
 * À peu de sens car la fonction B ne `throws` pas donc aucune chance que la fonction A `throws`
 */
_ = try data.map2Prime { $0 * 2 }
/*: Ainsi on peut remplacer le `throws` de la fonction A pour un `rethrows` :
 * Permet de ne pas rajouter ce `try` devant la fonction A si la fonction B ne `throws` pas
 */
extension Sequence {

  func map2Second<T>(_ transformed: (Element) throws -> T) rethrows -> [T] {

    var result: [T] = []

    for element in self {
      let transformedElement = try transformed(element)
      result.append(transformedElement)
    }

    return result
  }
}
//: On obtient donc les résultats suivants :
_ = try data.map2Second { try transformed($0) }
_ = data.map2Second { $0 * 2 }
//: [< Previous: `try, try?, try!`](@previous)           [Home](introduction)           [Next >](@next)
