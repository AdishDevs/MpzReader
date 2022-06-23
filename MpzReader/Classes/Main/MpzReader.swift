//
//  MpzReader.swift
//  MpzReader
//
//  Created by Hasitha Mapalagama on 8/16/19.
//
import UIKit
import Foundation
import R2Streamer
import R2Shared
import R2Navigator
import SQLite
import ZIPFoundation
public class MpzReader {
    
    public static var configs = MpzConfig()
    public var book : MpzBook!
    public var pubBox : PubBox?
    public var server = PublicationServer()
    public var extracToPath : URL!
    
    public init(withBook book : MpzBook) {
        self.book = book
        self.initializeDatabase()
        R2EnableLog(withMinimumSeverityLevel: .debug)
    }
    
    public func present(inViewController vc : UIViewController) {
        let view = self.createBookView()
        if pubBox?.associatedContainer == nil || pubBox?.publication == nil {
            MpzReader.configs.onError?()
            MpzReader.configs.onDismiss?()
            return
        }
        vc.present(view, animated: true, completion: nil)
    }
    
    private func createBookView() -> UINavigationController {
        self.parseBook()
        self.extractEpub()
        
        
        let stry = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: type(of: self)))
        let vc = stry.instantiateViewController(withIdentifier: "reader") as! MpzBookVC
        vc.reader = self
        let navController = UINavigationController()
        navController.viewControllers = [vc]
        navController.modalPresentationStyle = .fullScreen
        return navController
    }
    
    private func extractEpub() {
        guard let (_, container) = pubBox else {
            print("pubbox nil, cant extract")
            return
        }
        do {
            var tmpFolder = URL.init(fileURLWithPath: NSTemporaryDirectory())
            tmpFolder = tmpFolder.appendingPathComponent(UUID.init().uuidString)
            try FileManager.default.createDirectory(at: tmpFolder, withIntermediateDirectories: true, attributes: nil)
            self.extracToPath = tmpFolder
            print("book temp extract path \(self.extracToPath)")
            let rootFile = URL.init(fileURLWithPath: container.rootFile.rootPath)
            let fileManager = FileManager()
            try fileManager.unzipItem(at: rootFile, to: self.extracToPath)
        } catch {
            print("error while adding epub to the server", error.localizedDescription)
        }
    }
    private func parseBook() {
        do {
            let (pubBox, _) = try EpubParser.parse(at: self.book.epubPath)
            let (publication, container) = pubBox
            print("epub parsed at", book.epubPath as Any, book.epubExtractPath as Any)
            self.pubBox = (publication, container)
        } catch {
            print("error while parsing epub", book.epubPath as Any, error.localizedDescription as Any)
        }
    }
    
    private func initializeDatabase() {
        let url = try? FileManager.default.url(
            for: .libraryDirectory,
            in: .userDomainMask,
            appropriateFor: nil, create: true
        )
        
        guard let rootPath = url else {
            print("database path initilization failed")
            return
        }
        
        guard let connection = try? Connection(rootPath.appendingPathComponent("db_fl").absoluteString) else {
            print("database initilization failed")
            return
        }
        
        MPZDBService.connection = connection
        Highlight.initialize()
        Highlight.fetch(ForBook: book.id)
    }
    
    func getColors(forAppearance appearance : UserProperty?) -> MpzColors {
        guard let app = appearance else {
            return MpzColors()
        }
        switch app.toString() {
        case  "readium-night-on":
            return MpzReader.configs.darkColors
        default:
            return MpzReader.configs.lightColors
        }
    }
}


public class MpzConfig {
    public var lightColors = MpzColors()
    public var darkColors = MpzColors.init(primary: UIColor.black, secondary: .white, textColor: .white, background: .black)
    public var isSettingsEnabled = true
    public var isEnableManualBookmarking = true
    public var isContentEnabled = true
    public var isHighlightsEnabled = true
    public var isShareEnabled = false
    public var isLookupEnabled = false
    public var fontName = "Helvetica"
    public var onDismiss : (() -> Void)?
    public var onError : (() -> Void)?
    public var onHtmlTransform : ((_ raw : String) -> String)?
    public var bookTitle : String? = nil
}
