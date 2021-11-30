import SwiftUI
/*:
 # @globalActor, GlobalActor & @MainActor
 */
/*:
 * Les `@globalActor` ont un mécanisme similaire à celui des actors
 * Lorsqu'un `actor` est décoré avec `@globalActor`, il peut être **considéré comme un singleton : il ne peut y avoir qu'une seule instance par type de `@globalActor`**
 * *Behind the scenes*, on fait conformer notre `@globalActor` au protocol `GlobalActor` qui possède un requierement : avoir une `shared property`
 * **Ce requierement permet de garantir l'existence d'une instance unique pour un `@globalActor` donné**
 * On peut définir notre propre `@globalActor` comme il suit :
 */
@globalActor actor LucasActor {
  static var shared = LucasActor()
}
//: * Grâce au protocol `GlobalActor`, on peut restreindre certains protocols via la POP (*Protocol Oriented Programming*)
protocol CoolActor: GlobalActor {}
/*:
 * Ces **`@globalActor` peuvent être appliqués à toute déclaration pour spécifier que ces types sont isolées à ce type de `@globalActor`**
 * Lorsqu'on utilise une telle déclaration à partir d'un `actor` ou depuis un contexte non isolé, **la synchronisation est effectuée par l'instance du `@globalActor` grâce à la `shared property` qui garantit un accès mutuellement exclusif**
 
 * Une `class` peut être décoré avec un `@globalActor` si :
    * **Elle n'a pas de superclass**
    * **La superclass est décoré avec le même `@globalActor`**
    * **La superclass est un `NSObject`**
 * **Une `subclass` d'une `class` décoré par `@globalActor` doit être isolée par le même `@globalActor`**
 */
//: * Exemple d'une `class` qui n'a pas de superclass
@LucasActor class LucasFetcher {}
//: * Exemple où la superclass est annoté avec le même `@globalActor`
@LucasActor final class SmallLucasFetcher: LucasFetcher {}
//: * Exemple où la `class` est un `NSObject`
@LucasActor final class ANSObject: NSObject {}
//: * Les `@globalActor` peuvent être utilisé pour des `property`, `method`, `closure` et `instance`
final class SampleLucasActor {
  @LucasActor private var name = ""
  
  @LucasActor func updateName(with name: String) {
    self.name = name
  }
  
  @LucasActor func fetch(completion: @LucasActor @escaping (Result<String, Error>) -> Void) {
    completion(.success("Lucas"))
  }
}
/*:
 * `@MainActor` est un exemple de `@globalActor`, héritant du protocol `GlobalActor`, **permettant d'exécuter du code sur le main thread**
 * `@MainActor` peut être par exemple, utilisé pour l'instance d'un ViewModel afin qu'il exécute toutes ses updates sur le main thread
 */
@MainActor final class HomeViewModel {}
//: * Comme c'est un `@globalActor`, les `property` et `method` peuvent aussi être décorés de `@MainActor` afin de faire les updates sur le main thread
final class SearchViewModel {
  @MainActor var query = ""
  
  @MainActor func updateQuery(with query: String) {
    self.query = query
  }
}
//: * Si une `property` décorée par `@MainActor` est update dans une `method` qui ne l'est pas, cela génère une erreur : *Property 'xxxx' isolated to global actor 'MainActor' can not be mutated from this context*
final class UserViewModel {
  @MainActor var name = ""
  
  func updateName(for name: String) {
    self.name = name
  }
}
//: * Les `closure` peuvent aussi être décoré avec `@MainActor` afin qu'elles soient exécutées sur le main thread
final class APIFetcher {
  
  func updateData(completion: @MainActor @escaping () -> Void) {
    DispatchQueue.global().async {
      Task {
        await completion()
      }
    }
  }
}
//: * Avant Swift 5.5 on utilisait beaucoup de `DispatchQueue.main.async` afin d'exécuter notre code sur le main thread. On pouvait voir ce genre de code
func fetchData(completion: @escaping (Result<[UIImage], Error>) -> Void) {
  URLSession.shared.dataTask(with: URL(string: "someURL")!) { data, response, error in
    // some complex logic
    DispatchQueue.main.async {
      completion(.success([]))
    }
  }
}
/*:
 * Dans l'exemple ci-dessus on est **sûr à 100% que le `DispatchQueue` est nécessaire**
 * Cependant, forcer l'update sur le main thread pourrait être inutile dans le cas où nous serions déjà sur le main thread, ce qui entraînerait une répartition supplémentaire qui aurait pu être évitée
 
 * Dans ce genre de use, il est p**lus judicieux de décorer la `closure` avec `@MainActor` pour s'assure que les tâches soient exécutées sur le main thread**
 * On peut réécrire la fonction précèdente comme il suit
 */
func fetchDatas(completion: @MainActor @escaping (Result<[UIImage], Error>) -> Void) {
  URLSession.shared.dataTask(with: URL(string: "someURL")!) { data, response, error in
    // some complex logic
    Task {
      await completion(.success([]))
    }
  }
}
/*:
 * **Comme la `closure` est décoré avec `@MainActor` nous devons appeller la completion au sein d'une `Task` et précédé d'un `await`**
 * Enfin l'utilisation de l'attribut `@MainActor` permet au compilateur d'optimiser les performances dans notre code
 */
/*:
 * Il est important de chosir la bonne stratégie avec les `@globalActor` et notamment avec le `@MainActor`
 * Dans l'exemple précédent, on décore notre closure avec `@MainActor` indiquant que la completion sera exécuté à coup sûr sur le main thread
 * Cependant dans certaines situation cela peut être overkill ou pas voulu, notamment lorsque le callback n'a pas besoin d'être exécuté sur le main thread
 * Dans ce genre de use case, il est préférable de confier aux implémentations la responsabilité de la répartionr sur la bonne queue
 * Pour cela on peut utiliser la `static func run` du `MainActor`, permettant d'exécuter le code sur le main thread (équivalent à `DispatchQueue.main.async`)
 */
final class ViewModel {
  @Published var images: [UIImage] = []
  
  func fetchData(_ completion: @escaping (Result<[UIImage], Error>) -> Void) {}
}
let viewModel = ViewModel()
viewModel.fetchData { result in
  guard case .success(let images) = result else { return }
  Task {
    await MainActor.run {
      viewModel.images = images
    }
  }
}
