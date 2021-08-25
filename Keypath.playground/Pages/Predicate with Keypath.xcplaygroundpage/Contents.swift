/*:
 ## Création d'un prédicat avec l'utilsation du `KeyPath`
 * Ici on prend l'exemple avec des HOF car c'est une des situation où l'utilisation des `KeyPath` est la plus puissante
 */
struct Person {
  let age: Int
}

let people = [Person(age: 45), Person(age: 12), Person(age: 39), Person(age: 41), Person(age: 20), Person(age: 8)]
//: Exemple d'un prédicat sans l'utilisation de `KeyPath` (assez classique) :
let majeurs = people.filter { $0.age > 18 }
/*:
 Création du prédicat mais avec l'utilisation du `KeyPath`
 * Définition d'un prédicat : test d'un élément qui renvoie un `Bool`, on peut donc définir le type suivant :
 * `Typealias` qui prend un argument générique, appellé `Element`, pour rester raccord avec la définition d'un `Element` d'une `Sequence`
 */
typealias Predicate<Element> = (Element) -> Bool
/*:
 Création de la fonction pour tester le prédicat :
 * Deux arguments génériques :
    * `Element` : l'élément d'une `Sequence`
    * `Property` : doit être conforme à `Comparable` puisque c'est la valeur comparée
 * `lhs` : `KeyPath<Root: Element, Value: Property>` [voir ici](@previous)
 * `rhs` : la `Property` (constante) comparée
 */
func > <Element, Property: Comparable>(_ lhs: KeyPath<Element, Property>, _ rhs: Property) -> Predicate<Element> {
  return { element in
    element[keyPath: lhs] > rhs
  }
}

let majeursKeypath = people.filter(\.age > 18)
//: Création de la fonction pour un prédicat avec `<` (l'inverse de ci-dessus)
func < <Element, Property: Comparable>(_ lhs: KeyPath<Element, Property>, _ rhs: Property) -> Predicate<Element> {
  return { element in
    element[keyPath: lhs] < rhs
  }
}

let mineursKeypath = people.filter(\.age < 18)
//: [< Previous : Généralité](@previous)           [Home](Introduction)           [Next >](@next)
