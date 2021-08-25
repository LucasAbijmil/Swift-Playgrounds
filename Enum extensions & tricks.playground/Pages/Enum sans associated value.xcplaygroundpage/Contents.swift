//: ## Création d'une `enum` sans **associated values**
enum Direction {
  case north
  case south
  case east
  case west

  var description: String {
    switch self {
    case .north:
      return "North"
    case .south:
      return "South"
    case .east:
      return "East"
    case .west:
      return "West"
    }
  }
}

//: [Home](Introduction)           [Next: `enum` avec `associated value` >](@next)
