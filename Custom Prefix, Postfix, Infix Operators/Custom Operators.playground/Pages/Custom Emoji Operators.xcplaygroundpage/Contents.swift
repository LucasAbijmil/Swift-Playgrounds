//: [Previous](@previous)
/*:
 # Custom Emoji Operator
 ### Setup the custom operator
 */
extension String {
    static func + (lhs: String, rhs: String) -> String {
        switch (lhs, rhs) {
        case ("πΉ", "βοΈ"):
            return "π"
        case ("π¬", "βοΈ"):
            return "π₯Ά"
        case ("π’", "π₯"):
            return "π₯΅"
        case ("π₯", "π₯¬"):
            return "π₯¬"
        case ("π₯¬", "π₯"):
            return "π₯"
        case ("π₯", "π"):
            return "π₯"
        case ("π§", "π"):
            return "πΆπ»"
        case ("π¦", "π"):
            return "π¦"
        case ("π¨", "π§"):
            return "π "
        default:
            print("\(lhs) and \(rhs) not matched")
            return "βοΈ"
        }
    }
}
/*:
 ### Making use of the custom operator
 */
print("πΉ" + "βοΈ")
print("π¬" + "βοΈ")
print("π’" + "π₯")
print("π₯" + "π₯¬" + "π₯" + "π")
print("π§" + "π")
print("π¦" + "π")
print("π¨" + "π§")
