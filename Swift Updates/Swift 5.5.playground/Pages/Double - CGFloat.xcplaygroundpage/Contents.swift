import Foundation
import CoreGraphics
/*:
 # Cast implicite Double vers CGFloat et CGFloat vers Double
 * Pour rappel un `Double` est codé sur 64 bits et un `CGFloat` sur 32 bits
 */
//: * Exemple d'un `Double` converti en `CGFloat` implicitement
func foo(float: CGFloat) -> CGFloat { return float }
let doubleThree = 3.0
let fooFloat = foo(float: doubleThree)
print("Type of the arg is : \(type(of: doubleThree)) | Type of the return is : \(type(of: fooFloat))")
//: * Exemple d'un `CGFloat` converti en `Double` implicitement
func foo(double: Double) -> Double { return double }
let cgFloatThree: CGFloat = 3.0
let fooDouble = foo(double: cgFloatThree)
print("Type of the arg is : \(type(of: cgFloatThree)) | Type of the return is : \(type(of: fooDouble))")
//: * Remarque : Le compilateur préféreras **toujours utiliser un `Double` car il permet d'avoir un maximum de précision** (car codé sur 64 bits).
let randomDouble = Double.random(in: 0...100)
let randomCgFloat = CGFloat.random(in: 0...100)
let result = randomDouble + randomCgFloat
print("Type of the addition is : \(type(of: result))")
//: [< Previous: Computed Property `get` only](@previous)           [Home](Home)           [Next: `lazy var` in local context >](@next)
