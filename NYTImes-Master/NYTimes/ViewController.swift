//
//  ViewController.swift
//  NYTimes
//
//  Created by Nitesh Ahuja on 23/10/18.
//  Copyright © 2018 Nitesh Ahuja. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate{
  
    @IBOutlet var tblNews:UITableView!
    @IBOutlet var Indicatorview:UIActivityIndicatorView!

    var arrNews = NSMutableArray()
    
    let screenSize: CGRect = UIScreen.main.bounds
    var screenHeight = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getResults(url:Api_Url)
        Indicatorview.hidesWhenStopped = true
        Indicatorview.startAnimating()
        Indicatorview.isHidden = false
        screenHeight = Int(screenSize.height)
    }
    
    //MARK:- TABLEVIEW METHOD
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let lblTitle  =  cell?.contentView.viewWithTag(1) as! UILabel
        //let lblDesc =  cell?.contentView.viewWithTag(2) as! UILabel
        let lblByLine = cell?.contentView.viewWithTag(3) as! UILabel
        let lblDate = cell?.contentView.viewWithTag(4) as! UILabel
        let imageNews =  cell?.contentView.viewWithTag(5) as! UIImageView
        
        if arrNews.count > 0
        {
            let dic = arrNews.object(at: indexPath.row) as! NSDictionary
            
             lblTitle.text = dic.value(forKey: "title") as? String

            let byLine = dic.value(forKey: "byline") as? String
            lblByLine.text = byLine! as String

            let publishedDate = dic.value(forKey: "published_date") as? String
            lblDate.text = publishedDate! as String
            
            let imageData = dic.value(forKey: "media") as? NSArray
            let image = imageData?.object(at: 0) as! NSDictionary
            let mediaArray = image.value(forKey: "media-metadata") as! NSArray
            let urlDic = mediaArray.object(at: 0) as! NSDictionary
            let url = urlDic.value(forKey: "url") as! String
            let imgUrl = NSURL(string: url as String)
            
            imageNews.layer.cornerRadius = imageNews.frame.height/2
            imageNews.clipsToBounds = true
            imageNews.sd_setImage(with: imgUrl as URL?, completed: nil)

        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 125.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView"{
            
            let detailView : DetailVC? = segue.destination as? DetailVC
            let cell : UITableViewCell? = sender as? UITableViewCell
            
            if cell != nil && detailView != nil{
                
                let indexPath = self.tblNews.indexPathForSelectedRow!

                let dic = arrNews.object(at: indexPath.row) as! NSDictionary
                let detailString = dic.value(forKey: "abstract")
                detailView?.detailContentText = detailString as? String
                
                let titleString = dic.value(forKey: "title")
                detailView?.detailContentTitleText = titleString as? String
                
                let imageData = dic.value(forKey: "media") as? NSArray
                let image = imageData?.object(at: 0) as! NSDictionary
                let mediaArray = image.value(forKey: "media-metadata") as! NSArray
                let urlDic = mediaArray.object(at: 0) as! NSDictionary
                let url = urlDic.value(forKey: "url") as! String
                let imgUrl = NSURL(string: url as String)
                detailView?.detailImageURL = imgUrl as URL?
                
                self.tblNews.deselectRow(at: indexPath, animated: true)
            }
        }
        
    }
    
    //MARK:- API CALL METHOD
    func getResults(url:String)
    {
        let ser_signin = WebServices()
        ser_signin.delegate = self
        ser_signin.callSimpleWebService(url as String, method:"GET")
    }
    
    internal func webserviceCallFinishedWithSuccess(_ success: Bool, responseObj: NSDictionary)
    {
        OperationQueue.main.addOperation {
            self.Indicatorview.stopAnimating()
            self.Indicatorview.isHidden = true
            if success
            {
                    let arrdata = responseObj.value(forKey: "results") as? NSMutableArray
                    if (Double((arrdata?.count)!) > 0)
                    {
                        self.arrNews = arrdata!
                        self.tblNews.reloadData()
                        
                        self.Indicatorview.stopAnimating()
                        self.Indicatorview.isHidden = true
                        
                    }
            }
        }
    }
}

