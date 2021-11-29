import Foundation
/*:
 # Quel problème résout l'utilisation des actors ?
 */
/*:
 * Les `actor` permettent de résoudre le problème des **Data Races**
 * Les Data Races se produisent lorsque **plusieurs threads accèdent simultanément à une donnée mutable d'un objet et qu'au moins un de ces threads modifie la valeur de cette donnée**
 * Ces Datas Races peuvent entraîner des comportements imprévisibles : crashs, corruption de la mémoire, tests bancales etc...
 */
//: * Exemple d'une `class` qui va provoquer des Data Races
final class DataRacesSample {

  private var stuff: [String: String] = [:]
  
  func setValue(_ string: String, for key: String) {
    stuff[key] = string
  }
  
  func getValue(for key: String) -> String? {
    return stuff[key]
  }
  
  func getAll() -> [String: String] {
    return stuff
  }
}

func runDataRace() {
  let sample = DataRacesSample()
  DispatchQueue.concurrentPerform(iterations: 20) { index in
    sample.setValue("value \(index)", for: "key-\(index)")
    print(sample.getAll())
  }
  print(sample.getAll())
}
//runDataRace() // Uncommenter pour run et voir le crash
/*:
 * Pour résoudre ce problème avant l'arrivée des `actor`, on devait gérer la synchronisation à la mano comme il suit
    * Création d'une `DispatchQueue` utilisée **uniquement** au sein de cette `class`
    * Synchronisation des accès à la donnée mutable via le `barrier` flag
 */
final class DataRacesFixedSample {
  private var stuff: [String: String] = [:]
  private let queue = DispatchQueue(label: UUID().uuidString)
  
  func setValue(_ string: String, for key: String) {
    queue.async(flags: .barrier) {
      self.stuff[key] = string
    }
  }
  
  func getAll() -> [String: String] {
    return stuff
  }
}

func runDataRaceFixed() {
  let sample = DataRacesFixedSample()
  let dispatchGroup = DispatchGroup()
  DispatchQueue.concurrentPerform(iterations: 20) { index in
    dispatchGroup.enter()
    sample.setValue("value \(index)", for: "key-\(index)")
    dispatchGroup.leave()
  }
  dispatchGroup.notify(queue: .global()) {
    print(sample.getAll())
    print("Number of elements : ", sample.getAll().keys.count)
  }
}
runDataRaceFixed()
/*:
 * Cependant cette **solution possède de nombreux inconvénients**, car il y a beacoup de code à maintenir :
    * Le `barrier` flag est requis pour arrêter la lecture pendant un moment et permettre l'écriture
    * Le compilateur ne peut pas nous aider
 */
//:[Home](Home)           [Next: Définition & utilisation d'un `actor` >](@next)
