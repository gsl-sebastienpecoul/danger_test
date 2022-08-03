import Foundation
import Danger

let danger = Danger()

// File changes
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
message("These files have changed: \(editedFiles.joined(separator: ", "))")

// Commit check

let commitsName = danger.git.commits.map(\.message)

message("PR commit : \(commitsName)")

commitsName.forEach {
    let result = validateRegex(input: $0)
    if result {
        message("Commits is valid")
    } else {
        message("Commits is not valid")
    }
}


private func validateRegex(input: String) -> Bool {

    let regexPattern = "^(feat|fix):[a-z\\(\\-\\)]+$"
    guard let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
    else { return false }
        
    // That uses the utf16 count to avoid problems with emoji and similar unicodes
    let range = NSRange(location: .zero, length: input.utf16.count)
        
    return regex.firstMatch(in: input, range: range) != nil
}