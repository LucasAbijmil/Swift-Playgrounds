import Foundation
//: ### **Safe Subscript** : **permet de renvoyer nil au lieu d'une `fatalError` si on subscript à un indice non contenu dans une `Collection`**
let array = [1, 2, 3, 4, 5]
/*:
 Accès aux values d'une `Collection`
 * L'index doit être contenu dans la collection, sinon génération d'une `fatalError`
 */
//:      Accès à un index contenu dans la range de la collection
array[2]
//:      Accès à un index non contenu dans la range de la collection, génération d'une fatalError
// array[22]
/*:
 Création d'un subscript custom (extension sur le type `Collection`) :
 * Renvoie la value optionnelle, si l'index est contenu dans la collection
 * `nil` si l'index n'est pas contenu dans la collection
 * *Use case* : lorsqu'on est pas sûr que l'index est contenu dans une `Collection` donnée
 */
extension Collection {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

array[safe: 2] // Optional(3)
array[safe: 22]
//: [< Previous : `zip()`](@previous)           [Home](Introduction)           [Next >](@next)
