import Foundation
/*:
 # **Injection de dépendances**
 * L'injection de dépendances consiste à fournir des instances (objets déjà initialiasés) pour l'initialisation d'un autre objet
 */
final class RequestManager {

  var name = "RequestManager"
}
let requestManager = RequestManager()
/*:
 ### Exemple
 * **Sans injection de dépendance**, puisque la class *ViewModel* créer l'instance de *RequestManager* à l'intérieur de sa définition
 */
final class ViewModel {
  var requestManager = RequestManager()
}
let viewModel = ViewModel()
//: * **Avec injection de dépendance**, puisqu'on fournit une instance de *RequestManager* pour l'initialisation de la class *ViewModelBis*
final class ViewModelBis {
  var requestManager: RequestManager

  init(requestManager: RequestManager) {
    self.requestManager = requestManager
  }
}
let viewModelBis = ViewModelBis(requestManager: requestManager)
/*:
 ### Avantage de l'injection de dépendances :
 * Les properties et la class (en elle-même) sont totalement découplés, la class ne créer aucun objet à part elle même ––> SOLID
 * Les responsabilités et les requierements de la class sont clairement identifiables et identifiés
 * Unit Test plus facile à mettre en place car tous les objets sont isolés / découplés les un des autres
*/

/*:
 ### Injection de dépendances via la POP
 * Avec Swift, les injections de dépendances sont encore plus puissantes via la POP
 * Le viewModel n'est plus contraint à un unique objet du type, ainsi, il peut donc être initialisé par n'importe quel objet du type du protocol
 * Le viewModel est donc ainsi découplé de tout objet du type du protocol et de l'implémentation des fonctionnalités
 */
protocol Serializer {
  func serialize(data: Any) -> Data?
}

class RequestSerializer: Serializer {
  func serialize(data: Any) -> Data? { return nil }
}

class ViewModelSerializer {
  var serializer: Serializer

  init(serializer: Serializer) {
    self.serializer = serializer
  }
}
let serializer = RequestSerializer()
let viewModelSerializer = ViewModelSerializer(serializer: serializer)
/*:
 ### Les 3 types d'injection de dépendances :
 * **Initializer Injection** (le plus courant)
 */
class InitializerInjection {
  var requestManager: RequestManager

  init(requestManager: RequestManager) {
    self.requestManager = requestManager
  }
}
InitializerInjection(requestManager: requestManager)
//: * **Property Injection**
class PropertyInjection {
  var requestManager: RequestManager?
}
let propertyInjection = PropertyInjection()
propertyInjection.requestManager = requestManager
//: * **Method Injection**
class MethodInjection {
  var requestManager: RequestManager?

  func initializeRequestManager(requestManager: RequestManager) {
    self.requestManager = requestManager
  }
}
let methodInjection = MethodInjection()
methodInjection.initializeRequestManager(requestManager: requestManager)
