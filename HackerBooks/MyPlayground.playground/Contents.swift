

import UIKit


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
    let coverPage   : UIImage
    let isFavourite : Bool      = false
    let tags        : String
    let title       : String
    let urlPdf      : NSURL
    
}

//MARK - DECODING

func decode(book json:JSONDictionary) throws -> StrictAGTBook {
    
    guard let urlImageString = json[JSONKeys.urlImage.rawValue] as? String, // the image url is present in the JSON document
        urlImage = NSURL(string: urlImageString),                           // the url is correct
        imgData = NSData(contentsOfURL: urlImage),                          // it was possible to get the image info from url
        coverPage = UIImage(data: imgData)                                  // at this point, I have the cover page image
        else {
            throw JSONError.WrongURLFormatForJSONResource
    }
    
    guard let urlPdfString = json[JSONKeys.urlPdf.rawValue] as? String,     // the pdf url is present in the JSON document
        urlPdf = NSURL(string: urlPdfString) else {                         // the url is correct, so we'll be able to load it in a WebViewController
            throw JSONError.WrongURLFormatForJSONResource
    }
    
    let authors = json[JSONKeys.authors.rawValue] as! String
    let tags = json[JSONKeys.tags.rawValue] as! String
    let title = json[JSONKeys.title.rawValue] as! String
    
    
    // everything it seems to be ok
    return StrictAGTBook(authors: authors, coverPage: coverPage, tags: tags, title: title, urlPdf: urlPdf)
    
}

func decode(book json: JSONArray) -> [StrictAGTBook] {
    
    var results = [StrictAGTBook]()
    
    do {
        for dict in json {
            
            print(dict)
            let item = try decode(book: dict)
            
            results.append(item)
            
        }
        
    } catch {
        fatalError("Error during parsing json array")
    }
    
    return results
    
}

func getTags(book json: JSONArray) -> [String] {
    
    var listOfTags = [String]()
    
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
    
    print(listOfTags)
    
    return listOfTags
    
}

// JSON url https://t.co/K9ziV0z3SJ

var tags : [String] = [String]()

do {
    
    if let url = NSURL(string: "https://t.co/K9ziV0z3SJ"),
        data = NSData(contentsOfURL: url),
        jsons = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray {
            
            tags = getTags(book: jsons)
            
    }
} catch {
    print("error serializing JSON: \(error)")
}

print(tags)
