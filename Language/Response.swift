import Foundation
import FoundationModels

@Generable
struct Response: Equatable{
    @Guide(description: "Step-by-step explanation of the physics solution")
    let explanation: String

    @Guide(description: "The formula used in solving equations")
    let formula: String

    @Guide(description: "The final numerical answer with units")
    let answer: String
}
