//
//  ContentView.swift
//  @(non)escaping closures
//
//  Created by Lucas Abijmil on 07/08/2020.
//

import SwiftUI

// Il existe deux types de closures lorsqu'elles sont utilisées en tant que paramètres d'une fonction / closure
// • @nonescaping : par défaut depuis Swift 3
//    - La fonction exécute la closure puis fini sa propre exécution
//    - De ce fait, la closure est synchrone avec la fonction, c'est à dire qu'on ne pas peut retourner dans la closure une fois que l'exécution de la fonction est finie
// Conclusion : la closure n'est pas retenue en mémoire

// • @escaping : lorsque la closure sort du scope de la fonction ––> appellé au sein d'une autre fonction / closure
//    - La fonction s'exécute, le return de la closure peut (très) potentiellement sortir de la portée / scope de la fonction
//      ––> à 99% du temps: appel de la closure (paramètre) dans une autre closure
//    - De ce fait la closure est asynchrone, on pourra y retourner plusieurs fois même après la fin d'exécution de la fonction
//    - Utilisée pour faire des fetchs / Dispatch sur les différents thread etc (tout ce qui est asynchrone dans sa globalité)
// Conclusion : la closure est retenue en mémoire permettant de faire de l'asynchrone (aka la chose la plus utilisé en 2020)

// @escaping closure, ARC & Retain Cycle :
//  - Petit rappel : une closure est une référence type elle peut donc créer une Reference Cycle et possède son propre count pour l'ARC
//  - Toutes références à self dans une @escaping closure doit être précédé d'un [weak / unowned self]

// Mon tips:
// À chaque fonction mettre la closure sans le @escaping
// Si erreur suivante : "Escaping closure captures non-escaping parameter 'escaping'" ––> rajouter le @escaping pour la closure dans les paramètres
// Et le tour est joué :)

struct Closure {
  var name: String

  func getSome(with nonEscaping: (Int) -> Void) {
    var sum = 0
    for number in 1...10 { sum += number }
    nonEscaping(sum) // Non escaping car la closure est exécutée de manière synchrone
  }

  func getSome2(with escaping: @escaping (Int) -> Void) {
    var sum = 0
    for number in 1...10 { sum += number }
    DispatchQueue.main.async {
      escaping(sum) // escaping car la closure est exécutée de manière asynchrone (ici dans une closure de DispatchQueue)
    }
  }

  func getSome3(for sum: Int, with nonEscaping: (Int) -> Void) {
    var numberReturned = 0
    // Les if ... else (synchrone) ne sont pas considérés comme des closures, ainsi pas besoin de mettre la closure de paramètre en tant que @escaping
    if sum == 0 {
      for number in 1...10 { numberReturned += number }
      nonEscaping(numberReturned)
    } else {
      for number in 1...10 { numberReturned += number }
      nonEscaping(numberReturned
      )
    }
  }

  func getSome4(for sum: Int, with nonEscaping: (Int) -> Void) {
    // Comme pour les if ... else, les switch ne sont pas des closures (car synchrone)
    // Ainsi pas besoin de mettre la closure de paramètre en tant que @escaping
    switch sum {
    case 1:
      var numberReturned = 0
      for number in 1...10 { numberReturned += number }
      nonEscaping(numberReturned)
    default:
      var numberReturned = 0
      for number in 1...10 { numberReturned += number }
      nonEscaping(numberReturned)
    }
  }

  func getSome5(with escaping: @escaping (Int) -> Void) {
    var sum = 0
    for number in 1...10 { sum += number }
    // escaping car dans une closure
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      escaping(sum)
    }

  }
}

class GetClosure {
  var name: String
  var res: Int
  var closure: Closure

  init(name: String, res: Int, closure: Closure) {
    self.name = name
    self.res = res
    self.closure = closure
  }

  func closure1WithRetainCycle() {
    // Appel d'une @escaping closure il faut donc éviter le Retain Cycle
    closure.getSome2 { [weak self] number in // pour cela utiliser le [weak / unowned self], ici j'ai fais le choix du weak
      guard let self = self else { return } // Checker le self (bonne pratique) avec le weak car peut être optionnel (et pas le unowned)
      self.res = number
    }
  }

  func closure1BisWithRetainCycle() {
    closure.getSome2 { [unowned self] number in
      self.res = res
    }
  }

  func closure2WithRetainCycle() {
    // Appel d'une @nonescaping closure, pas de retain cycle ––> exécution normale 
    closure.getSome { number in
      self.res = number
    }
  }
}
