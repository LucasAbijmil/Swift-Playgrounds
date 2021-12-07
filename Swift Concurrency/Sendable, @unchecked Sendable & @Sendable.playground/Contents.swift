import Foundation
/*:
 # Sendable, @unchecked Sendable & @Sendable – Données thread safes
 */
/*:
 * Le protocol `Sendable` & l'attribut `@Sendable` permettent de répondre à la vérification des types de données transmises entre les concurrences structurées et les messages d'`actor`
 * `Sendable` et `@Sendable` indique si une **API / objet est thread safe** et si c'est le cas elle pourra **être utilisée en toute sécurité dans les contextes de concurrences**
 */
/*:
 * De nombreux types sont par défaut conformes à `Sendable` grâce à Swift :
    * Core types : `Int`, `Bool`, `String` ...
    * `Optional` lorsque la `Wrapped` value est une *value type*
    * Les `Collection` qui ne contiennent que des *values type*
    * Les `tuples` où les élément sont des *values type*
 */
extension Int: Sendable {} // Warning: Conformance of 'Int' to protocol 'Sendable' was already stated in the type's module 'Swift'
func isSendable(_ object: Sendable) {}
//: * Grâce à cela, **Swift créer une conformance implicite pour nos objets customs si et seulement s'ils ne contient que des types conformes à `Sendable`** (même mécanisme que `Codable`)
struct ArticleStruct {
  let title: String
  let description: String
  let views: Int
}
let articleStruct = ArticleStruct(title: "", description: "", views: 0)
isSendable(articleStruct)
/*:
 * **Cette conformance implicite ne s'applique que pour les *values types***
 * Ainsi **une `class` n'est pas implicitement conforme à `Sendable`**, cela est dûe à deux raisons :
    * C'est une *reference type*, l'objet est donc mutable à partir de d'autres domaines concurrents
    * Une `class` est par définition *non thread safe*
 * Enfin **seules les `class` marquées comme `final` peuvent être explicitement conforme à `Sendable`**
 * **Remarque : les `actor` et types conformes à `Actor` sont automatiquement conforme à `Sendable`**
 */
final class FinalArticleClass: Sendable {
  let title: String
  let description: String
  let views: Int

  init(title: String, description: String, views: Int) {
    self.title = title
    self.description = description
    self.views = views
  }
}
let finalArticleClass = FinalArticleClass(title: "", description: "", views: 0)
isSendable(finalArticleClass)
/*:
 * **Une `class` non `final` ne peut pas être conforme à `Sendable`**
 * Cela vient du fait que d'autres `class` peuvent hériter de cette même `class`, avec des property potentiellement non conformes à `Sendable`
 */
class ExplicitArticleClass: Sendable { // Error: Non-final class 'ExplicitArticleClass' cannot conform to `Sendable`; use `@unchecked Sendable`
  let title: String
  let description: String
  let views: Int

  init(title: String, description: String, views: Int) {
    self.title = title
    self.description = description
    self.views = views
  }
}
/*:
 * Le compilo suggère d'utiliser `@unchecked Sendable`
 * `@unchecked Sendable` nous **oblige à nous assurer que la `class` est toujours thread safe même en cas d'héritage** (grâce à un mécanisme de vérouillage interne)
 * ⚠️ Cela rajoute une responsabilité (implicite) lors du développement, qui peut être oubliée (à éviter)
 */
class UncheckedArticleClass: @unchecked Sendable {
  let title: String
  let description: String
  let views: Int

  init(title: String, description: String, views: Int) {
    self.title = title
    self.description = description
    self.views = views
  }
}
isSendable(UncheckedArticleClass(title: "", description: "", views: 0))
/*:
 * Par défaut, le compilateur n'ajoute pas de conformance implicite aux structs avec types génériques si ce dernier n'est pas restreint à `Sendable`
 */
struct Container<Value> {
  let child: Value
}
let container = Container(child: 5)
isSendable(container) // Error: Argument type 'Container<Int>' does not conform to expected type 'Sendable'
/*:
 * Cependant si on restreint le type générique à `Sendable`, cela génère une conformance implicite
 */
struct SendableContainer<Value: Sendable> {
  let child: Value
}
let sendableContainer = SendableContainer(child: 5)
isSendable(sendableContainer)
/*:
 * Le constat est le même pour des `enum` avec des *associated values* :
    * Si un case contient une *associated value* dont le type n'est pas conforme à `Sendable`, alors **l'`enum` ne peut pas être conforme à `Sendable`**
    * Si tous les cases et toutes les *associated values* sont conformes à `Sendable`, alors **l'`enum` est implicitement conforme à `Sendable`**
 */
enum State {
  case loggedOut
  case loggedIn(name: NSAttributedString)
}
isSendable(State.loggedIn(name: NSAttributedString(string: "Lucas"))) // Error: Argument type 'State' does not conform to expected type 'Sendable'
/*:
 * On peut résoudre cela en remplaçant la `NSAttributedString` par une `String` qui est conforme à `Sendable`
 */
enum SendableState {
  case loggedOut
  case loggedIn(name: String)
}
isSendable(SendableState.loggedIn(name: "Lucas"))
/*:
 * **⚠️ Dès lors qu'une struct ou une enum est marquée comme `public`, elle perd sa conformité implicite à `Sendable`.** Il faudra de ce fait, l'expliciter
 */
public struct PublicArticleSendable {
  public let title: String
}
isSendable(PublicArticleSendable(title: ""))

public enum PublicState {
  case loggedOut
}
isSendable(PublicState.loggedOut)
/*:
 * La conformité implicite à `Sendable` permet d'éviter d'expliciter cette conformance
 * Cependant il existe des cas où le compilateur n'ajoute pas cette conformance car notre objet est par définition non thread safe :
    * Les `class` *immutables*
    * Les `class` dotées de mécanisme de vérouillage interne
 */
//: * Exemple d'une `class` *immutable*
final class User: Sendable {
  let name: String

  init(name: String) {
    self.name = name
  }

  func printName() {
    print(name)
  }
}
isSendable(User(name: "Lucas"))
/*:
 * Si on explicite la conformance à `Sendable` pour une `class` *mutable* avec une logique de vérouillage interne, cela génère deux erreurs :
    * Error: *Stored property 'xxxx' of 'Sendable'-conforming class 'xxxx' is mutable*
    * Error: *Stored property 'xxxx' of 'Sendable'-conforming class 'xxxx' has non-sendable type 'DispatchQueue'*
 */
final class MutableUser: Sendable {
  var name: String
  private let queue = DispatchQueue(label: UUID().uuidString)

  init(name: String) {
    self.name = name
  }

  func updateName(for name: String) {
    queue.sync {
      self.name = name
    }
  }
}
/*:
 * Pour résoudre ces erreurs, il faut utiliser l'attribut `@unchecked` devant `Sendable`
 * Cet attribut permet d'assurer au compilo que la `class` bien que mutable est thread safe grâce à une logique de vérouillage interne
 */
final class MutableUncheckedUser: @unchecked Sendable {
  var name: String
  private let queue = DispatchQueue(label: UUID().uuidString)

  init(name: String) {
    self.name = name
  }

  func updateName(for name: String) {
    queue.sync {
      self.name = name
    }
  }
}
isSendable(MutableUncheckedUser(name: "Mutable Lucas (thread safe)"))
/*:
 * Les closures & functions peuvent être transmises à travers divers contextes concurrents mais ne peuvent pas se conformer à `Sendable`
 * L'attribut `@Sendable` indique au compilo qu'aucune synchronisation supplémentaire n'est nécessaire car toutes les valeurs capturées dans la closures sont conformes à `Sendable` et est donc thread safe
 * Les closures marquées `@Sendable` sont généralement (mais pas toujours !) marquées comme `@escaping`. C'est typiquement le cas d'une `Task` dont l'`init` est le suivant :
    * `init(priority: TaskPriority? = nil, operation: @escaping @Sendable () async -> Success)`
 */
//: * Exemple d'utilisation de `@Sendable` avec des closures à partir d'un `actor`
actor ArticlesList {
  func filteredArticles(_ isIncluded: @escaping @Sendable (ArticleStruct) -> Bool) async -> [ArticleStruct] { /* some code */ }
}
let listOfArticles = ArticlesList()
func getFilteredArticles() {
  let query = "keyword"
  Task {
    let _ = await listOfArticles.filteredArticles { article in
      return article.title == query
    }
  }
}
/*:
 * Si une `@Sendable` closure contient / capture un type qui n'est pas conforme à `Sendable`, alors cela génère une erreur
    * Error: *Reference to captured var 'xxxx' in concurrently-executing code*
 */
func getFilteredArticlesNonSendable() {
  var query: String? = "keyword"
  Task {
    let _ = await listOfArticles.filteredArticles { article in
      return article.title == query // Reference to captured var 'query' in concurrently-executing code
    }
  }
}
