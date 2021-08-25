import Foundation
/*:
# **`Defer`** :
 * Permet d'éxuter une closure avant de finir l'exécution d'une fonction (avant de quitter son scope)
 */
func testDefer() {
  defer {
    print("Work is done")
  }
  print("Work is starting")
}
testDefer()
//: L'odre d'éxution des `defer` est inversé par rapport à leur déclaration (on remonte du "bas" de la function vers le "haut")
func multipleDefer() {
  defer { print("1") }
  defer { print("2") }
  defer { print("3") }
  print("4")
}
multipleDefer()
