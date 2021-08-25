import Foundation
/*:
 # **`try`, `try?`, `try!` & throws functions**
 * Permet d'exécuter une fonction qui peut `throw` et qui peut donc générer des erreurs
 */

//: Déclaration d'une `Enum` pour connaître la localisation
enum BatmanLocation {
  case atHome
  case atGym
  case onMission
}
var batmanLocation: BatmanLocation = .atHome
//: Déclaration des erreurs grâce à une `Enum` conforme au protocol `Error`
enum BatmanIdentityError: Error {
  case atGym
  case onMission
  case uknown

  var message: String {
    switch self {
    case .atGym:
      return "At gym"
    case .onMission:
      return "On mission"
    case .uknown:
      return "Uknown error"
    }
  }
}

//: Déclaration d'une fonction qui peut générer des erreurs (`throws`)
func getBatmanIdentity() throws -> String {
  if case .atHome = batmanLocation {
    return "Bruce Wayne"
  } else if case .atGym = batmanLocation {
    throw BatmanIdentityError.atGym
  } else if case .onMission = batmanLocation {
    throw BatmanIdentityError.onMission
  }
  throw BatmanIdentityError.uknown
}


/*:
 ## Il existe trois façons pour exécuter une fonction qui `throw`
 * `try` : dans un block `do` / `catch`, permet de return le résultat ou l'erreur s'il y en a une
 */

//:     Gestions des erreurs une par une
do {
  let batmanIdentity = try getBatmanIdentity()
  print(batmanIdentity)
} catch BatmanIdentityError.atGym {
  print(BatmanIdentityError.atGym.message)
} catch BatmanIdentityError.onMission {
  print(BatmanIdentityError.onMission.message)
} catch { // catch seul = toutes les erreurs possible sauf celles déjà listée au-dessus d'elle
  print(BatmanIdentityError.uknown.message)
}
//:     Un unique catch pour toutes les erreurs de type BatmanIdentityError
do {
  let batmanIdentity = try getBatmanIdentity()
  print(batmanIdentity)
} catch let (error as BatmanIdentityError) {
  print(error.message)
}
//:     On peut combiner la gestions d'erreurs en utilisant la ","
do {
  let batmanIdentity = try getBatmanIdentity()
  print(batmanIdentity)
} catch BatmanIdentityError.atGym, BatmanIdentityError.onMission {
  print("Batman is at gym or on a mission")
} catch { // catch toutes les erreurs sauf celles déjà listés au dessus (atGym et onMission)
  print(BatmanIdentityError.uknown.message)
}
//:     try sans cas d'erreur spécifié catch toutes les erreurs (sauf celles déjà catch avant)
do {
  let identity = try getBatmanIdentity()
  print(identity)
} catch BatmanIdentityError.onMission {
  print(BatmanIdentityError.onMission.message)
} catch { // catch toutes les erreurs possible sauf celles déjà listés au dessus (onMission ici dans ce cas)
  print(BatmanIdentityError.uknown.message)
}
//:     Un seul catch qui va catch toutes les erreurs
do {
  let identity = try getBatmanIdentity()
  print(identity)
} catch { // catch toutes les erreurs
  print(BatmanIdentityError.uknown.message)
}
//: * `try?` : return le résultat en optionnel / `nil` en cas d'erreur
let optionnalBatmanIdentity = try? getBatmanIdentity()
print(optionnalBatmanIdentity)
//:     Unwrap le résultat optionnel d'un try? avec un if let / guard let
if let nonOptionnalBatmanIdentity = try? getBatmanIdentity() { print(nonOptionnalBatmanIdentity) }
//: * `try!` : return le résultat en unwrappant l'optionnel / `fatalError` en cas d'erreur
let unwrapOptionnalBatmanIdentity = try! getBatmanIdentity()
print(unwrapOptionnalBatmanIdentity)
//: [Home](introduction)           [Next: `rethrows` >](@next)
