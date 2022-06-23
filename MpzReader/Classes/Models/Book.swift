//
//  Book.swift
//  MpzReader
//
//  Created by Hasitha Mapalagama on 8/16/19.
//

import Foundation
public class MpzBook {
    public var id : String!
    public var epubPath : URL!
    public var epubName : String!
    public var epubExtractPath : URL!
    
    public init(withPath path : URL, id : String, name : String) {
        self.epubName = name
        self.epubPath = path
        self.id = id
    }
}
