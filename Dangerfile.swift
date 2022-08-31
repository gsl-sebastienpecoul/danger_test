import Foundation
import Danger

let danger = Danger()

// File changes
let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
message("These files have changed: \(editedFiles.joined(separator: ", "))")

// Commit count check
let commitsCount = danger.git.commits.count 
if commitsCount > 1 {
    warn("Merge should only contain one commit, make sure to squash your commits before merging")
}

checkCommitsName()

// Commit name check
private func checkCommitsName() {
    let commitsName = danger.git.commits.map(\.message)
    commitsName.forEach {

/*
        if let ticketNumber = extractTicketNumber(input: $0) {
            message(ticketNumber)
        }*/

        // Ignore these prefix, since convention is less strictier on theses
        if $0.starts(with: "chore") { return }

        // ...
        if $0.starts(with: "pod update") { return }

        let result = validateRegex(input: $0)
        if result {
          // message("Commits is valid")
        } else {
            fail("Commit name should respect conventional commit convention\nActual commit format: **\($0)**\nExpected commit format: **feat(MSRY-10): You commit message**")
        }
    }
}

private func validateRegex(input: String) -> Bool {

    let regexPattern = "^(feat|fix)\\([A-Z]{3,4}-[0-9]{1,4}\\):[a-zA-Z ]+$"

    //let regexPattern = "^(feat|fix):[a-z\\(\\-\\)]+$"
    
    guard let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
    else { return false }
        
    // That uses the utf16 count to avoid problems with emoji and similar unicodes
    let range = NSRange(location: .zero, length: input.utf16.count)
        
    return regex.firstMatch(in: input, range: range) != nil
}

/*
private func extractTicketNumber(input: String) -> String? {
     let regexPattern = "\\([A-Z]{3,4}-[0-9]{1,4}\\)"

    guard let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
    else { return nil }
        
    // That uses the utf16 count to avoid problems with emoji and similar unicodes
    let range = NSRange(location: .zero, length: input.utf16.count)
        
    guard let result = regex.firstMatch(in: input, range: range) else { return nil }

    return input.substring(with: result.range)
}
*/