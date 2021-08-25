import Foundation
/*:
 # **`private(set)`**
 * Permet de rendre le setter en private tout en laissant le getter open pour une propriété d'un type
 */

/*:
 ## Propriété sans `private(set)`
 * La propriété (`name`) peut être modifié en dehors de la définition du type : soit par la fonction du type soit par la propriété directemment
 */
struct Person {
  var name: String

  mutating func changeName(for name: String) {
    self.name = name
  }
}

var individu = Person(name: "Pierre")
print(individu.name)

// Modification via la propriété du type
individu.name = "Paul"
print(individu.name)

// Modification via la fonction du type
individu.changeName(for: "Jacques")
print(individu.name)
/*:
 ## Ce qu'on aime généralement pour rendre notre code de meilleure qualité
 * Modifier la propriété en elle-même **uniquement dans la définition du type**
 * Modifier la propriété **uniquement via une fonction si en dehors de la définition du type**
 * Permet d'indiquer qu'on est au courant de ces changements => intention de code

 On aurait pu mettre la propriété en `private` mais on ne pourrait plus accéder au getter en dehors de la définition du type
 */

/*:
 ## Pour améliorer ce code, on doit passer le setter en private et laisser le getter en open
 * Utilisation du `private(set)`
 */
struct PersonBis {
  private(set) var name: String

  mutating func changeName(for name: String) {
    self.name = name
  }
}

var personne = PersonBis(name: "Lucas")

// Modification via la propriété du type impossible : setter non accessible
// lucasBis.name = "Marc" // KO

// Getter toujours accessible
print(personne.name)

// Modification via la fonction du type
personne.changeName(for: "David")
print(personne.name)
