import Foundation
/*:
 # Unavailability condition
 * [SE–0290](https://github.com/apple/swift-evolution/blob/main/proposals/0290-negative-availability.md) introduit `#unavailable` qui est la condition opposée à `#available`, permettant d'exécuter du code
 * Ceci est particulièrement utile dans le cas où on utilisait auparavant des `#available` avec un block vide *juste pour profiter* du `else` block
 * On écrivait donc quelque chose comme ceci :
 */
if #available(iOS 15, *) {
  // nothing
} else {
  // some code
  print("Run some code before iOS 15")
}
//: * Désormais nous pouvons écrire ceci :
if #unavailable(iOS 15) {
  print("Run some code before iOS 15")
}
/*:
 * Mise à part leur comportement opposé, la différence majeure entre `#available` et `#unavailable` est l'utilisation du caractère générique de plateformes `*`
 * Il est nécessaire avec `#available` pour tenir compte des futures mises à jour d'os
 * En d'autres termes `#available(iOS 15, *)` **marque un code comme étant disponible sur les version 15 et supérieurs d'iOS, ou sur toutes les autres plateformes (macOS, tvOS, watchOS) et les futures plateformes encore inconnues**
 */
/*:
 * Avec `#unavailable` **ce comportement n'a pas de sens car il ajouterait une ambiguïté** : doit-il concerner toutes les versions antérieurs et/ou inclure les autres plateformes ?
 * Ainsi, pour éviter cela, le caractère générique `*` de la plateforme n'est pas autorisé : **seules les plateformes que nous énumérons spécifiquement sont prises en compte lors du check**
 */
//: [< Previous: `CodingKeyRepresentable`](@previous)           [Home](Home)           [Next: Concurrency changes >](@next)
