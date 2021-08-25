//
//  DiscardableResult.swift
//  DiscardableResult
//
//  Created by Lucas Abijmil on 11/10/2020.
//

import Foundation

final class Discardable {

  // Il peut arriver que dans certains cas on veuille ignorer le return d'un résultat car le code à l'intérieur de cette fonction est intéressant mais pas le return
  func presentationNotDiscardable() -> String {
    let string = "Lucas Abijmil"
    print("Bonjour je suis \(string)")

    return string
  }

  // Non-utilisation du return de la fonction d'exemple
  // Comme le return de la fonction n'est pas utilisé, un warning apparait
  // Autrement on peut obtenir le résultat de la fonction dans une variable qui ne nous servira à rien "_"
  func notDiscardable() {
    presentationNotDiscardable()
    _ = presentationNotDiscardable()
  }

  // Pour qu'on puisse ignorer le return d'une fonction
  // Il suffit de rajouter l'attribut @discarbleResult avant la déclaration de fonction retournant une valeur
  // Ainsi on peut, mais on est pas obligé d'utiliser le return de cette fonction
  @discardableResult
  func presentationDiscardable() -> String {
    let string = "Lucas Abijmil"
    print("Bonjour je suis \(string)")

    return string
  }

  // En ayant rajouté cet attribut, il n'y a plus de warning :-)
  func discardable() {
    presentationDiscardable()
  }
}
