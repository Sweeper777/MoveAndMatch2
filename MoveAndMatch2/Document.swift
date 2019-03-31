//
//  Document.swift
//  MoveAndMatch2
//
//  Created by Mulang Su on 31/03/2019.
//  Copyright © 2019 Mulang Su. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

