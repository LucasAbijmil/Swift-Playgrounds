import Foundation
/*:
 ### Définir des `URL` avec des `StaticString` au compile time, les rendant immutables pendant le runtime
 * permet d'éviter de force unwrap les `URL` connus et qu'on déclare à la mano

 L'`init(string: _)` oblige de force unwrap, car cette `URL` peut changer pendant le runtime. En la force unwrappant on indique implicitement qu'elle ne pourra changer pendant le runtime
 */
let url = URL(string: "https://www.google.fr")!
/*: `StaticString` : `String` connue au compile time qui ne pourra être modifiée pendant le runtime
 * Grâce à ce type on va pouvoir définir des `URL` qu'on passe à la mano (et donc qui ne changeront pas au runtime)
 * **Extension sur `URL` avec un force unwrap qui a du sens (vu que la `String` est immutable au runtime)**
 */
extension URL {

  init(staticString: StaticString) {
    self.init(string: "\(staticString)")!
  }
}

let url2 = URL(staticString: "https://www.google.fr")

//: Pour rajouter des paths à des `URL` créée à partir de cette extension : utiliser la fonction `appendPathComponent`
var url3 = URL(staticString: "https://www.google.fr")
url3.appendPathComponent("maps")
//: [< Previous: Custom `String Interpolation`](@previous)           [Home](Introduction)           [Next >](@next)
