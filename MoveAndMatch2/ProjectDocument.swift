import UIKit

class ProjectDocument: UIDocument {
    
    static let fileExtension = "mmatch"
    
    var project = Project() {
        didSet {
            updateChangeCount(.done)
        }
    }
    
    override func contents(forType typeName: String) throws -> Any {
        let encoder = JSONEncoder()
        return try encoder.encode(project)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data else { throw DocumentError.wrongType }
        let decoder = JSONDecoder()
        project = try decoder.decode(Project.self, from: data)
    }
}

enum DocumentError : Error {
    case wrongType
}
