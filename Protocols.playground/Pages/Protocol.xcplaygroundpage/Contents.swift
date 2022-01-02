import Foundation
/*:
 # Déclaration & Conformance à un protocol
 * Un `protocol` est une interface qui définit les `properties` et `functions` requises pour être du type / conforme à ce `protocol`
 * Dans la déclaration d'un `protocol` on ne fait que déclarer les `properties` et `functions` (incluant l'`init`), **on ne fait pas l'implémentation**
 * Pour les `value type`, il faudra préciser le `mutating` avant les fonctions si cela est nécessaire
 */
/*:
 Les `properties` doivent être déclaré `get` ou `get set` :
 * `get` : constante, variable, computed property (get only) ou private(set) 👉 non mutable en dehors de sa définition
 * `get set` : variable ou computed property (get & set) 👉 mutable en dehors de sa définition
 * Par défaut le compilateur met toutes les `properties` en variable car il les considère en tant que `computed properties`
 */
protocol CryptoCurrency {
  var name: String { get }
  var price: Int { get set }

  init(price: Int)

  func showHistory()
  mutating func transfer()
}
//: Création d'une `struct` conforme au protocol `CryptoCurrency`
struct Bitcoin: CryptoCurrency {

  let name: String
  var price: Int

  init(price: Int) {
    self.name = "Btc"
    self.price = price
  }

  func showHistory() {
    print(name, "history is so bad !")
  }

  mutating func transfer() {
    print("Transfering", name, "...")
    price += 100
    print("Actual price", price)
  }
}
//: Création d'une `final class` conforme au protocol `CryptoCurrency`
final class Ethereum: CryptoCurrency {

  let name: String
  var price: Int

  init(price: Int) {
    self.name = "Eth"
    self.price = price
  }

  func showHistory() {
    print(name, "history is so cool !")
  }

  func transfer() {
    print("Transfering", name, "...")
    price += 1000
    print("Actual price", price)
  }
}
/*:
 Avantage d'utiliser les `protocols` plutôt que l'héritage de class :
 * Implémentation propre à chaque objet conforme / du type du `protocol`
 * Une `value type` ou `reference type` peut être conforme à un même `protocol`
 * On peut se conformer à plusieurs `protocols` tandis qu'on peut hériter que d'une **seule class** en Swift
 * Combiner plusieurs objets qui sont conformes au même protocol 👇
 */
let cryptoCurrencies: [CryptoCurrency] = [Bitcoin(price: 900), Ethereum(price: 500)]
cryptoCurrencies.forEach { print($0.name, $0.price) }
cryptoCurrencies.forEach { $0.showHistory() }
//: [Home](Introduction)           [Next: Protocol & optional requierements >](@next)
