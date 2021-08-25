import Foundation

//: ### **zip**(array1, array2) : **boucler simultanément sur deux collections d'indice différents**

let ints = [1, 2, 3, 4, 5]
let strings = ["Hello", "world", "welcome"]

/*:
**Façon naïves de boucler sur deux collections** :
*  Connaître l'index le plus petit via la fonction min
*  Boucler jusqu'à cet index pour ne pas subscript sur le plus petit tableau (pour éviter un crash / fatalError)
 */

for indice in 0..<min(ints.count, strings.count) {
  print("ints value : \(ints[indice]) – strings value : \(strings[indice])")
}
print("––––")

/*:
**Façon plus Swifty, utiliser la fonction `zip(array1, array2)`** :
 * Fonction qui renvoie un tuple : (value1, value2) respectivement des array1 et array2
*  Avantage : pas besoin de se préocuper de la gestions des index, fatalError etc...
*/
for (int, string) in zip(ints, strings) {
  print("ints value : \(int) – strings value : \(string)")
}

print("––––")

/*:
**Exemple pour éviter de faire une boucle `for` : on "déplace" le tuple dans les paramètres de la closure des fonctions `map` / `forEach`**
  */

zip(ints, strings).map { (int, string) in
  print("ints value : \(int) – strings value : \(string)")
}

print("––––")

zip(ints, strings).forEach { (int, string) in
  print("ints value : \(int) – strings value : \(string)")
}
//: [< Previous : `enumerated()`](@previous)           [Home](Introduction)           [Next : `SafeSubscript` >](@next)
