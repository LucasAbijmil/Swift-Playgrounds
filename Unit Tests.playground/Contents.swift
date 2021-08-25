import XCTest
/*:
 # Tests Unitaires
 * Permet de tester le fonctionnel d'une partie de code (généralement 1 test = 1 cas de fonctionnel)
 * Doit être une class qui hérite de `XCTestCase`
 * Chaque fonction de test doit être pré-fixée par `test`
 */
final class TestObject {

  let name: String

  init(name: String) {
    self.name = name
  }
}

enum UknownError: Error {
  case whateEver
}

func throwingFunction() throws {
  throw UknownError.whateEver
}

func notThrowingFunction() throws { }



final class MyTests: XCTestCase {
//: ## Boolean Assertions
//: * `XCTAssert(expression)` 👉 Vérifie qu'un expression est vraie
  func testAssert() {
    let value = 0

    XCTAssert(value == 0)
  }
//: * `XCTAssertTrue(expression)`👉 Vérifie qu'un expression est vraie
  func testAssertTrue() {
    let value = 0

    XCTAssertTrue(value == 0)
  }
//: * `XCTAssertFalse(expression)` 👉 Vérifie qu'un expression est fausse
  func testAssertFalse() {
    let value = 0

    XCTAssertFalse(value != 0)
  }
//: ## Nil & Non-Nil Assertions
//: * `XCTAssertNil(expression)` 👉 Vérifie que la valeur d'une expression est nil
  func testAssertNil() {
    let value: Int? = nil

    XCTAssertNil(value)
  }
//: * `XCTAssertNotNil(expression)` 👉 Vérifie que la valeur d'une expression est non-nil
  func testAssertNotNil() {
    let value: Int? = 0

    XCTAssertNotNil(value)
  }
//: * `XCTUnwrap(expression)` 👉 Permet d'unwrap une expression (le test throws du coup)
    func testXCTUnwrap() throws {
      let value = [1, 2, 3]

      let firstValue = try XCTUnwrap(value.first)

      XCTAssertEqual(firstValue, value[0])
    }
//: ## Equality & Inequality Assertions
//: * `XCTAssertEqual(expression1, expression2)` 👉 Vérifie que deux valeurs sont égales
  func testXCTAssertEqual() {
    let currentValue = [1, 2, 3]
    let expectedValue = [1, 2, 3]

    XCTAssertEqual(currentValue, expectedValue)
  }
//: * `XCTAssertNotEqual(expression1, expression2)` 👉 Vérifie que deux valeurs ne sont pas égales
  func testXCTAssertNotEqual() {
    let currentValue = [0, 1, 2]
    let expectedValue = [1, 2, 3]

    XCTAssertNotEqual(currentValue, expectedValue)
  }
//: * `XCTAssertIdentical(expression1, expression2)` 👉 Vérifie que deux instances sont égales (référence)
  func testXCTAssertIdentical() {
    let currentValue = TestObject(name: "Lucas")

    XCTAssertIdentical(currentValue, currentValue)
  }
//: * `XCTAssertNotIdentical(expression1, expression2)` 👉 Vérifie que deux instances ne sont pas égales (référence)
  func testXCTAssertNotIdentical() {
    let currentValue = TestObject(name: "Lucas")
    let expectedValue = TestObject(name: "Lucas")

    XCTAssertNotIdentical(currentValue, expectedValue)
  }
//: ## Comparable Value Assertions
//: * `XCTAssertGreaterThan(expression1, expression2)` 👉 Vérifie que la valeur de l'expression1 est strictement supérieur à celle de l'expression2
  func testXCTAssertGreaterThan() {
    let currentValue = 5
    let testValue = 0

    XCTAssertGreaterThan(currentValue, testValue)
  }
//: * `XCTAssertGreaterThanOrEqual(expression1, expression2)` 👉 Vérifie que la valeur de l'expression1 est supérieur ou égale à celle de l'expression2
  func testXCTAssertGreaterThanOrEqual() {
    let currentValue = 5
    let testValue = 5

    XCTAssertGreaterThanOrEqual(currentValue, testValue)
  }
//: * `XCTAssertLessThan(expression1, expression2)` 👉 Vérifie que la valeur de l'expression1 est strictement inférieur à celle de l'expression2
  func testXCTAssertLessThan() {
    let currentValue = 0
    let testValue = 5

    XCTAssertLessThan(currentValue, testValue)
  }
//: * `XCTAssertLessThanOrEqual(expression1, expression2)` 👉 Vérifie que la valeur de l'expression1 est inférieur ou égale à celle de l'expression2
  func testXCTAssertLessThanOrEqual() {
    let currentValue = 5
    let testValue = 5

    XCTAssertLessThanOrEqual(currentValue, testValue)
  }
//: ## Check whether a function call throws, or doesn’t throw, an error
//: * `XCTAssertThrowsError(expression)` 👉 Vérifie qu'une expression génère une erreur (99,99% du temps pour des function throws)
  func testXCTAssertThrowsError() {
    XCTAssertThrowsError(try throwingFunction())
  }
//: * `XCTAssertNoThrow(expression)` 👉 Vérifie qu'une expression ne génère pas d'erreur (99,99% du temps pour des function throws)
  func testXCTAssertNoThrow() {
    XCTAssertNoThrow(try notThrowingFunction())
  }
//: ## Generate a failure immediately and unconditionally
//: * `XCTFail(_ message: String = "")` 👉 Génère une erreur immédiatement & sans condition
  func testXCTFail() {
    XCTFail("Test fail")
  }
//: ## Anticipate known test failures to prevent failing tests from affecting your workflows
//: * `XCTExpectFailure(_ failureReason: String? = nil)` 👉 Vérifie que le test échoue mais ne renvoie pas de failure pour les UTs
  func testXCTExpectFailure() {
    let shouldPass = false
    XCTExpectFailure("I should fix this UT")
    XCTAssertTrue(shouldPass)
  }
//: ## Skip tests when meeting specified conditions.
//: * `XCTSkip(_ message: String = "")` 👉 Permet d'ignorer (de ne pas le tester) le test
  func testwhatever() {
    let shouldBeSkipped = true
    if shouldBeSkipped {
      XCTSkip("Skipping this UT : \(#function)")
    }
  }
//: ## Asynchronous Tests and Expectations
  func testAsynchronousFunction() {
//: 1) Créer une `XCTestExpectation` 👉 uniquement pour tester du code asynchrone
    let expectation = XCTestExpectation(description: "Download apple.com home page")
//: 2) Appel de la fonction asynchrone (ici un call réseau)
    let url = URL(string: "https://apple.com")!
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
//: 3) S'il y a une erreur 👉 `XCTFail` afin d'arrêter le test et de renvoyer une erreur
        XCTFail(error.localizedDescription)
      } else {
        XCTAssertNotNil(data)
//: 4) Sinon tout s'est bien passé 👉 appel de `fulfill()` sur le `XCTestExpectation` 👉 le code asynchrone est fini
        expectation.fulfill()
      }
    }
    .resume()
//: 5) `wait(for expectations: [XCTestExpectation], timeout seconds: TimeInterval)` 👉 attend jusqu'à ce le `XCTestExpectation` soit satisfait, avec un delai maximum de 10 secondes
    wait(for: [expectation], timeout: 10.0)
  }
}

MyTests.defaultTestSuite.run() // Permet de run les test unitaires dans XCode
