import Foundation
struct Message: Identifiable, Equatable{
    let id = UUID()
    let role: Role
    let content: String

    enum Role{
        case user
        case assistant
    }
}

