import Foundation
/*:
 # Async Await – Création et appelle de fonctions asynchrones – Binding séquentiel
 * `async` permet de créer une fonction asynchrone avec un return comme une fonction synchrone
 * `await` permet d'appeller une fonction asynchrone
 */
//: * Avant Swift 5.5, les fonctions asynchrones était créer grâce à des `@escaping` closures pour faire passer le résultat. Voici quelques exemples :
func fetchWeatherHistory(completion: @escaping (Result<[Double], Error>) -> Void) {
  // Complex networking code
  DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
    completion(.success([15.0, 10]))
  }
}

func calculatateAverageTemparature(for records: [Double], completion: @escaping (Double) -> Void) {
  // Complex networking code
  DispatchQueue.global().async {
    let total = records.reduce(0, +)
    let average = total / Double(records.count)
    completion(average)
  }
}

func upload(result: Double, completion: @escaping (String) -> Void) {
  // Complex networking code
  DispatchQueue.global().async {
    completion("OK")
  }
}
//: * Ainsi lorsque nous devons appellé plusieurs fonctions asynchrones avec des `@escaping` closures, on se retrouve avec un *callback hell* dûe aux multiples completion handler menant à la *pyramid of doom*
func proccessWeather() {
  fetchWeatherHistory { result in
    switch result {
    case .success(let records):
      calculatateAverageTemparature(for: records) { average in
        upload(result: average) { serverResponse in
          print(serverResponse)
        }
      }
    case .failure(let error):
      print(error.localizedDescription)
    }
  }
}
/*:
 * Faisons la même chose avec mais avec une fonction marquée `async`, ce qui passe par plusieurs adaptations :
    * Ce qui était passé dans l'`@escaping` closure devient le type de retour de la foncton
    * On marque la fonction `async` de la même manière qu'une fonction qui `throws`
 */
func fetchWeatherHistory() async -> Result<[Double], Error> {
  return .success([15.0, 10.0])
}

func calculatateAverageTemparature(for records: [Double]) async -> Double {
  return records.reduce(0, +) / Double(records.count)
}

func upload(result: Double) async -> String {
  return "OK"
}
/*:
 * Plusieurs choses à remarquer ici :
    * L'appelle d'une fonction asynchrone marquée `async` doit être précédé du `await`, comme un `try` pour une fonction qui `throws` (erreur générée à la compilation)
    * Une fonction (comme `proccessWeather`) doit également être marqué comme `async` car son scope fait appelle à des fonctions elles-mêmes marquées comme `async` (erreur générée à la compilation)
    * *Callback hell* disparu, grâce au fait que les fonctions `async` return et ne passe plus des `@escaping` closures
    * La syntaxe du code est similaire à du code synchrone ce qui facilite grandement la lecture
    * Une fonction marquée `async` ne veut pas dire qu'elle est nécessairement asynchrone, plutôt qu'*on lui en laisse la possibilité*
    * Lorsqu'on attend (`await`), la `Task` libère le thread
 */
func proccessWeather() async {
  let weatherHistory = await fetchWeatherHistory()
  guard case .success(let records) = weatherHistory else { return }
  let average = await calculatateAverageTemparature(for: records)
  let serverResponse = await upload(result: average)
  print(serverResponse)
}
/*:
 * Les fonctions asynchrones peuvent appelées des fonction synchrones mais pas l'inverse (cf plus haut)
 
 * ⚠️ Le compilo arrive à faire la différence entre une fonction synchrone et asynchrone nommée de la même manière et choisira l'une d'entre elle en fonction du contexte
 */
//:[Home](Home)           [Next: `async throws` function >](@next)
