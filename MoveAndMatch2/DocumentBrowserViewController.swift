//
//  DocumentBrowserViewController.swift
//  MoveAndMatch2
//
//  Created by Mulang Su on 31/03/2019.
//  Copyright © 2019 Mulang Su. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        //1.
        guard let url = getNewDocumentURL() else {
            importHandler(nil, .none)
            return
        }
        let newdoc = ProjectDocument(fileURL: url)
        
        //2.
        newdoc.save(to: url, for: .forCreating) { saveSuccess in
            
            //3.
            guard saveSuccess else {
                importHandler(nil, .none)
                return
            }
            
            //4.
            newdoc.close { (closeSuccess) in
                guard closeSuccess else {
                    importHandler(nil, .none)
                    return
                }
                
                importHandler(url, .move)
            }
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the ProjectDocument View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the ProjectDocument View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: ProjectDocument Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        documentViewController.document = ProjectDocument(fileURL: documentURL)
        
        present(documentViewController, animated: true, completion: nil)
    }
    
    func getNewDocumentURL() -> URL? {
        guard let firstPart = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        var numberToTry = 1
        while FileManager.default.fileExists(atPath: firstPart.appendingPathComponent("Untitled Project \(numberToTry)").appendingPathExtension(ProjectDocument.fileExtension).absoluteString) {
            numberToTry += 1
        }
        return firstPart.appendingPathComponent("Untitled Project \(numberToTry)").appendingPathExtension(ProjectDocument.fileExtension)
    }
}

