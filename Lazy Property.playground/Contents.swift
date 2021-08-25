import Foundation
/*:
 # **Lazy Property**
 * `Lazy` : "just in time", la property repousse le travail jusqu'à ce qu'on en est besoin
 * Une property `lazy` n'est calculée qu'une **seule fois** (ou zéro si jamais accédée), à l'inverse d'une `computed` property qui est, elle, recalculée à chaque accès
 * À utiliser lorsque :
    * La property a besoin de connaître la valeur de d'autres properties
    * Le calcul de la property est important / complexe (= long)
 */
//: **Cas n°1** : Property qui a besoin de connaître la valeur de d'autres properties
struct Player {
  var name: String
  var team: String
  var position: String

  // Doit être lazy car à l'initialisation on ne connait pas les valeurs pour : name, position & team
  lazy var introduction: String = {
    return "Now entering the game: \(name), \(position) for the \(team)"
  }()
}
var jordan = Player(name: "Jordan", team: "Bulls", position: "Shooting guard")
print(jordan.introduction)
//: **Cas n°2** : Property donc le calcul est important / complexe (= long)
struct Calculator {
  static func calculateGamesPlayed() -> Int {
    var games = [Int]()
    for i in 1...4_000 {
      games.append(i)
      print("Append games n°\(i)")
    }
    return games.last!
  }
}
//: * Property "chère" a calculer à l'init
struct Players {
  var name: String
  var team: String
  var position: String
  var gamesPlayed = Calculator.calculateGamesPlayed()
}
/*:
 Création d'une instance du type `Players` avec `gamesPlayed` calculé lors de l'init, car valeur par défaut.
 * Computation de `gamesPlayed` est important (calcul des 4 000 parties) 👉 l'init est donc assez long
 */
var jordans = Players(name: "Jordan", team: "Bulls", position: "Shooting Guard")
//: * Property "chère" marquée `lazy`, donc non calculée à l'init
struct Players2 {
  var name: String
  var team: String
  var position: String
  lazy var gamesPlayed = {
    return Calculator.calculateGamesPlayed()
  }()
}
/*:
 Création d'une instance du type `Players2` avec `gamesPlayed` marqué `lazy`, donc non calculé à l'init.
 * Computation de `gamesPlayed` fait uniquement lors du **premier accès** à cette property 👇
    * Init plus rapide
    * Peut ne jamais être computé si on n'accède jamais à la property
 */
var jordans2 = Players2(name: "Jordan", team: "Bulls", position: "Shooting Guard")
jordans2.gamesPlayed
//: ## Remarques
/*:
 1. `lazy` vs `computed` property
    * `lazy` est computé qu'une **seule fois** (ou zéro si jamais accédée) 👉 à utiliser lorsque la computation est importante ou que la property est dépendante de d'autres properties
    * `lazy` **store** la valeur de la property lors du premier accès
    * `computed` est computé à chaque accès 👉 à utiliser si la property est dépendantes de d'autres property mutables, mais peut coûter cher en calcul
    * `computed` **ne store jamais** la valeur de la property
 */
struct LazyVSComputed {
  var computedGamesPlayed: Int {
    return Calculator.calculateGamesPlayed()
  }

  lazy var lazyGamesPlayed: Int = {
    return Calculator.calculateGamesPlayed()
  }()
}
var lazyVSComputed = LazyVSComputed()
// 👇 LAZY
print(lazyVSComputed.lazyGamesPlayed) // 👈 Calculé ici
print(lazyVSComputed.lazyGamesPlayed) // 👈 Non calculé ici
// 👇 Computed
print(lazyVSComputed.computedGamesPlayed) // 👈 Calculé ici
print(lazyVSComputed.computedGamesPlayed) // 👈 Calculé ici
/*:
 2. Une `lazy` property ne pas être `let` (constante)
    * Compiler error: *'lazy' cannot be used on a let* 👇
    * Une `lazy` property **ne pas être constante** (let) car son getter est mutable. Elle n'est pas computé à l'init d'une instance et on ne sait pas si elle sera computé à un moment ou non.
 */
struct LazyConstante {
  // 👇 K.O
  //  lazy let expensiveToCompute: Int = {
  //    return (0...1000).reduce(0, +)
  //  }()
}
/*:
 3. Une `lazy` property ne peut pas être accéder via une constante d'instance de type `value type` (immutable)
    * Compiler error: *Cannot use mutating getter on immutable value: `lazyness` is a `let` constant* 👇
    * Une `lazy` property à son getter mutable ainsi lors du premier accès à la property, l'état de l'objet change car la valeur sera storée dans celle-ci. Il est donc mutable à l'inverse d'une `value type` (struct)
    * Cependant, une `lazy` property peut être accéder via une constante d'instance de type `reference type`
 */
struct LazynessStruct {
  lazy var expensiveToCompute: Int = {
    return (0...1000).reduce(0, +)
  }()
}
final class LazynessClass {
  lazy var expensiveToCompute: Int = {
    return (0...1000).reduce(0, +)
  }()
}
let lazynessStruct = LazynessStruct()
//lazynessStruct.expensiveToCompute // 👈 K.O.
let lazynessClass = LazynessClass()
lazynessClass.expensiveToCompute // 👈 O.K.
/*:
 4. Les `static` properties sont `lazy` par défaut
    * Compiler error: *Compilator error : 'lazy' must not be used on an already-lazy global*
    * Les `static` properties sont très utilisées, ainsi au démarrage d'un programme, si cela n'était pas le cas, cela couterai très cher en ressource (et prendrait beaucoup de temps !)
 */
extension Float {
  /*lazy*/ static let seven = 7.0
}
/*:
 5. Une `lazy` property n'est pas thread safe, car peut être accédée par plusieurs threads en même temps
    * cf : https://docs.swift.org/swift-book/LanguageGuide/Properties.html
 */
