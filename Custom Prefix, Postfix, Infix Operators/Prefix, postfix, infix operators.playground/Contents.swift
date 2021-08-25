import Foundation

extension Optional where Wrapped == String {

  var orEmpty: String {
    switch self {
    case .some(let value):
      return value
    case .none:
      return ""
    }
  }
}

// MARK: - On peut créer des custom opérators de la manière suivante
prefix operator ~!!
postfix operator ++/

// MARK: - Prefix operator assez courant (ex : pour les prix de manière locale)
prefix func ~(value: NSNumber) -> String {
  let currencyFormatter = NumberFormatter()
  currencyFormatter.numberStyle = .currency
  currencyFormatter.locale = .current

  return currencyFormatter.string(from: value).orEmpty
}

let price1 = ~99
print(~99)
let price2 = ~105.89
print(price2)

// MARK: - Postfix operator, assez courant (ex : avec les pourcentages)
postfix operator %
postfix func %(percentage: Double) -> Double {
  return percentage / 100
}
print(80%)
print(30%)


// MARK: - Infix operator, pas très courant (entre deux variables)
infix operator +-: AdditionPrecedence
extension Set {
  static func +- (lhs: Set, rhs: Set) -> Set {
    return lhs.union(rhs)
  }
}
let firstNumbers: Set<Int> = [1, 4, 5]
let secondNumbers: Set<Int> = [1, 4, 6]
let uniqueNumbers = firstNumbers +- secondNumbers
print(uniqueNumbers)
