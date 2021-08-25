/*:
 ## Généralité sur le `KeyPath`
 * Ici on prend l'exemple avec des HOF car c'est une des situation où l'utilisation des `KeyPath` est la plus puissante
 */
let numbers = [1, 2, 3, 4, 5]
//: * Transformons ce `[Int]` en `[String]`
let numbersString = numbers.map { $0.description }
/*:
 * Quelques remarques sur ce que nous venons de faire :
    * Assez low-level : utilisation des `{ }` et `$0`
    * La closure sert de `getter` pour une property de leur argument et le return (ici description)
 */
/*:
 * Qu'est ce un qu'un `KeyPath` ?
    * Le `KeyPath` permet d'avoir une référence d'une propriété qu'on peut invoquer sur une instance afin de retourner cette propriété
    * Le compilateur est capable de prendre le `KeyPath` pour le transformer en `getter` function
    * Le `KeyPath` est une literal syntax qui permet de référencer le `getter` ou le `setter` d'une propriété d'un type
    * Avantage : plus redeable et plus safe à l'utilisation
 */
let numbersStrings = numbers.map(\.description)
/*:
 * Behind the scene, le `KeyPath` est un type générique avec 2 arguments génériques :
    * `Root` : type de l'instance sur lequel on va invoqué le `KeyPath` (ici `Int`)
    * `Value` : type de la propriété dont le `KeyPath` fait référence (ici `String`)
 * `KeyPath<Root: Int, Value: String>` transformé par le compilatuer en fonction avec la signature suivante : `(Root) -> Value`
 */
//: [Home](Introduction)           [Next : Prédicat avec un `KeyPath` >](@next)
