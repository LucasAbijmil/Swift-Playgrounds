import SwiftUI
/*:
 # Actor Isolation
 */
/*:
 * Pour **contrôler l'isolation des `actor`** on peut être ammené à utiliser : `isolated` et / ou `nonisolated`
 * **Par défaut chaque `property` mutable (`var`) et `method` d'un `actor` sont `isolated`**
 * En d'autres termes, on doit déjà être dans le context d'un `actor` ou utiliser `await` à l'extérieur de la définition de l'`actor` pour attendre / avoir un accès approuvé à une `property` mutable d'un `actor`
 */
/*:
 * Il est très commun de rencontrer les erreurs suivantes avec les `actor` :
    * *Actor-isolated property ‘xxxx’ can not be referenced from a non-isolated context*
    * *Expression is ‘async’ but is not marked with ‘await’*
 * Ces deux erreurs ont la même root cause : **les `actor` isolent l'accès à leur mutable state pour garantir un accès exclusif**
 */
actor BankAccount {
  
  enum BankError: Error {
    case insufficentFunds
  }
  
  var balance: Double
  
  init(initialDeposit: Double) {
    self.balance = initialDeposit
  }
  
  func deposit(amount: Double) {
    balance += amount
  }
  
  // Doit être marqué comme async due au await au sein de la fonction
  func transfer(amount: Double, to toAccount: BankAccount) async throws {
    guard balance >= amount else { throw BankError.insufficentFunds }
    balance -= amount
    await toAccount.deposit(amount: amount) // Doit être marqué await car on appel une method d'une autre instance d'actor de type BankAccout
  }
}
/*:
 * Par défaut les `method` d'un `actor` sont marquées `isolated` de manière implicit (comme `internal`)
 * *Behind the scenes* le code ci-dessus est en réalité équivalent à celui qui suit
 */
actor BankAccountIsolated {
  
  enum BankError: Error {
    case insufficentFunds
  }
  
  var balance: Double
  
  init(initialDeposit: Double) {
    self.balance = initialDeposit
  }
  
  isolated func deposit(amount: Double) {
    balance += amount
  }
  
  isolated func transfer(amount: Double, to toAccount: BankAccountIsolated) async throws {
    guard balance >= amount else { throw BankError.insufficentFunds }
    balance -= amount
    await toAccount.deposit(amount: amount)
  }
}
/*:
 * Les `method` marquées `isolated` génèrent une erreur : *'isolated' may only be used on 'parameter' declarations*
 * Le mot clé `isolated` peut uniquement être utilisé pour les paramètres de `method`
 */
/*:
 * Lorsque le paramètre d'une `method` est un `actor`, on peut le préfixer par `isolated` afin d'éviter de devoir utiliser `await` au sein de la fonction et donc devoir marquée la `method` comme `async`
 * Désormais le contexte asynchrone est implicit alors qu'il était explicit sans l'utilisation de ce prefix
 * Modifions la fonction `transfer`, qui se passe en 3 étapes :
    * Ajouter `isolated` avant le type `BankAccountIsolatedParameter`
    * Supprimer le `await` de `toAccount.deposit(amount: amount)`
    * Supprimer le `async` de la signature de la méthode (désormais implicit)
 */
actor BankAccountIsolatedParameter {
  
  enum BankError: Error {
    case insufficentFunds
  }
  
  var balance: Double
  
  init(initialDeposit: Double) {
    self.balance = initialDeposit
  }
  
  func deposit(amount: Double) {
    balance += amount
  }
  
  func transfer(amount: Double, to toAccount: isolated BankAccountIsolatedParameter) throws {
    guard balance >= amount else { throw BankError.insufficentFunds }
    balance -= amount
    toAccount.deposit(amount: amount)
  }
}
/*:
 * Bien qu'autorisé pour le moment, **la proposition originale indique qu'avoir plusieurs paramètres marqués comme `isolated` dans la même `method` n'est pas possible**
 * ⚠️ Une future update de Swift pourrait vous obliger à mettre à jour ce genre de code
 */
actor BankAccountDoubleIsolated {
  func transfert(amount: Double, from fromAccount: isolated BankAccountDoubleIsolated, to toAccount: isolated BankAccountDoubleIsolated) { }
}
/*:
 * Les `property` et `method` marquées comme `nonisolated` permettent de ***refuser* l'isolation par défaut des `actor`**
 * On utilise cela principalement pour deux raisons :
    * Accès à des données immutables
    * L'`actor` doit se conformer à un `protocol`
 */
actor BankAccountHolder {
  let holder: String
  
  init(holder: String) {
    self.holder = holder
  }
}
/*:
 * `holder` est immutable car c'est une constante (`let`), elle est donc thread safe
 * **On peut y accéder en toute sécurité même depuis un environnemnt non isolé sans créer de Data Races** :
    * Le compilo est assez intelligent pour reconnaître cela : **une constante est implicitement `nonisolated`**
 * Cependant pour les `computed property`, on doit aider le compilateur
 */
actor AccountInfo {
  let holder: String
  let bank: String
  var details: String {
    return "Bank: \(bank) – Account holder: \(holder)"
  }
  
  init(holder: String, bank: String) {
    self.holder = holder
    self.bank = bank
  }
}
/*:
 * Si nous essayons d'accéder à la `property details` nous allons générer une erreur : *Actor-isolated property 'xxxx' can not be referenced from a non-isolated context*
 */
let accountInfo = AccountInfo(holder: "Lucas", bank: "McKinney")
accountInfo.details
/*:
 * Les `property` `holder` et `bank` sont des constantes, on peut donc marquer la `property details` comme `nonisolated` afin de résoudre cette erreur
 * En marquant une `property` ou une `method` comme `nonisolated` on assure à Swift que nous n'allons pas introduire de Data Races
 * **⚠️ Attention à son utilisation, car Swift ne vérifiera pas cela pour vous**
 */
actor AccountInfos {
  let holder: String
  let bank: String
  nonisolated var details: String {
    return "Bank: \(bank) – Account holder: \(holder)"
  }
  
  init(holder: String, bank: String) {
    self.holder = holder
    self.bank = bank
  }
}
let accountInfoNonIsolated = AccountInfos(holder: "Lucas", bank: "McKinney")
accountInfoNonIsolated.details
/*:
 * Lorsqu'on rend un `actor` conforme à un `protocol`, on peut faire face à une erreur si on suit l'implémentation par défaut de Xcode : *Actor-isolated property 'xxxx' cannot be used to satisfy a protocol requirement*
 */
actor AccountStringConvertible: CustomStringConvertible {
  let holder: String
  let bank: String
  var description: String {
    return "Bank: \(bank) – Account holder: \(holder)"
  }
  
  init(holder: String, bank: String) {
    self.holder = holder
    self.bank = bank
  }
}
/*:
 * Par défaut, les `property` d'un `actor` sont `isolated`, hors le requierement d'un `protocol` est une `property nonisolated`
 * Pour ce genre de use case, on peut également utiliser `nonisolated` à condition d'être sûr d'accèder uniquement à des `property` immutables
 */
actor AccountStringConvertibleFixed: CustomStringConvertible {
  let holder: String
  let bank: String
  nonisolated var description: String {
    return "Bank: \(bank) – Account holder: \(holder)"
  }
  
  init(holder: String, bank: String) {
    self.holder = holder
    self.bank = bank
  }
}
/*:
 * Toutefois, si nous accédons à des `property isolated` dans un environnement `nonsiolated`, le compilo est assez intelligent pour générer une erreur : *Actor-isolated property 'xxxx' can not be referenced from a non-isolated context*
 */
actor AcccountStringConvertible: CustomStringConvertible {
  let holder: String
  let bank: String
  var balance: Double
  nonisolated var description: String {
    return "Bank: \(bank) – Account holder : \(holder) with balance : \(balance)"
  }
  
  init(holder: String, bank: String, initialDeposit: Double) {
    self.holder = holder
    self.bank = holder
    self.balance = initialDeposit
  }
}
//: [< Exploration & limitations des `actor`](@previous)           [Home](Home)
