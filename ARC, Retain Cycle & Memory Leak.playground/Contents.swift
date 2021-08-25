import UIKit

// ARC --> Automatique Reference Count
// Décide quand seront référencés et déférencés les valeurs stockées en mémoire
// Dès qu'on créer un objet (faire référence) l'ARC (qui fait partie du compilateur) alloue une partie de la mémoire pour cette donnée
// Dès qu'on détruit un objet (faire déréférence) l'ARC désalloue la mémoire afin d'être utilisé par d'autres *choses*
// Attention: si un objet à été désalloué par l'ARC,  on ne pourra plus acéder à son instance sinon l'app pourrait crash
// Cependant l'ARC traque toutes les propriétés strong, constante et variable qui font référence à une instance, et cet objet ne sera pas déférencé (supprimé) tant qu'il aura au moins encore une strong référence

// MARK: - Exemple
class Personn {
    var name: String
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    deinit {
        print("\(name) de l'exemple de l'ARC dealocaled, kill by the ARC. 😢")
    }
}

// MARK: - Explication
// Trois type pour l'ARC:
// - strong: par défaut --> +1, protège l'objet d'être désalloué par l'ARC, par défaut
// - weak: le type doit être optionnel --> +0, compteur non incrémenté peut être donc possiblement nil (et ne fais pas -1 lorsqu'il est déférencé)
    // --> À noter qu'une weak var ne pourra jamais être une constant (let) sinon l'erreur suivante apparaîtra:
        // "weak" must be a mutable variable, because it change at runtime
// - unowned: pareil que weak sauf que la variable ne doit pas être optionnels --> + 0 (pas très utilisé à ma connaissance)
        // --> CÀD que la variable existera tant que la class parent sera alloué
// MARK: La différence entre weak & unowned est un assez subtile (surtout pour les débutants) entrenez-vous c'est la meilleure des choses ;-)
    // weak: la propriété peut être nil ou non --> explique le fait qu'elle doit obligatoirement être une variable et pas une constante. La propriété peut exister ou non
    // unowned: la propriété doit obligatoirement avoir une valeur et cette propriété existera tant que la propriété parent existe
        // elle est relié indirectement à l'état de la propriété parent
        // Si la propriété parent est supprimé de la mémoire alors la propriété unowned sera également supprimé de la mémoire



// Pour montrer la puissance de l'arc je vais faire uniquement des variables optionnels (car on peut les déinitialiser facilement en faisant var = nil)
// Ça va également vous démontrer la puissance des weak est sont utilisé très régulièrement avec les types optionnels (car il peuvent déinitialiser)
// Je ne vais pas utiliser de unowned reference dans cet exemple
// Lorsqu'une référence strong devient nil (déréférence) -->  -1
// Pour les références weak (et unowned) --> -0
var ref1: Personn?
var ref2: Personn?
var ref3: Personn?
weak var ref4: Personn? // Mark: weak var ici

// On initialise ref1 donc +1 pour Person (car de type strong)
ref1 = Personn(name: "Lucas") // count = 1 (une strong référence)
// Deux nouvel référence de type strong à la même réfenrence  --> +2 donc au total +3
ref2 = ref1 // count = 2 (deux strong référence)
ref3 = ref1 // count = 3 (trois strong référence)
ref4 = ref1 // count = toujours 3 (trois références strong + une weak (0))
// On supprime une référence strong --> -1 donc +2 au count de l'objet, il est donc toujours maintenu dans la mémoire par l'arc
ref1 = nil // count = 2 (deux strong référence) --> on notera que même en mettant nil l'objet premier, on peut toujours accéder à cet objet car comme il y a encore des réf à cet objet il n'est donc pas supprimé de la mémoire.

// la preuve ici
print(ref2?.name)
print(ref3?.name)
print(ref4?.name)

ref2 = nil // count = 1 (une strong référence)
ref4 = nil // count = toujours 1 (car weak var et il reste une strong référence)

// de ce fait je peux toujours accéder à ref3, la preuve:
print(ref3?.name)

// déférencement du dernier objet strong
ref3 = nil // count = 0, l'objet est désalloué par l'ARC et le deinit se lance --> l'objet est supprimé de la mémoire



// MARK: - Retain cycle & Memory Leak
// Le retain cycle arrive lorsque deux objets se font des références strong entre eux. Il faut visualiser ça un peu comme un cercle vicieux.
// Si les deux références de l'un à l'autre est de type strong alors il risque d'y avoir un problème, pour l'ARC


class Person {
    var name: String
    var macbook: MacBookPro?

    init(name: String, macbook: MacBookPro?) {
        self.name = name
        self.macbook = macbook
    }

    deinit {
        print("\(name) weak / unowned exemple was killed by the ARC")
    }
}

class MacBookPro {
    var name: String
    var person: Person?
    
    init(name: String, person: Person?) {
        self.name = name
        self.person = person
    }
    
    deinit {
        print("\(name) de weak / unowned exemple was killed by the ARC")
    }
}

// Déclaration de nos variables optionnels ici afin de pouvoir les déférencé plus facilement en faisant var = nil
var lucas: Person?
var MBP: MacBookPro?

// Initialisation de nos variables
lucas = Person(name: "Lucas", macbook: nil) // on peut pas initialiser nos macbook étant donné qu'il ne l'est pas également
MBP = MacBookPro(name: "MacBook Pro 13\" ", person: nil) // on n'itialise pas non plus la valeur de person

// MARK: Au niveau de l'arc on est au schéma suivant:
// lucas fait une référence de type strong a Person
// MBP fait également une référence de type strong à MacBookPro
// MARK: Ici on a donc bien les deinit qui se lancent étant donné qu'on a qu'une seule référence pour chaque objet.

#warning("À activer désactiver")
//lucas = nil
//MBP = nil

// Maintenant initialisons les variables qui se font mutuellement référence
lucas?.macbook = MBP
MBP?.person = lucas

// MARK: Au niveau de l'ARC on est à la chose suivante:
// Lucas fait une strong référence à Person // Person = 1
// Lucas fait une strong référence à MacBookPro via MBP // MacBookPro = 1
// MBP fait une strong référence à Person via Lucas // Person = 2
// MBP fait une strong référence à MacBookPro // MacBookPro = 2

 // MARK: Maintenant dénitialistion lucas par exemple. Logiquement on devrait avoir donc le deinit qui s'exécute

lucas = nil // lucas = nil, ainsi count Person = 1


// Étant donné qu'il y a encore une référence à Person via MBP, l'objet n'est pas supprimé de la mémoire (puisque = 1)
// La preuve en printant le name de la person de mbp
print(MBP?.person?.name ?? "détruit")
// la preuve que lucas = nil
print(lucas?.name ?? "Détruit")
print(lucas?.macbook?.name ?? "Détruit")
// D'où le fait que le deinit ne s'est pas exécuté

// MARK: - A noter
MBP = nil // ne lance pas non plus le deinit de mbp

// Aucun deinit se lance car il reste toujours une référence strong à chaque objet donc aucun objet n'est supprimé de la mémoire. Cela est du au fait qu'on a encore une référence à chauqe objet:
// lucas.macbook // count de macbook = 1
// MBP.person // count de person = 1
// On ne peut plus accéder à aucune propriété , pourtant plus aucunes var n'est plus initialisé --> c'est ce qu'on appel MEMORY LEAK / Retain Cycle 
 
 
// MARK: Comment résoudre ce problème ?
// La solution la plus simple et logique est de mettre une des deux propriété à l'autre objet en weak ou unowned, bien qu'on puisse déclarer les deux propriété en tant que weak / unowned
// Ainsi il n'y aura pas de strong référence entre eux et ainsi, on casse le cercle vicieux de début.
// MARK: Mais quel objet choisir dans ce cas ? Bonne question
// La réponse est ça dépend car c'est pas si simple, ça vient avec l'expérience. Au début penser au fait suivant "Quel objet est le moins importants entre les deux ? Qui est la class parent et qui est la class enfant ?" (sémantiquement)
// Et cette propriété sera celle weak / unowned
// Dans ce cas je décide que MacBookPro est un peu moins important que Person dans ce cas c'est la weak variable
//  => Car sémantiquement un MacBookPro appartient obligatoirement à une Person
// ainsi j'aurai la class suivant

#warning("Exemple avec weak var")
class MacBookPro2 {
    var name: String
    weak var person: Person2? // type optionnel car obligatoire avec weak
    
    init(name: String, person: Person2?) {
        self.name = name
        self.person = person
    }
    deinit {
        print("\(name) weak exemple was killed by the ARC")
    }
}

class Person2 {
    var name: String
    var macbook: MacBookPro2?
    
    init(name: String, macbook: MacBookPro2?) {
        self.name = name
        self.macbook = macbook
    }
    
    deinit {
        print("\(name) of weak exemple was killed by the ARC")
    }
}

// MARK: De ce fait en faisant la même chose qu'avant
// Déclaration de nos variables optionnels ici
var lucas2: Person2?
var MBP2: MacBookPro2?

// Initialisation de nos variables
lucas2 = Person2(name: "Lucas", macbook: nil) // on peut pas initialiser nos macbook étant donné qu'il ne l'est pas également
MBP2 = MacBookPro2(name: "MacBook Pro 13\" ", person: nil) // on n'itialise pas non plus la valeur de person


lucas2?.macbook = MBP2
MBP2?.person = lucas2
// MARK: Au niveau de l'arc on est au schéma suivant:
// lucas2 fait une référence de type strong a Person // person = 1
// Lucas2 fait une strong référence à MacBookPro2 via MBP2 // MacBookPro2 = 1
// MBP2 fait une weak référence à Person via Lucas2 // Person = toujours 1
// MBP2 fait une strong référence à MacBookPro2 // MacBookPro2 = 2

// MARK: Ici on a donc bien les deinit qui se lancent étant donné qu'on a qu'une seule référence pour chaque objet.
lucas2 = nil // Ici on a bien le deinit qui s'exécute étant donné que le count de lucas2 est égale à 0

// Au niveau de l'arc ça donne le schéma suivant
// count de lucas2 = 0 car le déinit s'est exécuter --> l'objet a été supprimé de la mémoire
// count de MacbooPro2 = 1 car lucas2.macbook était une strong référence et donc sont compeut s'est décrémenté --> 2 - 1 = 1
MBP2 = nil


// Si vous savez que votre propriété "enfant" ne sera jamais nil alors pour vous pouvez la mette de type unowned

print("-----------------------------")

final class Person79 {
    var name: String
    var computer: Macbook79?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Person class déinitialisé")
    }
}

final class Macbook79 {
    var name: String
    unowned var owner: Person79
    
    init(name: String, owner: Person79) {
        self.name = name
        self.owner = owner
    }
    
    deinit {
        print("Macbook79 class déinitialisé")
    }
}


var lucas79: Person79?

lucas79 = Person79(name: "Lucas 79")
lucas79?.computer = Macbook79(name: "mbp 79", owner: lucas79!)

lucas79?.computer?.name = "jd"

lucas79?.name
lucas79?.computer?.name

lucas79 = nil



final class Club {
    var name: String
    var joueur: Joueur?
    
    init(name: String, joueur: Joueur?) {
        self.name = name
        self.joueur = joueur
    }
    
    deinit {
        print("Club déinitialisé")
    }
}

final class Joueur {
    var name: String
    unowned var club: Club
    
    init(name: String, club: Club) {
        self.name = name
        self.club = club
    }
    
    deinit {
        print("Class \(name) joueur déinitialisé")
    }
}

var psg: Club?
psg = Club(name: "PSG", joueur: nil)
psg?.joueur = Joueur(name: "Mbappe", club: psg!) // Créer un objet d'@: 0x00003

//var mbappe: Joueur?
//mbappe = Joueur(name: "MBAPPE", club: psg!) // créer un objet d'@: 0x003420
//
//
//mbappe?.club.joueur?.name
//mbappe?.name
//
//mbappe = nil

psg = nil

//mbappe = nil
