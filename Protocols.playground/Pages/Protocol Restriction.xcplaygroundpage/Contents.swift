import SwiftUI
/*:
 # Protocol Restriction – Restreindre la conformance à certains types
 * Lorsqu'on travaille avec des `protocol`, on peut de temps en temps vouloir les restreindre à certains types d'objets : `actor`, `class`, etc...
 * Pour cela, on déclare notre `protocol` et on le fait hériter d'un `protocol` (voir [protocol inheritance](Protocol%20Inheritance)), qui permet de le restreindre
 */
/*:
 Par exemple, on peut restreindre un `protocol` où **seul les *references types* (`actor` & `class`) peuvent s'y conformer**

 Pour cela il faut faire hériter le `protocol` en question de `AnyObject`
 */
protocol ReferenceTypeProtocolOnly: AnyObject {}
//: * Conformance à `ReferenceTypeProtocolOnly` par une `class`
final class ClassObject: ReferenceTypeProtocolOnly {}
//: * Conformance à `ReferenceTypeProtocolOnly` par un `actor`
actor ActorObject: ReferenceTypeProtocolOnly {}
//: * Si on essaye de faire conformer une `struct` à `ReferenceTypeProtocolOnly`, cela génère cette erreur : *Non-class type 'xxxx' cannot conform to class protocol 'xxxx'*
struct StructObject: ReferenceTypeProtocolOnly {}
/*:
 On peut aussi restreindre un `protocol` où **seul les `actor` peuvent s'y conformer**

 Pour cela il faut faire hériter le `protocol` en question de `Actor`
 */
protocol ActorProtocolOnly: Actor {}
//: * Conformance à `ActorProtocolOnly` par un `actor`
actor ActorObject2: ActorProtocolOnly {}
//: * Si on essaye de faire conformer une `class` à `ActorProtocolOnly`, cela génère une erreur : *Non-actor type 'xxxx' cannot conform to the 'Actor' protocol*
final class ClassObject2: ActorProtocolOnly {}
//: * Si on essaye de faire conformer une `struct` à `ActorProtocolOnly`, cela génère une erreur : *Non-class type 'xxxx' cannot conform to class protocol 'Actor'*
struct StructObject2: ActorProtocolOnly {}
/*:
 Enfin on peut restreindre un `protocol` où **seul les `globalActor`, c'est-à-dire des `actors` peuvent s'y conformer**

 Pour cela il faut faire hériter le `protocol` en question de `GlobalACtor`
 */
protocol GlobalActorProtocolOnly: GlobalActor {}
//: * Conformance à `GlobalActorProtocolOnly` par un `actor`
actor ActorObject3: GlobalActorProtocolOnly {
  static var shared = ActorObject3()
}
//: [< Previous: Protocol Composition](@previous)           [Home](Introduction)           [Next >](@next)
