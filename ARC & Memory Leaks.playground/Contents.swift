import UIKit

// Pour gérer la mémoire : le compilateur utilise l'Automatic Reference Counting, raccourci en ARC
// ARC fonctionne de la manière suivante :
//  - chaque référence incrémente le compte de l'objet en mémoire
//  - chaque déférencement décrémente le compte de l'objet en mémoire
//  - lorsque le compte de l'objet tombe à 0 il est supprimé de la mémoire voici un petit exemple

class Developer {
  var name: String

  init(name: String) { self.name = name ; print("Developer initialisé") }

  deinit { print("Developer déinitialisé") }
}

// afin de pouvoir plus facilement la déinitialisé l'objet je le mets en optionnel (= nil)
var developer: Developer?
// Je crée la première référence donc le compte de l'objet est +1
developer = Developer(name: "Lucas")

// créons d'autre variable afin d'incrémenter le compte
var developer1 = developer // +1 ––> 2
var developer2 = developer // +1 ––> 3
var developer3 = developer // +1 ––> 4

// déinitialisons maintenant les variables
developer = nil // -1 ––> 3
developer2 = nil // -1 ––> 2
developer1 = nil // -1 ––> 1

// Ainsi je peux toujours accéder à la propriété name de developer3
developer3?.name
developer3 = nil // -1 ––> 0 ––> l'objet est supprimé de la mémoire, exécution du déinit

print("–––––––––")

// Après cet exemple assez basique, je dois vous parler du type de référence à un objet
// Dans l'exemple d'avant, les références sont de types STRONG
// Toute référence à un object est par défaut de type STRONG
// Sachez qu'il existe en totu 3 types de références les voici:
//  - strong (default): incrément et décremente à l'initialisation et déinitialisation
//  - weak: n'incrémente et ne décrémente pas
//  - unwoned: n'incrémente et ne décrémente pas

// En reprenant l'exemple d'avant en passant une variable en weak
var dev: Developer? = Developer(name: "Lucas bis") // +1 ––> 1
var dev1 = dev // +1 ––> 2
var dev2 = dev // +1 ––> 3
weak var dev3 = dev // +0 ––> 3

dev = nil // -1 ––> 2
dev1 = nil // -1 ––> 1
dev2 = nil // -1 ––> 0

// Ainsi je n'ai même pas passer dev3 en nil que l'objet a été déinitialisé




// Le fonctionnement de l'ARC peut souvent poser des soucis, surtout lorsque deux classes se font mutuellement référence
// voici un exemple
print("––––––––––––")
print("–––––––––––––")

class Job {
  var person: Person?

  deinit { print("Job deoalocated") }
}

class Person {
  var job: Job?

  deinit { print("Person dealocated") }
}

var joe: Person? = Person() // Person: +1 ––> 1
var deve: Job? = Job() // Job: +1 ––> 1



joe?.job = deve // Job: +1 ––> 2
deve?.person = joe // Person: +1 ––> 2

// Maintenant déinitialisons les objets & on devrait voir apparaître les déinit
joe = nil // Person: -1 ––> 1
deve = nil // Job: -1 ––> 1

// Les deux objets sont toujours en mémoire car le count est de 1 (et du coup pas de lancement de déinit)
// Pourtant, les variables sont nils ce qui fait que les propriétés des objets ne sont plus accesible
joe?.job
deve?.person

// Ce phénomène est ce que l'on appelle le retain cycle
// Il garde les objets en mémoire alors qu'on ne peut plus y accéder par une quelconque manière
// C'est un cercle sans fin, vient du fait que les deux classes se font des STRONGS références l'une à l'autre


print("––––––––––––––––")
// MARK: - Comment résoudre le problème du retain cycle ?
// Rappel: le retain cycle vient du fait que chaque objet se font mutuellement référence de type STRONG

// Il suffit de passer une des références en autre que strong afin de casser ce cercle sans fin
// C'est à dire soit: weak or unowned j'y reviens dans un peu plus loin

// Le processus se fait en plusieurs étapes:
// - 1) Identifier qui est la class “parent" AKA class "indépendante"
// - 2) Dans la class enfant AKA class "dépendante" passer la propriété (qui pointe vers la class parent) en weak / unowned
// Ainsi on casse ce fameux cercle vicieux en passant la référence en weak ou unowned

// Voici les modifications (la class Person est la class "Parent").
class PersonBis {
  var job: JobBis?

  deinit { print("PersonBis dealocated") }
}

class JobBis {
  weak var person: PersonBis?

  deinit { print("JobBis dealocated") }
}

var joeBis: PersonBis? = PersonBis() // PersonBis: +1 ––> 1
var deveBis: JobBis? = JobBis() // JobBis: +1 ––> 1

joeBis?.job = deveBis // JobBis: +1 ––> 2
deveBis?.person = joeBis // PersonBis: +0 ––> 1 car la référence est déclaré en weak

joeBis = nil // PersonBis: -1 ––> 0, l'objet est supprimé de la mémoire (lancement du déinit)
             // JobBis: -1 ––> 1
deveBis = nil // JobBis: -1 ––> 0, l'objet est supprimé de la mémoire (lancement du déinit)

// Bien évidement on peut pour se faciliter la décision de "qui est la class enfant et qui est class parent" en mettant les deux références de type weak. Cependant on perd en logique sémantique.

// MARK: - Que choisir entre WEAK & UNOWNED pour une référence vers un autre objet :
//  - (strong, par défaut: la class "enfant" existe tant que la class "parent" existe)

//  - weak: l'objet "enfant" peut exister ou non , ainsi toutes les références de type weak sont donc optionnel (?)
//  L'objet "enfant" n'existera plus si la class "parent" est supprimé de la mémoire (nil)

//  - unowned: l'objet enfant existe tout le temps (et n'est donc pas optionnel) du moment que la class parent est alloué
//  L'objet "enfant" est supprimé lorsque l'objet parent est supprimé (étroite dépedance les objets enfant / parent)

// Conclusion :
//  - Si la valeur de l'objet "enfant" peut être nil à un moment ––> weak
//  - si la valeur de l'objet "enfant" a toujours une value ––> unowned

// Voici un exemple avec une unowned référence

print("–––––––––––––––")
class PersonTer {
  var job: JobTer?

  deinit { print("PersonTer dealocated") }
}

class JobTer {
  unowned var person = PersonTer()

  deinit { print("JobTer dealocated") }
}

var joeTer: PersonTer? = PersonTer()
var deveTer: JobTer? = JobTer()

joeTer?.job = deveTer
deveTer?.person = joeTer!

joeTer = nil
deveTer = nil



