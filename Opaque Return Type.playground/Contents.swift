import Foundation
/*:
 # Opaque Return Type & `Some`
 * Uniquement pour des return dont le type est un protocol
 * Présent notamment dans SwiftUI 👉 `var body: some View`
    * Le body s'attend à être de type `View` mais ne sait pas que quels `View` il sera composé
 */
//: Disons que je veux implémenter une fonction `getData` dont le `return` est un type conforme au protocol `Collection` (Array, Dictionnary etc...)
func getData() -> Collection {
  return [1, 2, 3, 4, 5]
}
/*:
 Raison de l'erreur du compilateur :
 * Le protocol `Collection` est un protocol avec un `associatedtype` (appellé `Element`) 👇
    * On ne peut pas utiliser ce protocol comme un `return type` ou type de variable
    * On peut uniquement utiliser ce protocol comme une *generic constraint*
 */
/*:
 L'utilisation du mot clé `some` résout ce type de problème 👇
 * Signification 👉 cette function return *some type* qui conforme au protocol retourné (ici `Collection`)
 * Grâce à `some` le compilo connaît le type qui va être retourné par la fonction (ici Array)
 */
func getDatas() -> some Collection {
  return [1, 2, 3, 4, 5]
}
/*:
 **Limitation du `some`**
 * On ne peut retourner qu'un **unique** type qui est conforme au protocol retourné pour un `opaque return type` 👇
 * On peut donc **soit retourné un Array soit un Dictionnary**
 */
func getArrayOrDictionary() -> some Collection {
  return Bool.random() ? [1, 2, 3, 4, 5] : [1: "one", 2: "two", 3: "three", 4: "four", 5: "five"]
}
let data = getDatas()
data.count
//: * `element` n'est pas de type `Int` (même si le compilo le sait), mais de type `((some Collection).Element)?` 👉 due à l'`opaque return type`
let element = data.randomElement()
//: * Si on veut utiliser `element` comme un `Int`, on fait un `cast` classique
if let element = element as? Int {
  print("I'm a Integer, here's my value : \(element)")
} else {
  print("I'm not a Integer")
}

func getOneTypeOfValue() -> some Equatable {
  return 0
}
let firstValue = getOneTypeOfValue()
let secondValue = getOneTypeOfValue()
/*:
 * Vérifions l'égalité de deux values venant d'un même `opaque return type`
    * Le code compile 👉 ces deux valeurs ont été obtenu grâce à la même fonction avec un `opaque return type`
    * Le type du `some Equatable` de `firstValue` & `secondValue` est donc le *même*
 */
firstValue == secondValue

func getAnotherTypeOfValue() -> some Equatable {
  return 1
}

let thirdValue = getAnotherTypeOfValue()
/*:
 * Vérifions l'égalité de deux values ne venant pas du même `opaque return type`
    * Le code ne compile pas 👉 ces deux valeurs ont été obtenu par deux fonctions différente avec un `opaque return type` potentiellement différent 👇
    * Même si c'est deux fonctions retournent `some Equatable`, ce type peut être différent d'une fonction à l'autre
 */
firstValue == thirdValue
