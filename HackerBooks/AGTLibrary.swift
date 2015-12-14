//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Pedro Martin Gomez on 5/12/15.
//  Copyright © 2015 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class AGTLibrary {
    
    //MARK: - Private Inteface
    
    // books is a dictionay whose keys are the name of tags
    private var books: [String: [AGTBook]]
    private var tags: [String]
    
    //MARK: - Initialization
    init(arrayOfBooks: [AGTBook], arrayOfTags: [String]) {
        
        // create an empty dictionary
        books = Dictionary<String, [AGTBook]>()
        tags = arrayOfTags
        
        // prepare the rest of sections depending on tag list
        for tag in tags {
            books[tag] = Array<AGTBook>()
        }
        
        // processing the books by matching every book with its tag
        for book in arrayOfBooks {
            
            // get and split the tags for this book
            let tagsForCurrentBook = book.tags
            let tagList = tagsForCurrentBook!.characters.split{$0 == ","}.map(String.init)
                
            for tag in tagList {
                
                let cleanTag = tag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                // add this book to each collection where its tags match
                books[cleanTag]?.append(book)
                
            }
            
            if (book.isFavourite) {
                books[ArtificialCategories.Favourites.rawValue]?.append(book)
            }
            
//            if (book.isUnknwon) {
//                books[ArtificialCategories.Unknown.rawValue]?.append(book)
//            }
            
        }
        
    }
    
    //MARK: - Public Interface
    func tagList(arrayOfBooks: [AGTBook]) -> [String] {
        
        var arrOfTags = [String]()

        for book in arrayOfBooks {
            
            // get and split the tags for this book
            let tagsForCurrentBook = book.tags
            let tagList = tagsForCurrentBook!.characters.split{$0 == ","}.map(String.init)
            
            for tag in tagList {
                
                let cleanTag = tag.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                // add this book to each collection where its tags match
                if (!arrOfTags.contains(cleanTag)) {
                    arrOfTags.append(cleanTag)
                }
                
            }
            
        }
        return arrOfTags
        
    }

    // Total number of books
    var bookCount: Int {
        get {
            return self.books.count
        }
    }
    
    var tagList: [String] {
        
        get {
            return self.tags
        }
        
    }
    
    // Number of books by tag
    func bookCountForTag(tag: String?) -> Int {
        
        guard self.tags.contains(tag!) else {
            return 0
        }
        
        if let books = self.books[tag!] {
            return books.count
        }
        
        return 0
        
    }
    
    // List of books by tag
    func booksForTag(tag: String?) -> [AGTBook]? {
        
        guard self.tags.contains(tag!) else {
            return nil
        }
        
        return books[tag!]
        
    }
    
    func addBookToFav(book: AGTBook) {
        
        self.books[ArtificialCategories.Favourites.rawValue]?.append(book)
        
    }

    func removeBookToFav(idx: Int) {
        
        self.books[ArtificialCategories.Favourites.rawValue]?.removeAtIndex(idx)
        
    }
    
    // Retrieve a book for a specific tag
    subscript(idx: Int, inTag tag: String?) -> AGTBook?{
        get{
            if let tagBooks = booksForTag(tag) {
            
                return tagBooks[idx]
                
            }
            
            return nil
        }
    }
    
}
