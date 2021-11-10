import SwiftUI
/*:
 # Swift peut désormais trouver des membres conformes à un protocol dans une fonction générique
 * Use principalement avec SwiftUI
 * Permet d'utiliser une syntaxe semblable à celle des cases d'une `Enum` pour des protocols dans une fonction générique
 */
//: * Exemple avant l'update
struct SwitchToggleStyleView: View {
  
  var body: some View {
    Toggle("Example", isOn: .constant(true))
      .toggleStyle(SwitchToggleStyle())
  }
}
//: * Grâce à cette évolution on peut désormais réduire le code à ceci. Noté comment la syntaxe est proche de celle d'un cas d'une enum
struct SwitchToggleStyleReducedView: View {
  
  var body: some View {
    Toggle("Example", isOn: .constant(true))
      .toggleStyle(.switch)
  }
}
//: [< Previous: `#if` postfix member expressions](@previous)           [Home](Home)           [Next: enum sans `RawValue` conforme à `Codable` sans extra work >](@next)
