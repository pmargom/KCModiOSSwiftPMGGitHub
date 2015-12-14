//
//  AGTLibraryTableTableViewController.swift
//  HackerBooks
//
//  Created by Pedro Martin Gomez on 5/12/15.
//  Copyright © 2015 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class AGTLibraryTableTableViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var model: AGTLibrary?
    
    //MARK: - JSON Decoding
    
    private  func decodeJSON(bookArray: JSONArray) ->[StrictAGTBook]?{
        
        var result : [StrictAGTBook]? = nil
        
        result = decode(book: bookArray)
        
        return result;
        
    }
    
    private  func getTagsJSON(bookArray: JSONArray) ->[String]?{
        
        var result : [String]? = nil
        
        result = getTags(book: bookArray)
        
        // sorting the tag list
        result = result!.sort()
        
        return result;
        
    }
    
    func loadModelWithData() {
        
        // We should persist the JSON document in NSUserDefault
        let stUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var data: NSData
        
        if let json = stUserDefaults.stringForKey("jsonLibrary") {
            
            data = (json.dataUsingEncoding(NSUTF8StringEncoding))!
            
        }
        else {
            
            // first: we need to download load from Internet
            //let url = NSBundle.mainBundle().URLForResource("books_readable.json")
            let url = NSURL(string: "https://t.co/K9ziV0z3SJ")
            data = NSData(contentsOfURL: url!)!
            
            // second: we need to persit the json document
            stUserDefaults.setValue(NSString(data: data, encoding: NSUTF8StringEncoding), forKey: "jsonLibrary")
            
        }
        
        // try to parse JSON
        do {
            
            if let bookArray = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONArray {
                // load the model
                
                if let tags = getTagsJSON(bookArray), books = decodeJSON(bookArray) {
                    model = AGTLibrary(books: books, tags: tags)
                    
                    // after decoding the json, I need to load persisted favBooks
                    if let favBooks = loadPersistedFav() {
                        addFavBooks(favBooks)
                    }
                }
                else {
                    fatalError("Error during parsing books info")
                }
            }
            
        }catch{
            // Error al parsear el JSON
            print("Error during getting the JSON tags")
            
        }
        
    }
    
    func actOnNotificationForDetails(notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: cellNotificationKey, object: nil)
        
        let rowIndex = notification.userInfo?.keys.first as! Int
        let book = notification.userInfo?[rowIndex] as! AGTBook
        
        if book.isFavourite {
            model?.addBookToFav(book)
        }
        else {
            model?.removeBookToFav(rowIndex)
        }
        
        // we can persist the favourite list book
        
        let favBooks = (model?.booksForTag(ArtificialCategories.Favourites.rawValue))!
        persistFav(favBooks)
//        addFavBooks(favBooks)
        
        // the cell was marked or unmarked as favourite, so we have to update the table because datasource has has changed
        tableView.reloadData()
        
    }
    
    func addFavBooks(favBooks: [AGTBook]) {
        
        
        for favBook in favBooks {
            model?.addBookToFav(favBook)
        }
    
    }
    
    func persistFav(favBooks: [AGTBook])
    {
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(favBooks as NSArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: "favBooks")
        defaults.synchronize()
        
    }
    
    func loadPersistedFav() -> [AGTBook]? {
        
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("favBooks") as? NSData {
            
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [AGTBook]
        }
        
        return nil
        
    }
    
    //MARK: View methods
    
    let cellNotificationKey = "com.pmargom.cellNotificationKey"
    let cellNotificationViewPdfKey = "com.pmargom.cellNotificationViewPdfKey"
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        loadModelWithData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (model?.tagList.count)!
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model!.bookCountForTag(model?.tagList[section])
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var cleanTag = (model?.tagList[section])! as String
        cleanTag.replaceRange(cleanTag.startIndex...cleanTag.startIndex, with: String(cleanTag[cleanTag.startIndex]).capitalizedString)
        return cleanTag
    
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellID = "BookCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if cell == nil {
          
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellID)
        }

        let book = model![indexPath.row, inTag: model?.tagList[indexPath.section]]
        
        cell!.imageView?.image = UIImage(named: "Blank52")
        cell!.textLabel?.text = book?.title
        cell!.detailTextLabel?.text = book?.authors
        
        if let imageUrl = book?.urlImage {
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(NSMutableURLRequest(URL: imageUrl)) { data, response, error in
                
                guard data != nil else {
                    return
                }
                
                let image = UIImage(data: data!)
                
                dispatch_async(dispatch_get_main_queue(), {
                  
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        
                        cellToUpdate.imageView?.image = image
                    
                    }
                    
                })
                
            }
            
            task.resume()
            
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // the cell needs to subscribe to the favourite notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actOnNotificationForDetails:", name: cellNotificationKey, object: nil)
        
        // the cell needs sent a notification in order to update the webview
        
        let book = model![indexPath.row, inTag: model?.tagList[indexPath.section]]
        let data = [indexPath.row: book!]
        NSNotificationCenter.defaultCenter().postNotificationName(cellNotificationViewPdfKey, object: self, userInfo: data)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Segues
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Averiguar si el segue en cuestión es el correcto
        if segue.identifier == "showDetails" {
            
            // Este el el mio
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            //let controller = segue.destinationViewController as? DetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let book = model![indexPath!.row, inTag: model?.tagList[indexPath!.section]]
            controller.model = book
            controller.selectedCellRowIndex = indexPath!.row
            
        }
    }

}
