# Swift Playgrounds
A set of playgrounds that explains a Swift topic.

## Details 
These playgrounds cover a technical topic of Swift with examples. **All explanations are in French**.

Here's the list:
- [**@(non)escaping closures**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/%40(non)escaping%20closures/%40(non)escaping%20closures/ContentView.swift): What are the differences between `@nonescaping` and `@escaping`?

- [**@autoclosure**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/%40autoclosure.playground/Contents.swift): How to transform a function argument into a closure?

- [**@discardableResult**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/%40discardableResult/DiscardableResult/DiscardableResult.swift): How to ignore the warning if the returned value of a function is not affected?

- [**ARC & Memory Leaks**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/ARC%20%26%20Memory%20Leaks.playground/Contents.swift): How the Automatic Reference Couting (*ARC*) works – What is a *memory leak* and how do you fix it?

- [**ARC, Retain Cycle & Memory Leaks**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/ARC%2C%20Retain%20Cycle%20%26%20Memory%20Leak.playground/Contents.swift): How the Automatic Reference Couting (*ARC*) works – What is a *memory leak* and how do you fix it?

- [**Access Control**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Access%20Control.playground/Contents.swift): How can we restrict certain parts of our code, or on the contrary make it open?

- [**Array extensions & tricks**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Array%20extensions%20%26%20tricks.playground/Pages): Functions of the standard library explained & some useful extensions.

- [**Custom Prefix, Postfix, Infix Operators**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Custom%20Prefix%2C%20Postfix%2C%20Infix%20Operators): How do you create your own prefix / postfix / infix operators that act as functions behind the scenes?

- [**Defer**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Defer.playground/Contents.swift): How to execute code just before the program leaves the scope of a function?

- [**Dependency Injection**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Dependecy%20Injection.playground/Pages/Untitled%20Page.xcplaygroundpage/Contents.swift): What is injection dependence? - Why use dependency injection? - What are the different types of dependency injections?

- [**Enum extensions & tricks**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Enum%20extensions%20%26%20tricks.playground/Pages): `enum` with & without *associated value*, `switch`, `if case let`, `guard case let`, `for case ... in`, `indirect enum`.

- [**ExpressibleByStringLiteral**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/ExpressibleByStringLiteral.playground/Contents.swift): What is the purpose of the `ExpressibleByStringLiteral` protocol? – How do you conform to it?

- [**Grand Central Dispatch**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Grand%20Central%20Dispatch.playground/Pages/Untitled%20Page.xcplaygroundpage/Contents.swift): asynchronous & synchronous execution, `DispatchQueue`, `QOS`, `DispatchWorkItem`, `DispatchGroup`, `DispatchSemaphore` and more.

- [**High Order Functions**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/High%20Order%20Functions.playground/Pages): `filter`, `map`, `reduce`, `compactMap`, `flatMap` & `contains` functions explained through examples.

- [**Keypath**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Keypath.playground/Pages): What is a keypath? – Why you should use it? – How to create your own predicates?

- [**Lazy Property**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Lazy%20Property.playground/Contents.swift): What is a `lazy` property? – For which use case is it used? – What are the differences between a `lazy` property and a *computed property*?

- [**Literal Expression & Log function**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Literal%20Expression%20%26%20Log%20function.playground/Contents.swift): `#file`, `#filePath`, `#fileID`, `#line`, `#column`, `#function` – How to create a function for logging?

- [**Opaque Return Type**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Opaque%20Return%20Type.playground/Contents.swift): What is a *opaque return type*? – What are the limitations of `some`? – How to compare two objects of an *opaque return type*? – What are the limits?

- [**Property Observers**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Property%20Observers.playground/Contents.swift): What is a *property observers*? – How and when to use such a property?

- [**Protocols**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Protocols.playground/Pages): How to declare and conform to a protocol? – How to create default implementations with *protocol extension*? – What is protocol inheritance?

- [**RawRepresentable**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/RawRepresentable.playground/Contents.swift): What is the purpose of the `RawRepresentable` protocol? – How do you conform to it?

- [**Static properties & functions**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Static%20properties%20%26%20functions.playground/Contents.swift): What are static properties and functions? – When to use them?

- [**Strings extensions & tricks**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Strings%20extensions%20%26%20tricks.playground/Pages): Tips on `String` thanks to custom extensions.

- [**Swift Concurrency**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Swift%20Concurrency): A file containing playgrounds for Swift Concurrency.

  - [**@globalActor, GlobalActor & @MainActor**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Swift%20Concurrency/%40globalActor%2C%20GlobalActor%20%26%20%40MainActor.playground/Contents.swift): What is a `@globalActor`? – How to create our own `@globalActor` thanks to the `GlobalActor` protocol? – What is `@MainActor` and when should it be used?

  - [**Actor**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Swift%20Concurrency/Actor.playground/Pages): What is an `actor`? – What problems does it solve? – How and when to use it? – How to constrain protocols so that they can be conformed only by actors?

  - [**Async Let**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Swift%20Concurrency/Async%20Let.playground/Contents.swift): How to create asynchronous constants with `async let`? – How to make parallel network calls?

  - [**Async await**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Swift%20Concurrency/Async%20await.playground/Pages): How to create asynchronous functions with `async await`? – Why is it easier to read and understand asynchronous code? – How to adopt `async await` in an existing project?

  - [**AsyncSequence**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Swift%20Concurrency/AsyncSequence.playground/Contents.swift): What is the purpose of the `AsyncSequence` protocol? – How do you conform to it?

  - [**Sendable, @unchecked Sendable & @Sendable**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Swift%20Concurrency/Sendable%2C%20%40unchecked%20Sendable%20%26%20%40Sendable.playground/Contents.swift): What is the `Sendable` protocol? – What does it allow to do? – Why use `@unchecked Sendable` for classes? – Why and when to use `@Sendable` in closures? 

  - [**Structured Concurrency**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Swift%20Concurrency/Structured%20Concurrency.playground/Contents.swift): How to execute, cancel and monitor asynchronous operations?

- [**Swift Updates**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Swift%20Updates): A file containing playgrounds for Swift updates.

  - [**Swift 5.5**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/Swift%20Updates/Swift%205.5.playground/Pages)

- [**Typealias**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Typealias.playground/Contents.swift): What is a `typealias`? – How to create a generic `typealias`?

- [**URLComponents + URLRequest**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/URLComponents%20%2B%20URLRequest/URLRequest/ContentView.swift): How to create robust *get* and *post* requests? 

- [**Unit Tests**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/Unit%20Tests.playground/Contents.swift): Which function should be used according to the desired test?

- [**init, init?, convenience init, requiered init**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/init%2C%20init%3F%2C%20convenience%20init%2C%20requiered%20init.playground/Pages): How to initialise a `struct` or a `class` with `init`, `init?`, `convenience init` or `requiered init`?

- [**private(set)**](https://github.com/LucasAbijmil/Swift-Playgrounds/blob/master/private(set).playground/Contents.swift): What is `private(set)`? – When and why use it?

- [**try, throws & rethrows**](https://github.com/LucasAbijmil/Swift-Playgrounds/tree/master/try%2C%20throws%20%26%20rethrows.playground/Pages): What are the different ways to call a function that `throws`?  – What problem does `rethrows` solve?

## Resources
- [Swift Documentation](https://swift.org/documentation/)
- [*Improve your knowledge of Swift!*](https://www.youtube.com/playlist?list=PLdXMqVQnoFleH3GSuTUpr3Fjzp1JMy-je) by [Vincent Pradeilles](https://twitter.com/v_pradeilles)
- [Hacking with Swift](https://www.hackingwithswift.com/) & [What's new in Swift](https://www.whatsnewinswift.com/) by [Paul Hudson](https://twitter.com/twostraws)

## Improvements
Some playgrounds need to be reworked to provide a better quality. 
However, if you notice errors or ambiguous passages, do not hesitate to open a PR.

Here's the list:
- ARC & Memory Leaks ∪ ARC, Retain Cycle & Memory Leaks
- *init, init?, convenience init, requiered init*: add a file for `actor` initialization.

## Author
Lucas Abijmil, lucas.abijmil@gmail.com. 

You can also reach me on [Twitter](https://twitter.com/lucas_abijmil).
