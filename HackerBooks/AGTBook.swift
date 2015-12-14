//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Pedro Martin Gomez on 4/12/15.
//  Copyright © 2015 Pedro Martin Gomez. All rights reserved.
//

import Foundation

enum ArtificialCategories: String {
    
    case Favourites = "Favourites"
    case Unknown = "Unknown"
    
}

class AGTBook: NSObject, NSCoding, Comparable {
    
    //MARK: - PROPERTIES
    
    let authors           : String?
    var isFavourite       : Bool      = false
    //let isUnknwon         : Bool      = false
    let tags              : String?
    let title             : String?
    let urlPdf            : NSURL
    let urlImage          : NSURL
    var localPathPdf      : String?
    var localPathImage    : String?

    
    
    //MARK: - COMPUTED VARIABLES
    
    //MARK: - INIT
    
    required init(coder aDecoder: NSCoder) {
        authors = aDecoder.decodeObjectForKey("authors") as! String?
        isFavourite = aDecoder.decodeObjectForKey("isFavourite") as! Bool
        tags = aDecoder.decodeObjectForKey("tags") as! String?
        title = aDecoder.decodeObjectForKey("title") as! String?
        urlPdf = aDecoder.decodeObjectForKey("urlPdf") as! NSURL
        urlImage = aDecoder.decodeObjectForKey("urlImage") as! NSURL
        localPathPdf = aDecoder.decodeObjectForKey("localPathPdf") as! String?
        localPathImage = aDecoder.decodeObjectForKey("localPathImage") as! String?
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(authors, forKey: "authors")
        aCoder.encodeObject(isFavourite, forKey: "isFavourite")
        aCoder.encodeObject(tags, forKey: "tags")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(urlPdf, forKey: "urlPdf")
        aCoder.encodeObject(urlImage, forKey: "urlImage")
        aCoder.encodeObject(localPathPdf, forKey: "localPathPdf")
        aCoder.encodeObject(localPathImage, forKey: "localPathImage")}
    
    init(authors: String?, tags: String?, title: String?, urlImage: NSURL, urlPdf: NSURL, localPathPdf: String?, localPathImage: String?) {
        
        self.authors = authors
        self.tags = tags
        self.title = title
        self.urlPdf = urlPdf
        self.urlImage = urlImage
        self.localPathImage = localPathPdf
        self.localPathImage = localPathImage

    }
    
    convenience init(urlImage: NSURL, urlPdf: NSURL) {
        
        self.init(authors: nil, tags: nil, title: nil, urlImage: urlImage, urlPdf: urlPdf, localPathPdf: nil, localPathImage: nil)
        
    }

    
    //MARK: - PROXIES
    
    var proxyForComparison : String {
        
        get {
            
            return "\(title)\(authors)"
            
        }
        
    }
    
    var proxiForSorting : String {
        
        get {
            
            return "A\(title)\(authors)\(tags)"
            
        }
        
    }
    
}

//MARK: - OPERATORS

func ==(lhs: AGTBook, rhs: AGTBook) -> Bool {
    
    // check if they are the same object
    guard !(lhs === rhs) else {
        return true
    }
    
    // check if they have the same type
    guard lhs.dynamicType == rhs.dynamicType else {
        return false
    }
    
    // check their contents
    
    return (lhs.proxyForComparison == rhs.proxyForComparison)
    
}

func <(lhs: AGTBook, rhs: AGTBook) -> Bool {
    
    return (lhs.proxyForComparison < rhs.proxyForComparison)
    
}
