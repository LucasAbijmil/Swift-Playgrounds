 import Foundation
//: ### **enumerated** : **accès à l'index et la value d'un array sans avoir à gérer l'index et subscript à l'array**
let people = ["Pierre", "Paul", "Jacques", "Michel", "Patrick"]
/*:
**Façon naïves d'accéder à l'index et la value d'un array** :
*  Pas très Swifty : car on doit gérer les index nous mêmes et subscript à l'array avec l'index donné (assez bas level)
*  Possibilité une fatal error : si on subscript à l'array avec un index hors de sa range
*/

for currentIndex in people.indices {
  let currentValue = people[currentIndex]
  print("Current value : \(currentValue), current index : \(currentIndex)")
}
print("–––––")

/*:
  **Façon plus Swifty, utiliser la fonction `enumerated()`** :
  *  Fonction qui renvoie un tuple, dans l'ordre : index, value
  *  Avantage : pas de gestion des index (sûr que le code ne va jamais crasher)
*/

for (index, value) in people.enumerated() {
  print("Current value : \(value), current index : \(index)")
}
print("–––––")

/*:
**Exemple pour éviter de faire une boucle `for` : on "déplace" le tuple dans les paramètres de la closure des fonctions `map` / `forEach`**
  */

people.enumerated().map { (index, value) in
  print("Current value : \(value), current index : \(index)")
}

print("–––––")
 
people.enumerated().forEach { (index, value) in
  print("Current value : \(value), current index : \(index)")
}
//: [Home](Introduction)           [Next : `zip()` >](@next)
