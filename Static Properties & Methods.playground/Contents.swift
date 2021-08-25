import Foundation

/*:
 # **`static` properties & functions**
 * Permet l'accès à des propriétés et fonctions d'un type sans créer une instance de celui-ci
 * Ces propriétés et fonctions sont considérées comme des constantes "partagées" par le type
 * Les `static` properties sont `lazy` par défaut
 * Peut être utilisé dans des `struct`, `class` ou `enum`
 */

//: Déclaration d'une `struct` qui déclare une `static` properties (*creator*)
struct Video {

  static let creator = "Lucas Abijmil"
  var title: String
  var views: Int
}
//: Accès à *creator* sans création d'instance du type `Video` :
Video.creator
//: Création d'une instance du type `Video`
var video = Video(title: "Formation Swift", views: 2_500)
//: Accès à une `static` properties ou function **uniquement depuis le type et non depuis une instance créée**
// video.creator ––> KO
/*:
 ## Cas d'utilisation :
 * UI d'une application (très courant) : `enum UI` / `struct UI`
 * singleton : `static let shared = MyObject()` (pas très recommandé en vrai)
 * Module
 */
