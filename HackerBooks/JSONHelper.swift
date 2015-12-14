//
//  JSONHelper.swift
//  HackerBooks
//
//  Created by Pedro Martin Gomez on 5/12/15.
//  Copyright © 2015 Pedro Martin Gomez. All rights reserved.
//

import UIKit

/*
{
"authors": "Scott Chacon, Ben Straub",
"image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
"pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
"tags": "version control, git",
"title": "Pro Git"
}
*/

//MARK: - KEYS

enum JSONKeys: String {
    case authors = "authors"
    case urlImage = "image_url"
    case urlPdf = "pdf_url"
    case tags = "tags"
    case title = "title"
}

//MARK: - ALIASES

typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String:JSONObject]
typealias JSONArray         = [JSONDictionary]

//MARK: - ERRORS

enum JSONError : ErrorType {
    case WrongURLFormatForJSONResource
    case ResourcePointedByURLNotReachable
    case JSONParsingError
    case WrongJSONFormat
}

//MARK: - STRUCTS

struct StrictAGTBook {
    
    let authors     : String
    let isFavourite : Bool      = false
    let tags        : String
    let title       : String
    let urlImage    : NSURL
    let urlPdf      : NSURL
    
}

//MARK - DECODING

// Extracting and retrieving a list with all different
func getTags(book json: JSONArray) -> [String] {
    
    var listOfTags = [String]()
    // first, we can add the favourites and unknow tag
    listOfTags.append(ArtificialCategories.Favourites.rawValue)
//    listOfTags.append(ArtificialCategories.Unknown.rawValue)
    
    for item in json {
        
        let itemTags = item[JSONKeys.tags.rawValue] as! String
        
        let tagList = itemTags.characters.split{$0 == ","}.map(String.init)
        for tag in tagList {
            
            let cleanTag = tag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            if !listOfTags.contains(cleanTag)  {
                listOfTags.append(cleanTag)
            }
            
        }
    }
    
    //print(listOfTags)
    
    return listOfTags
    
}


func decode(book json:JSONDictionary) throws -> StrictAGTBook {
    
//    let urlImageString = json[JSONKeys.urlImage.rawValue] as? String // the image url is present in the JSON document
//    let urlImage = NSURL(string: urlImageString!)                           // the url is correct
//    let imgData = NSData(contentsOfURL: urlImage!)
//    let coverPage = UIImage(data: imgData!)
    
    guard let urlImageString = json[JSONKeys.urlImage.rawValue] as? String, // the image url is present in the JSON document
        urlImage = NSURL(string: urlImageString)
        else {
            throw JSONError.WrongURLFormatForJSONResource
    }
    
    guard let urlPdfString = json[JSONKeys.urlPdf.rawValue] as? String,     // the pdf url is present in the JSON document
        urlPdf = NSURL(string: urlPdfString)
        else {
            throw JSONError.WrongURLFormatForJSONResource
    }
    
    let authors = json[JSONKeys.authors.rawValue] as! String
    let tags = json[JSONKeys.tags.rawValue] as! String
    let title = json[JSONKeys.title.rawValue] as! String
    
    
    // everything it seems to be ok
    return StrictAGTBook(authors: authors, tags: tags, title: title, urlImage: urlImage , urlPdf: urlPdf)
    
}

func decode(book json: JSONArray) -> [StrictAGTBook] {
    
    var results = [StrictAGTBook]()
    
    do {
        for dict in json {
            
            //print(dict)
            let item = try decode(book: dict)
            
            results.append(item)
            
        }
        
    } catch {
        fatalError("Error during parsing json array")
    }
    
    return results
    
    
}

//MARK: - INITIALIZATION

extension AGTBook {
    
    // an init that accepts packed parameters in an StrinctAGTBook
    convenience init(strinctAGTBook obj: StrictAGTBook) {
        
        self.init(authors: obj.authors, tags: obj.tags, title: obj.title, urlImage: obj.urlImage, urlPdf: obj.urlPdf, localPathPdf: nil, localPathImage: nil)
    
    }
}

extension AGTLibrary {
    
    convenience init(books bs: [StrictAGTBook], tags: [String]) {
        
        var arrOfBook = [AGTBook]()
        //var arrOfTags = [String]()
        
        for each in bs {
            
            let b = AGTBook(strinctAGTBook: each)
            arrOfBook.append(b)
            
        }

        self.init(arrayOfBooks: arrOfBook, arrayOfTags: tags)
        
    }
    
}



























