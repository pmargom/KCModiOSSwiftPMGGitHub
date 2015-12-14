//
//  PdfWebViewController.swift
//  HackerBooks
//
//  Created by Pedro Martin Gomez on 13/12/15.
//  Copyright © 2015 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pdfWebView: UIWebView!
    
    var model : AGTBook?{
        didSet{
            
            updateUI()
        }
    }
    
    func actOnNotificationForViewPdf(notification: NSNotification) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: cellNotificationViewPdfKey, object: nil)
        
        let rowIndex = notification.userInfo?.keys.first as! Int
        let book = notification.userInfo?[rowIndex] as! AGTBook
        
        // updating the tile
        self.title = book.title
        
        // loading the pdf from url

        loadPdf(book.urlPdf)
        
    }
    
    func updateUI(){
        
        // updating the tile
        self.title = model?.title
        
        // loading the pdf from url
        if let urlPdf = model?.urlPdf {
            loadPdf(urlPdf)
        }
        
    }
    
    func loadPdf(urlPdf: NSURL) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(urlPdf) {
            data, response, error in
            
            guard data != nil else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.pdfWebView.loadData(data!, MIMEType: "application/pdf", textEncodingName: "", baseURL: NSURL())
                self.activityIndicator.stopAnimating()
                
            })
            
        }
        
        task.resume()
    }
    
    let cellNotificationViewPdfKey = "com.pmargom.cellNotificationViewPdfKey"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "actOnNotificationForViewPdf:", name: cellNotificationViewPdfKey, object: nil)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: cellNotificationViewPdfKey, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // preparin the webview zoom
        pdfWebView.scalesPageToFit = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
