//
//  ViewController.swift
//  HackerBooks
//
//  Created by Pedro Martin Gomez on 4/12/15.
//  Copyright © 2015 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var coverPage: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagslabel: UILabel!
    
    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var authorsValue: UILabel!
    @IBOutlet weak var tagsValue: UILabel!
    @IBOutlet weak var favImage: UIButton!
    
    var model : AGTBook?{
        didSet{
            
            guard model != nil else {
                return
            }
            updateUI()
        }
    }
    
    var selectedCellRowIndex : Int = -1
    
    let cellNotificationKey = "com.pmargom.cellNotificationKey"
    
    @IBAction func markUnMarkAsFav(sender: AnyObject) {
        if (model?.isFavourite == true) {
            //print("Marked as favourite")

            if let image = UIImage(named: "nofav") {
                self.favImage.setImage(image, forState: .Normal)
            }

        }
        else {
            //print("Unmarked as favourite")

            if let image = UIImage(named: "fav") {
                self.favImage.setImage(image, forState: .Normal)
            }

        }
        
        //update the model
        let previousValue = model?.isFavourite
        model?.isFavourite = !previousValue!
        
        let data = [selectedCellRowIndex: model!]
        NSNotificationCenter.defaultCenter().postNotificationName(cellNotificationKey, object: self, userInfo: data)
    }
    
    func updateUI(){
        
        // updating the tile
        self.title = model?.title
        
        dispatch_async(dispatch_get_main_queue(), {
            self.titleValue.text = self.model?.title
            self.authorsValue.text = self.model?.authors
            self.tagsValue.text = self.model?.tags
            if self.model?.isFavourite == true {
                if let image = UIImage(named: "fav") {
                    self.favImage.setImage(image, forState: .Normal)
                }
            }
            else {
                if let image = UIImage(named: "nofav") {
                    self.favImage.setImage(image, forState: .Normal)
                }
            }
        })
        
        // loading the pdf from url
        if let urlImage = model?.urlImage {
            loadCoverPage(urlImage)
        }
        
    }
    
    func loadCoverPage(urlImage: NSURL) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(urlImage) {
            data, response, error in
            
            guard data != nil else {
                return
            }
            
            let image = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.coverPage.image = image
                self.activityIndicator.stopAnimating()
                
            })
            
        }
        
        task.resume()
    }
    
    //MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleValue.text = ""
        self.authorsValue.text = ""
        self.tagsValue.text = ""
        
        relocate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Averiguar si el segue en cuestión es el correcto
        if segue.identifier == "showPdf" {
            
            // Este el el mio
            let controller = segue.destinationViewController as! PdfViewController
            //let controller = segue.destinationViewController as? DetailViewController
            
            controller.model = model
            
        }
    }
    
    func relocate() {
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
        
            dispatch_async(dispatch_get_main_queue(), {
                
                self.coverPage.frame.origin.x = 20
                self.coverPage.frame.origin.y = 85
                self.coverPage.frame.size.width = 207
                self.coverPage.frame.size.height = 216
                
                self.titleLabel.frame.origin.x = 250
                self.titleLabel.frame.origin.y = 90
                
                self.titleValue.frame.origin.x = 250
                self.titleValue.frame.origin.y = 110

                self.authorsLabel.frame.origin.x = 250
                self.authorsLabel.frame.origin.y = 140
                
                self.authorsValue.frame.origin.x = 250
                self.authorsValue.frame.origin.y = 160
                
                self.tagslabel.frame.origin.x = 250
                self.tagslabel.frame.origin.y = 190
                
                self.tagsValue.frame.origin.x = 250
                self.tagsValue.frame.origin.y = 210
                
                self.favImage.frame.origin.x = 250
                self.favImage.frame.origin.y = 230

            })

        
        } else {
            dispatch_async(dispatch_get_main_queue(), {

                self.coverPage.frame.origin.x = 20
                self.coverPage.frame.origin.y = 85
                self.coverPage.frame.size.width = 280
                self.coverPage.frame.size.height = 260

                
                self.titleLabel.frame.origin.x = 20
                self.titleLabel.frame.origin.y = 360
                
                self.titleValue.frame.origin.x = 20
                self.titleValue.frame.origin.y = 380
                
                self.authorsLabel.frame.origin.x = 20
                self.authorsLabel.frame.origin.y = 410
                
                self.authorsValue.frame.origin.x = 20
                self.authorsValue.frame.origin.y = 430
                
                self.tagslabel.frame.origin.x = 20
                self.tagslabel.frame.origin.y = 460
                
                self.tagsValue.frame.origin.x = 20
                self.tagsValue.frame.origin.y = 480
                
                self.favImage.frame.origin.x = 20
                self.favImage.frame.origin.y = 500
                
            })
            
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        relocate()
    }


}

