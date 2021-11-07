import Foundation

enum LocationError: Error {
  case uknown
}

func getWeatherReadings(for location: String) async throws -> [Double] {
  switch location {
  case "London":
    return (1...100).map { _ in Double.random(in: 0...20) }
  case "Paris":
    return (1...100).map { _ in Double.random(in: 6...26) }
  case "Barcelona":
    return (1...100).map { _ in Double.random(in: 10...30) }
  default:
    throw LocationError.uknown
  }
}

func fibonacci(of number: Int) -> Int {
  var first = 0
  var second = 1

  for _ in 0 ..< number {
    let previous = first
    first = second
    second = previous + first
  }

  return first
}
/*:
 # Structured concurrency – Exécuter, annuler et surveiller des opérations concurrentes s'appuyant sur `async` `await` et les séquences asynchrones
 * `Task` et `TaskGroup` permettent d'exécuter des opérations concurrentes soit individuellement soit de manière coordonée
 */
/*:
 * Création d'une `Task` pour exécuter une seule opération  :
    * On peut lui donner une priorité, avec le paramètre `priority` de type `TaskPriority` par défaut en `userInitiated`.
    * S'exécute sur un background thread immédiatement
    * Dans la closure `async` on doit expliciter le type de return de la `Task`
 * Tip : les `Task` sont des `@non-escaping` closure, ainsi lorsqu'on les utilise dans des class / struct on aura pas besoin du `self` pour accéder aux propriétés et méthodes
 * Appelle et lecture du résultat d'une `Task` :
    * On accède au résultat grâce à la propriété `result` d'une `Task` lorsque la tâche asynchrone est terminée
    * On accède à la value d'une `Task` grâce à la propriété `value` lorsque la tâche asynchrone est terminée
    * L'appel doit être précédé du mot clé `await` car une `Task` est par définition `async` dûe à sa closure
    * Cela permet de mettre en pause la fonction `printFibonacciSequence` jusqu'à ce la tâche soit finie et qui retournera le résultat
    * Si on souhaite juste exécutée une tâche asynchrone sans mettre en pause la fonction, il ne faut pas stocker la tâche
 * La fonction doit être marquée `async` car son scope contient un contexte asynchrone
 */
func printFibonacciSequence() async -> [Int] {
  let task = Task { () -> [Int] in
    var numbers = [Int]()

    for i in 0..<50 {
      numbers.append(fibonacci(of: i))
    }

    return numbers
  }

  let result = await task.result
  switch result {
  case .success(let numbers):
    print("The first 50 number are : \(result)")
    return numbers
  case .failure:
    print("error")
    return []
  }
}
/*:
 * Création d'une `Task` dont l'opération contient une fonction ou plus qui `throws`
    * À l'appelle de la fonction dans la closure de la `Task`, on est obligé d'utiliser `try` `await` (voir [Async throws functions](Async%20Await%20Throws))
    * Si accès au résultat via `result` on a juste besoin du `await`
    * Si accès à la value via `value` on a besoin du `try await` car la value peut aussi `throw` une erreur
 * Ici, la fonction doit être marquée `async` `throws` car son scope contient un contexte asynchrone tout en appellant des fonctions qui `throws`
 */
func runMultipleCalculations() async throws {
  let task = Task { (0..<50).map(fibonacci) }
  let task2 = Task { try await getWeatherReadings(for: "Paris") }

  let result = await task.value
  let result2Result = await task2.result
  let result2Value = try await task2.value
  print("The first 50 number are : \(result)")
  print("Paris weather result is : \(result2Result)")
  print("Paris weather readers are: \(result2Value)")
}
/*:
 * `Task` en plus d'exécuter des opérations, founit des méthodes pour contrôler la manière de l'exécution :
    * `Task.sleep(_:)` : permet de stopper l'exécution d'une tâche pendant une durée donnée en nano secondes. Ainsi une 1 sec = 1_000_000_000
    * `Task.checkCancellation()` : permet de vérifier si la tâche a été suspendue via la fonction `cancel()`. Si c'est le cas, la `Task` `throw` une `CancellationError`
    * `Task.yield()` : permet de suspendre la tâche pendant quelques instants pour laisser d'autres tâches en attentes de s'exécuter
 * Dans le code ci-desosus, `Task.checkCancellation()` générera une erreur car elle est imédiatement cancel
 */
func cancelSleepingTask() async {
  let task = Task { () -> String in
    print("Starting")
    await Task.sleep(1_000_000_000)
    try Task.checkCancellation()
    return "Done"
  }

  task.cancel()

  do {
    let result = try await task.value
    print("Result is", result)
  } catch {
    print("Task failed : ", error.localizedDescription)
  }
}
/*:
 * Création d'une `TaskGroup` permettant d'avoir une une collection de `Task` qui travaillent ensemble pour produire une valeur finie
    * Se créer via `await withTaskGroup(of: T.self)` où T est le type que retournera le `TaskGroup`
    * La closure passe un paramètre qui est notre *groupe* de `Task`
    * Pour ajouter une tâche à notre groupe, on utilise la fonction `addTask`
    * Toutes les tâches d'un `TaskGroup` doivent retourner le même type de donnée
    * L'ordre des fins des tâches est imprédictible
 * On itère sur chaque value de chaque `Task` du groupe grâce à `for await value in group`
 * La fonction doit être marquée `async` car son scope contient un contexte asynchrone
 */
func printAMessage() async {
  let string = await withTaskGroup(of: String.self) { group -> String in
    group.addTask { "Hello" }
    group.addTask { "From" }
    group.addTask { "A" }
    group.addTask { "Task" }
    group.addTask { "Group" }

    var collected = [String]()
    for await value in group {
      collected.append(value)
    }

    return collected.joined(separator: " ")
  }

  print(string)
}
//: * Si dans un `TaskGroup`, une fonction ou plus `throws` alors on remplace `withTaskGroup` par `withThrowingTaskGroup` et on précède le `await` d'un `try`
func printAllWeatherReadings() async {
  do {
    print("Calculating average weather")
    let result = try await withThrowingTaskGroup(of: [Double].self) { group -> String in
      group.addTask { try await getWeatherReadings(for: "Paris") }
      group.addTask { try await getWeatherReadings(for: "London") }
      group.addTask { try await getWeatherReadings(for: "Barcelona") }

      let allValues = try await group.reduce([], +)
      let average = allValues.reduce(0, +) / Double(allValues.count)
      return "Overall average temperature is \(average)"
    }
    print("Done with : \(result)")
  } catch {
    print("Error : ", error.localizedDescription, " ...")
  }
}
/*:
 * `TaskGroup` fournit des méthodes de contrôle :
 * `cancelAll()` : permet d'annuler toutes les tâches du groupe
 * `addTaskUnlessCancelled()` : permet d'ajouter du travail si le groupe n'a pas été annulé auparavant
 */
func printAllWeatherReadingsIfNotCancelled() async {
  do {
    print("Calculating average weather")
    let result = try await withThrowingTaskGroup(of: [Double].self) { group -> String in
      group.addTask { try await getWeatherReadings(for: "Paris") }
      group.addTaskUnlessCancelled { try await getWeatherReadings(for: "London") }
      group.addTaskUnlessCancelled { try await getWeatherReadings(for: "Barcelona") }

      let allValues = try await group.reduce([], +)
      let average = allValues.reduce(0, +) / Double(allValues.count)
      return "Overall average temperature is \(average)"
    }
    print(result)
  } catch {
    print("Error : ", error.localizedDescription, " ...")
  }
}
//: [< Previous: Completion to `async` function](@previous)           [Home](Home)           [Next: `actors` >](@next)
