import UIKit


// MARK: L'initialisation concerne les Structure, Class & Enum et s'assure que toute les propriétés soient initialisées

// MARK: -                                                                                               Structure

// MARK: Memberwise init : à l'inverse des class, le compilo créer un init pour chacunes des properties de la structure si et seulement si aucun init n'est définit dans la déclaration de cette structure
struct PersonneStruct {

  var name: String
  var age: Int
}
let personStruct = PersonneStruct(name: "Lucas", age: 22)

// MARK: Si on souhaite définir un init "custom" pour la structure et garder le MEMBERWISE init, il faut faire cela dans une extension, en dehors de la déclaration de la structure
// Pour l'exemple je décide que mon custom init ne reçoit qu'une String en paramètre
extension PersonneStruct {
  init(name: String) {
    self.name = name
    self.age = 0
  }
}
let personneStruct = PersonneStruct(name: "Lucas")

// MARK: A noter qu'on peut créer autant d'init qu'on le souhaite pour une même structure
struct CelsiusStruct {

  var temperature: Double

  init(fromFahrenheit fahrenheit: Double) {
    temperature = (fahrenheit - 32.0) / 1.8
  }

  init(fromKelvin kelvin: Double) {
    temperature = kelvin - 273.15
  }

  init(_ celsius: Double) {
    self.temperature = celsius
  }
}
let celsiusFromKStruct = CelsiusStruct(fromKelvin: 500)
let celsiusFromFahStruct = CelsiusStruct(fromFahrenheit: 55)
let celsiusStruct = CelsiusStruct(30)

// MARK: - Valeurs par défaut pour certaines propriétés
// Si certaines propriétés ont des valeurs par défaut alors le MEMBERWISE init prendra cela en compte automatiquement et générera autant d'init que de situation possible
// Si on définit notre init dans la déclaration alors on peut utilisé des valeurs par défaut pour les arguments de l'init
struct PersonneWithDefaultPropertiesStruct {

  var name = "Lucas"
  var age: Int

  // MARK: Exemple d'un init custom en prenant compte de la valeur par défaut de la propriété
  // init(name: String = "Lucas", age: Int) {
    // self.name = name
    // self.age = age
  //}
}
let personWithDefaultProperties1Struct = PersonneWithDefaultPropertiesStruct(age: 22) // Lucas, 22
let personWithDefaultProperties2Struct = PersonneWithDefaultPropertiesStruct(name: "Jacques", age: 50) // Jacques, 50

// MARK: - Valeurs par défaut pour toutes les propriétés
// Si toutes les propriétés ont des valeurs par défaut alors le MEMBERWISE init prendra cela en compte automatiquement et générera autant d'init que de situation possible
// Si on définit notre init dans la déclaration alors on peut utilisé des valeurs par défaut pour les arguments
struct JoueurStruct {

  var name: String = "Uknown"
  var numero: Int = 3

  // MARK: Exemple d'un init custom en prenant compte de la valeur par défaut de toutes les propriétés
  // init(name: String = "Uknown", numero: Int = 3) {
    // self.name = name
    // self.numero = numero
  // }
}

let joueurStruct1 = JoueurStruct() // init qui utilise la valeur par défaut pour toutes les propriétés (name & numero)
let joueurStruct2 = JoueurStruct(name: "Lucas") // init qui utilise la valeur par défaut pour la propriété numero
let joueurStruct3 = JoueurStruct(numero: 9) // init qui utilise la valeur par défaut pour la propriété name
let joueurStruct4 = JoueurStruct(name: "Lucas", numero: 90) // init pour ne pas utiliser les valeurs par défaut

// MARK: - Optional Properties & Memberwise init
// Une propriété optionnel est par défaut initialisé à nil. Ainsi on se retrouve dans la même configuration que pour une valeur par défaut (cf `Valeurs par défaut pour certaines propriété`)
struct JoueurWithOptionalNumeroStruct {

  var name: String
  var numero: Int?

  // MARK: Memberwise init sous jacent
  // init(name: String, numero: Int? = nil) {
    // self.name = name
    // self.numero = numero
  // }
}
let joueurWithNilNumero1Struct = JoueurWithOptionalNumeroStruct(name: "Lucas") // init qui set numéro à nil (implicit)
let joueurWithNilNumero2Struct = JoueurWithOptionalNumeroStruct(name: "Lucas", numero: nil) // init qui set numéro à nil (explicit)
let joueurWithANumeroStruct = JoueurWithOptionalNumeroStruct(name: "Lucas", numero: 5) // init qui set numéro à Optional(5)

// MARK: - Failable init : permet d'initialiser ou non un objet en fonction de certaines conditions
// À noter qu'il est préférable de le faire dans la déclaration afin de casser le MEMBERWISE init
struct AnimalStruct {

  let name: String

  init?(name: String) {
    guard !name.isEmpty else { return nil }
    self.name = name
  }
}
let animalFailStruct = AnimalStruct(name: "") // nil
let animalOptionalStruct = AnimalStruct(name: "Lion") // Optional(Animal)

// MARK: -  Initializer Delegation : un init qui appel un autre init afin d'éviter de dupliquer du code
struct SizeStruct {

  var width = 0.0
  var height = 0.0
}

struct PointStruct {
  var x = 0.0
  var y = 0.0
}

struct RectStruct {

  var origin = PointStruct()
  var size = SizeStruct()

  init(origin: PointStruct, size: SizeStruct) {
    self.origin = origin
    self.size = size
  }

  // initializer delegation
  init(center: PointStruct, size: SizeStruct) {
    let oriX = center.x - (size.width / 2)
    let oriY = center.y - (size.height / 2)
    self.init(origin: PointStruct(x: oriX, y: oriY), size: size) // Appel de l'autre init
  }
}
let rectClassique = RectStruct(origin: PointStruct(x: 7, y: 7), size: SizeStruct(width: 7, height: 7)) // init sans delegation
let rectDelegation = RectStruct(center: PointStruct(x: 8, y: 8), size: SizeStruct(width: 7, height: 7)) // init avec delegation







// MARK: -                                                                                                        Class

// MARK: - Designated init : créer un init pour une class, car ne profite pas du Memberwise init créer par le compilo
// MARK: Designated init & héritage : le call à super.init doit toujours se trouver dans le designated init après l'initation de toutes les propriété de la childClass
class PersonneClass {
  
  var name: String
  var age: Int
  
  init(name: String, age: Int) {
    self.name = name
    self.age = age
    // super.init()
  }
}
let personClass = PersonneClass(name: "Lucas", age: 22)

// MARK: À noter qu'on peut créer autant de designated init qu'on le souhaite pour la même class
class CelsiusClass {

  var temperature: Double

  init(fromFahrenheit fahrenheit: Double) {
    temperature = (fahrenheit - 32.0) / 1.8
  }

  init(fromKelvin kelvin: Double) {
    temperature = kelvin - 273.15
  }

  init(_ celsius: Double) {
    self.temperature = celsius
  }
}
let celsiusFromKClass = CelsiusClass(fromKelvin: 500)
let celsiusFromFahClass = CelsiusClass(fromFahrenheit: 55)
let celsiusClass = CelsiusClass(30)



// MARK: - Valeurs par défaut pour certaines propriétés
// Si certaines propriété ont des valeurs par défaut alors on peut soit créer des init pour puvoir utilisé les valeur par défaut ou les initialisé à la mano
// Ou on peut faire les deux en un grâce aux valeur par défaut des argument de l'init, afin de ne pas cr"er pleins de designated init pour couvrir toues les possibilités.

class PersonneWithDefaultPropertiesClass {

  var name = "Lucas"
  var age: Int

  init(name: String = "Lucas", age: Int) {
    self.name = name
    self.age = age
  }
}
let personWithDefaultProperties1Class = PersonneWithDefaultPropertiesClass(age: 22) // Lucas, 22
let personWithDefaultProperties2Class = PersonneWithDefaultPropertiesClass(name: "Jacques", age: 50) // Jacques 50


// MARK: - Valeurs par défaut pour toutes les propriétés
// Si toutes les propriétés ont des valeurs par défaut alors on peut les utiliser pour créer un init avec des paramètres par défaut afin de pouvoir initialiser un objet avec d'autre valeurs pour les propriétés
class JoueurClass {

  var name: String = "Uknown"
  var numero: Int = 3

   init(name: String = "Uknown", numero: Int = 3) {
     self.name = name
     self.numero = numero
   }
}
let joueurClass1 = JoueurClass() // init qui utilise la valeur par défaut pour toutes les propriétés (name & numero)
let joueurClass2 = JoueurClass(name: "Lucas") // init qui utilise la valeur par défaut pour la propriété numero
let joueurClass3 = JoueurClass(numero: 9) // init qui utilise la valeur par défaut pour la propriété name
let joueurClass4 = JoueurClass(name: "Lucas", numero: 90) // init pour ne pas utiliser les valeurs par défaut

// MARK: On peut également ne jamais vouloir changer ses propriétés
// Dans ce là, un init est automatiquement généré pour la class si TOUTES les properties ont une valeur par défaut. Cet init ne prend aucun paramètre
class JoueurClassBis {

  var name: String = "Uknown"
  var numero: Int = 3
}
let joueurBis = JoueurClassBis()

// MARK: Attention si on souhaite utiliser les valeurs par défaut, càd utiliser l'init sans argument mais que d'autre designated init sont créer alors il faut le rajouter dans la déclaration de la clas
class JoueurClassTer {

  var name: String = "Uknown"
  var numero: Int = 3

  init() { }

  init(name: String, numero: Int) {
    self.name = name
    self.numero = numero
  }
}
let joueurTer = JoueurClassTer() // utilisation des valeurs par défaut
let joueurTer1 = JoueurClassTer(name: "Lucas", numero: 90) // utilisation du designated init qui prend des paramètres

// MARK: - Optional Properties & Designated init
// Les properties optionnel sont initalisé à nil par défaut
// On peut donc soit créer deux init: soit pour laisser la value à nil soit afin de l'initialiser à la mano
// Tips: on peut faire les deux en mettant en valeur par défaut le paramètre à nil
class JoueurWithOptionalNumeroClass {

  var name: String
  var numero: Int?

  init(name: String, numero: Int? = nil) {
    self.name = name
    self.numero = numero
  }
}
let joueurWithNilNumero1Class = JoueurWithOptionalNumeroClass(name: "Lucas") // init qui set numéro à nil (implicit)
let joueurWithNilNumero2Class = JoueurWithOptionalNumeroClass(name: "Lucas", numero: nil) // init qui set numéro à nil (explicit)
let joueurWithANumeroClass = JoueurWithOptionalNumeroClass(name: "Lucas", numero: 5) // init qui set numéro à Optional(5)


// MARK: - Convenience init : permet de créer un autre init et d'appellé dans celui cti le designated init
// MARK: Un convenience init doit toujours appeller un designed init
// Si la class hérite d'une autre class, alors le super.init doit toujours être dans le designed init

// MARK: Remarque :
// 1) Un designed init appelle toujours un designed init de la superclass || delegate up
// 2) Un convenience init appelle toujours appeller un designed init de leur class || delegate across

class CivilClass {

  var prenom: String
  var nomDeFamille: String
  var age: Int

  init(prenom: String, nomDeFamille: String, age: Int) {
    self.prenom = prenom
    self.nomDeFamille = nomDeFamille
    self.age = age
  }

  convenience init(prenom: String) {
    self.init(prenom: prenom, nomDeFamille: "Abijmil", age: 22)
  }
}
var designatedClass = CivilClass(prenom: "Lucas", nomDeFamille: "Abijmil", age: 22)
var convenienceClass = CivilClass(prenom: "Lucas")


// MARK: - Inherited init où les subclass peuvent hérité des inits de leur superclass :
//  - 1)  Si la subclass ne définit aucun *designated init* alors elle héritent de tous les *designated inits* de la superclass
//  - 2)  Si la subclass implémente tous les *designated inits* de la superclass, alors elle hérite de tous les *convenience inits* de la superclass
//        => Remarque : l'implémentation des *designated init* d'une super class peut se faire par un *convenience init* de la subclass


// MARK: - Failable init : permet d'initialiser ou non un objet en fonction de certaines conditions
class AnimalClass {

  let name: String

  init?(name: String) {
    guard !name.isEmpty else { return nil }
    self.name = name
  }
}
let animalFailClass = AnimalClass(name: "") // nil
let animalOptionalClass = AnimalClass(name: "Lion") // Optional(Animal)

// MARK: - Requiered init : un init qui doit être implémenté par chaque sublass (utilisation assez rare)
// Les subclass ne sont pas obligé de faire une implémentation explicit du required init du moment qu'ils satisfaient le requierement hérité

class SomeClass {

  var age: Int

  init(age: Int) { self.age = age }

  required init() {
    age = 3
  }
}

class SomeOtherClass: SomeClass {

  var name: String

  init(name: String, age: Int) {
    self.name = name
    super.init(age: age)
  }

  required init() {
    fatalError("init() has not been implemented")
  }
}
