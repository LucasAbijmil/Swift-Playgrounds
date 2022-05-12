import Foundation
/*:
 # any marqueur d'*existentials types*
 * [SE-0335](https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md) introduit `any` un nouveau mot clé, pour marquer l'utilisation d'*existentials types*
 * Il introduit un profond changement dans le language et **risque de breaker beaucoup de code dans les prochaines versions de Swift**
 */
//: * Un protocol permet de spécifier un ensemble de requierements auxquels les types doivent se conformer
protocol Animal {
  func makeSound()
}
//: * On peut utiliser un protocol en tant que *generic constraints*
func playSound<T: Animal>(of animal: T) {
  animal.makeSound()
}
//: * Ou, utiliser le protocol en tant que type
func playSound(of animal: Animal) {
  animal.makeSound()
}
/*:
 * Dans le dernier exemple, le **protocol est considéré comme un *existential type***
 * Un *existential type* est un type abstrait qui peut être de n'importe quel type se conformant à ce protocol
 * En bref, **dès qu'on utilise un protocol en tant que type, on utilise un *existential type*** (property ou paramètre de fonction)
 * Dans notre vie de développeur, on préfère à 99,99% du temps la deuxième signature de fonction, pour diverses raisons :
    * Lisibilité du code
    * Suivre les standards définit par Clean Code qui préfère utiliser un *existential type* en tant que paramètre plutôt qu'en tant que *generic constraint*
 * Cependant, cela a des conséquences sur les performances de notre application
 */
//:  * Prenons un autre exemple, qui illustre plus nos contraintes de code
protocol Vehicle {
  func travel(to destination: String)
}

struct Car: Vehicle {

  func travel(to destination: String) {
    print("I'm driving to \(destination)")
  }
}
//: * Instanciation d'une `Car`
let carAsCar = Car()
//: * Instanciation d'une `Car` en tant que `Vehicle`
let carAsVehicle: Vehicle = Car()
carAsCar.travel(to: "Paris") // Ok
carAsVehicle.travel(to: "Paris") // Ok
/*:
 * Au moment de la compilation, en utilisant le protocol en tant que *generic constraint*, Swift arrive à savoir quel est le type sous-jacent qui appele la fonction (le type se conformant au protocol)
 * En d'autres termes, **Swift sait à la compilation qu'on appele la fonction avec une `Car` permettant de créer du code optimisé, très performant à l'exécution**
 * Ce processus est nommé *Static Dispatch*
 */
func travel<T: Vehicle>(to destinations: [String], using vehicle: T) {
  destinations.forEach(vehicle.travel)
}
travel(to: ["Paris", "Nice"], using: carAsCar) // ok – création de code optimisé à la compilation
// travel(to: ["Paris", "Nice"], using: carAsVehicle) // error: `Protocol 'Vehicle' as a type cannot conform to the protocol itself` (logique, meh)
/*:
 * À l'inverse en utilisant le protocol en tant qu'*existential type* **Swift ne peut rien savoir au moment de la compilation et devra tout resolver au runtime**
 * À chaque fois qu'on va exécuter une fonction utilisant un *existential type*, Swift devra faire une recherche au sein d'une *Witness Table* pour trouver la bonne méthode sous-jacente à appeler
 * Cela signifie qu'on doit également utiliser de la mémoire dynamique afin d'allouer le concrete type se conformant à ce protocol
 * Ce processus est nommée *Dynamic Dispatch*, **bien moins rapide et efficace** que le *Static Dispatch*
 */
func travel2(to destinations: [String], using vehicle: Vehicle) {
  destinations.forEach(vehicle.travel)
}
travel2(to: ["London", "Paris"], using: carAsCar) // ok – resolve au runtime
travel2(to: ["London", "Paris"], using: carAsVehicle) // ok – resolve au runtime
/*:
 * Swift était dans une situation où les deux utilisations des protocols était très similaires, et où celle utilisant l'***existential type* était la plus facile à écrire, mais la plus lente**
 * Pour résoudre ce problème, Swift 5.6 introduit le mot clé `any` à utiliser uniquement avec des *existentials types* permettant de marquer explicitement les impacts au runtime
 * Dans Swift 5.6 le processus est activé et fonctionne, mais dans les futures versions le fait de ne pas utiliser le mot clé `any` générera un warning
 * À partir de Swift 6, cela générera une erreur
 * **L'utilisation de `any` ne change rien aux performances, il permet juste de mettre un flag indiquant toutes les implications citées ci-dessus**
 * On doit donc transformer notre code :
 */
//: * Instanciation d'une `Car` en tant que `Vehicle` à partir de Swift 5.6
let carAsVehicleWithAny: any Vehicle = Car()
carAsVehicleWithAny.travel(to: "Paris") // ok
//: * Utilisation d'un `Vehicle` en tant que paramètre d'une fonction à partir de Swift 5.6
func travel3(to destinations: [String], using vehicle: any Vehicle) {
  destinations.forEach(vehicle.travel)
}
//: [Home](Home)           [Next: Type placeholders >](@next)
