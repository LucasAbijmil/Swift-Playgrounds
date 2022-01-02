import Foundation
/*:
 # Protocol Composition
 * Permet de *composer* (ie: grouper) plusieurs `protocol` en un seul grâce à un `typealias`
 * Permet de faciliter la lecture (surtout lorsqu'il y a beaucoup de `protocol` !)
 * À utiliser lorsqu'un objet se conforme à plusieurs `protocol` mais qui n'ont pas de *relation sémantique*, autrement on préferera le [protocol inheritance](Protocol%20Inheritance)
 */
protocol Player {
  var name: String { get set }
  var score: Int { get set }
}

protocol Loggable {
  var filename: String { get }
  init(filename: String)
  func log(_ message: String)
}

protocol Advertiser {}

//: Objet qui se conforme à ces 3 protocols sans la composition
struct ObjetWithAllProtocols: Player, Loggable, Advertiser {

  var name: String = ""
  var score: Int = 0
  var filename: String

  init(filename: String) {
    self.filename = filename
  }

  func log(_ message: String) {
    print(message)
  }
}
//: Création d'un `typealias` *groupant* tous les `protocol` qu'un objet va se conformer
typealias AllProtocols = Player & Loggable & Advertiser

//: Objet qui se conforme à ces 3 protocols sans la composition
struct ObjectWithTypealias: AllProtocols {
  var name: String = ""
  var score: Int = 0
  var filename: String

  init(filename: String) {
    self.filename = filename
  }

  func log(_ message: String) {
    print(message)
  }
}
//: [< Previous: Protocol inheritance & POP](@previous)           [Home](Introduction)           [Next >](@next)
