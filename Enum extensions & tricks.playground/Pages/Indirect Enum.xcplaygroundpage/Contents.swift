/*:
 # `enum` récursive avec `indirect`
 * Pour qu'une `enum` soit récursive, un `case` doit avoir une `associated value` du type de cette `enum`
 * Rappel : une `enum` est une *value type* et une *value type* ne peux pas se contenir elle-même (càd se faire référence dans un `case`)
 * Prenons l'exemple d'une **liste chaînée**
 */

/*:
 * Déclaration d'une `enum` récursive sans l'utilisatiopn `indirect`
    * Compiler error : *Recursive enum `LinkedList<T>` is not marked `indirect`*
 */

enum LinkedListe<T> {
  case endpoint(T)
  case node(T, LinkedListe)
}

/*:
 * Ainsi pour rendre une `enum` récursive, il faut utiliser le mot clé `indirect`
 * Deux possibilités :
    * L'appliqué **uniquement** aux cas qui font référence à l'enum
    * L'appliqué à l'`enum` globalement
 * `indirect` indique au compilo qu'on veut une autre référence du même type dans notre *value type*, ici notre `enum`
 */
indirect enum LinkedList<T> {
  case endpoint(T)
  case node(T, LinkedList)
}

let linkedList: LinkedList<Int> = .node(0, .node(1, .node(2, .endpoint(3))))

//: [< Previous: `enum` conforme à `Codable`](@previous)           [Home](Introduction)           [Next: NEXT >](@next)
