//
//  FoundationExtention.swift
//  HackerBooks
//
//  Created by Pedro Martin Gomez on 5/12/15.
//  Copyright © 2015 Pedro Martin Gomez. All rights reserved.
//

import Foundation

extension NSBundle {
    
    func URLForResource(fileName: String) -> NSURL? {
    
        let tokens = fileName.componentsSeparatedByString(".")
        
        return self.URLForResource(tokens.first, withExtension: tokens.last)
        
    }
    
}
