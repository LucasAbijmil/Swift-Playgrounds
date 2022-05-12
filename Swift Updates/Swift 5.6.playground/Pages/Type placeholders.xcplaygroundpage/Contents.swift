import Foundation
/*:
 # Type placeholders
 * [SE-0315](https://github.com/apple/swift-evolution/blob/main/proposals/0315-placeholder-types.md) introduit le concept de type placeholders
 * Cela nous permet de spécifier explicitement que certaines parties du type d'une valeur, de sorte à ce que le reste soit inféré par le compilo en utilisant le *type inference*
 */
/*:
 * En pratique, il faut écrire `_` comme type lorsqu'on souhaite que le compilateur utilise le *type inference*
 * Ainsi d'un point de vue compilateur, ces trois lignes sont identiques
 */
let score1 = 5
let score2: Int = 5
let score3: _ = 5
//: * **Tip**: Le *type placeholder* peut être utilisé en tant qu'optionel `_?`, afin que le compilateur déduise que le type qu'il *infer* est optionnel
var score4: _? = 5
/*:
 * Dans les exemples ci-dessus, le *type placeholder* n'apporte aucune valeur ajoutée puisque le compilateur est capable de déterminer le type
 * Ainsi, on préférera l'utiliser lorsque le compilateur est **capable de déduire correctement une partie du type mais pas sa totalité**
 * Créons un dictionnaire contennant le nom des étudiants et un tableau représentant leurs résultats tout au long de l'année. Nous écrirons quelque chose comme ceci :
 */
var results1 = [
  "Cinthya": [],
  "Jenny": [],
  "Trixie": []
]
print(type(of: results1))
/*:
 * Ici, le compilateur *infer* qu'il s'agit d'un dictionnaire dont les clés sont des `String` et les valeurs des tableaux `Any` (comportement par défaut)
 * Ainsi, si ce n'est pas le type que l'on souhaite, nous sommes obligés d'expliciter le type entier comme il suit :
 */
var results2: [String: [Int]] = [
  "Cinthya": [],
  "Jenny": [],
  "Trixie": []
]
print(type(of: results2))
/*:
 * Le *type placeholder* permet d'écrire `_` lorsque que l'on souhaite que le compilateur utilise le *type inference*
 * Ici, le compilateur réussit à inférer que les clés du dictionnaire sont des `String`, mais nous devons spécifier le type du tableau si on ne souhaite pas qu'il soit de type `Any`
 * En reprennant l'exemple ci-dessus, grâce au *type placeholder* nous pouvons désormais écrire ceci :
 */
var results3: [_: [Int]] = [
  "Cinthya": [],
  "Jenny": [],
  "Trixie": []
]
print(type(of: results3))
//: * Comme on vient de le voir, le `_` est une demande explicite d'utiliser le *type inference*, mais nous avons toujours la possibilité de spécifier le type exact
/*:
 * Le *type placeholder* ne peut pas être utilisé pour les signatures de fonction, le type des paramètres et du return type doit être **explicité dans son intégralité**
 * Cependant, le *type placeholder* est très puissant lorsqu'on prototype : on dit au compilateur qu'on souhaite qu'il déduise un certain type afin qu'il nous propose un *fix-it* pour compléter le code à notre place
 */
struct Player<T: Numeric> {
  var name: String
  var score: T
}
func createPlayer() -> _ {
  Player(name: "Anonymous", score: 0)
}
/*:
 * Ici, nous ne spécifions pas de return type pour `createPlayer` car nous utilison le *type placeholder*
 * Génération d'une double erreur, dont une avec un *fix-it* qui infère le return type :
    * *Type placeholder may not appear in function return type*
    * *Replace the placeholder with the inferred type `Player<Int>`*
 * Cela est très pratique notamment pour des types très complexes
 */
/*:
 * Il faut considérer le *tye placeholder* comme un moyen de simplifier les longues annotations de type
 * On remplace les parties les *plus simple* par le *type placeholder*, en laissant les parties les plus importantes en toutes lettres pour rendre notre code plus lisible
 */
//: [< Previous: `any`](@previous)           [Home](Home)           [Next: `CodingKeyRepresentable` >](@next)
