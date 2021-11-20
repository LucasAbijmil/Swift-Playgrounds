import SwiftUI
/*:
 # #if avec des expressions postfix
 * Use case principalement pour l'utilisation avec SwiftUI
 */
//: * Exemple d'un use case classique pour une `View` SwiftUI
struct SomeText: View {
  
  var body: some View {
    Text("Hello, World!")
    #if os(iOS)
        .font(.largeTitle)
    #else
        .font(.headline)
    #endif
  }
}
//: * Il est également possible de nester des checks
struct SomeTextWithDebug: View {
  
  var body: some View {
    Text("Hello, World!")
    #if os(iOS)
        .font(.largeTitle)
        #if DEBUG
            .foregroundColor(.red)
        #endif
    #else
        .font(.headline)
    #endif
  }
}
//: [< Previous: `lazy var` in local context](@previous)           [Home](Home)           [Next: Extending static member lookup >](@next)
