import Foundation
/*:
 # **Debug** – Literal Expresssion & log function
 * Les `Literal Expression` par défaut fournit par Swift nous permettent d'obtenir des informations utiles pour *debug*
 * Grâce à cela on peut créer une fonction `log` qui va nous permettre de plus facilement debugger notre code
 */

/*:
 Voici les `Literal Expression` fournit par Swift :
 * `#file` / `#filePath` : `String` ––> Le chemin d'accès au fichier.
 * `#fileID` : `String` ––> Le nom du fichier et du module.
 * `#line` : `Int` ––> Le numéro de ligne.
 * `#column` : `Int` ––> Le numéro de la colonne dans laquelle il commence.
 * `#function`: `String` ––> Le nom de la fonction.
 * `#dsohandle` : `UnsafeRawPointer` ––> Token qui identifie l'exécutable ou dylib image.
*/
print(#file)
print(#filePath)
print(#fileID)
print(#line)
print(#column)
print(#function)
//print(#dsohandle) // KO dans un playground
/*:
 Grâce à ces `Literal Expression` on peut créer une fonction `log` qui va nous permettre de debugger plus facilement
 */
func log(_ message: String = "No message", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
  print("[FILE : \(file.uppercased()) – FUNCTION : \(function.uppercased()) – LINE : \(line)] – MESSAGE : \(message)")
}
//:     Fonction qui appele la fonction log
func testLogFunction() {
  log()
  log("Hello custom log function !")
}
testLogFunction()
