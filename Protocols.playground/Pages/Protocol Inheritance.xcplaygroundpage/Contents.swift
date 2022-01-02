/*:
 # Protocol inheritance
 * Un des pilliers de la POP 👉 évite les *massiv `protocol`*
 * Permet aux `protocols` d'hériter d'autres `protocols` et d'ajouter de nouveaux requierements propres à ce `protocol` si besoin
 * À utiliser uniquement s'il y a une *relation sémantique*, autrement on préferera le [protocol composition](Protocol%20Composition)
 */
/*:
 Exemple d'un *massiv protocol* `GameUnit` représentant tout type d'unité dans un jeu-vidéo
 */
protocol GameUnit {
  var name: String { get }
  var position: (x: Float, y: Float) { get set }
  var health: UInt { get set }
  var hitPower: UInt { get set }

  mutating func moveBy(_ x: Float, _ y: Float)
  func fireAt(unit: inout GameUnit)
}
//: Exemple d'une class `Trooper` qui se conforme à ce `protocol`
final class Trooper: GameUnit {

  var name: String
  var position: (x: Float, y: Float)
  var health: UInt
  var hitPower: UInt

  init(name: String, position: (Float, Float), health: UInt, hitPower: UInt) {
    self.name = name
    self.position = position
    self.health = health
    self.hitPower = hitPower
  }

  func moveBy(_ x: Float, _ y: Float) {
    self.position.x += x
    self.position.y += y
  }

  func fireAt(unit: inout GameUnit) {
    unit.health -= 1
  }
}
/*:
 Exemple d'une class `Building` qui se conforme à ce `protocol`
 * On remarque que `moveBy` et `fireAt` ne sont pas nécessaires pour cet objet
 * Conclusion 👉 `GameUnit` est *massiv* puisque certaines unités ne font pas d'implémentation propre pour certains requierements
 */
final class Building: GameUnit {

  var name: String
  var position: (x: Float, y: Float)
  var health: UInt
  var hitPower: UInt

  init(name: String, position: (Float, Float), health: UInt, hitPower: UInt) {
    self.name = name
    self.position = position
    self.health = health
    self.hitPower = hitPower
  }

  func moveBy(_ x: Float, _ y: Float) {
    // MARK: NOT NEEDED CAUSE BUILDING CAN'T MOVE
  }

  func fireAt(unit: inout GameUnit) {
    // MARK: NOT NEEDED
  }
}
/*:
 `GameUnit` a donc trop de responsabilité / requierements 👇
 * Création de plusieurs `protocols` qui pourront hérité les uns des autres pour un design plus conscencieux
 */
/*:
 Chaque unité dans le jeu doit avoir comme properties un `name`, `position` & `health` 👇
 * Création d'un `protocol BaseGameUnit` qui a ces requierements
 */
protocol BaseGameUnit {
  var name: String { get }
  var position: (x: Float, y: Float) { get set }
  var health: UInt { get set }
}
/*:
 Une unité peut être mouvante, c'est donc un `BaseGameUnit` mais avec la function `moveBy`
 * Création d'un `protocol MovingGameUnit` héritant de `BaseGameUnit` et qui a comme requierement en plus la function `moveBy`
 */
protocol MovingGameUnit: BaseGameUnit {
  mutating func moveBy(_ x: Float, _ y: Float)
}
/*:
 Une unité peut tirer, c'est donc un `BaseGameUnit` mais avec la propriété `hitPower` et la function `fireAt`
 * Création d'un `protocol MilitaryGameUnit` héritant de `BaseGameUnit` et qui a comme requierement en plus la property `hitPower` et la function `fireAt`
 */
protocol MilitaryGameUnit: BaseGameUnit {
  var hitPower: UInt { get set }

  func fireAt(unit: inout BaseGameUnit)
}
//: Un building est donc de type / se conforme à `BaseGameUnit` car ne tire pas et ne se déplace pas (≠ `MovingGameUnit` & `MilitaryGameUnit`)
final class Buildings: BaseGameUnit {

  var name: String
  var position: (x: Float, y: Float)
  var health: UInt

  init(name: String, position: (Float, Float), health: UInt) {
    self.name = name
    self.position = position
    self.health = health
  }
}
//: Créons un objet représentant une unité mouvante `Horse`. Il est donc du type / se conforme à `MovingGameUnit`
struct Horse: MovingGameUnit {

  var name: String
  var position: (x: Float, y: Float)
  var health: UInt

  mutating func moveBy(_ x: Float, _ y: Float) {
    self.position.x += x
    self.position.y += y
  }
}
//: Créons un objet représentant une unité mouvante et qui peut tirer `Warrior`. Il est donc du type / se conforme à `MovingGameUnit` & `MilitaryGameUnit`
struct Warrior: MovingGameUnit, MilitaryGameUnit {

  var name: String
  var position: (x: Float, y: Float)
  var health: UInt
  var hitPower: UInt

  mutating func moveBy(_ x: Float, _ y: Float) {
    self.position.x += x
    self.position.y += y
  }

  func fireAt(unit: inout BaseGameUnit) {
    unit.health -= 2
  }
}
/*:
 Pour les unités qui tire et se déplace, celles-ci doivent se conformer à `MovingGameUnit` & `MilitaryGameUnit`.

 Étant donné qu'il y a une *relation sémantique* entre ces deux protocols, on peut créer un nouveau protocol `MovingMilitaryUnit` héritant de `MovingGameUnit` & `MilitaryGameUnit`
 */
protocol MovingMilitaryUnit: MovingGameUnit, MilitaryGameUnit {}

struct Soldier: MovingMilitaryUnit {
  var name: String
  var position: (x: Float, y: Float)
  var health: UInt
  var hitPower: UInt

  mutating func moveBy(_ x: Float, _ y: Float) {
    self.position.x += x
    self.position.y += y
  }

  func fireAt(unit: inout BaseGameUnit) {
    unit.health -= 2
  }
}
//: [< Previous: Protocol & implémentation par défaut](@previous)           [Home](Introduction)           [Next: Protocol Composition >](@next)
