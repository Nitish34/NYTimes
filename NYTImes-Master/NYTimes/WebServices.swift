//
//  WebServices.swift
//  NYTimes
//
//  Created by Nitesh Ahuja on 23/10/18.
//
//

import UIKit

protocol WebServiceDelegate: class {
    func webserviceCallFinishedWithSuccess(_ success:Bool,responseObj:NSDictionary)
}

class WebServices: NSObject
{
    weak var delegate:WebServiceDelegate?
    
    func callSimpleWebService(_ url:String, method:String)
    {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let strUrl = NSString(format:"%@",url)
        let URL = NSURL(string:strUrl as String)
        let request = NSMutableURLRequest(url: URL! as URL)
        request.httpMethod = method
        
        let task =  session.dataTask(with: request as URLRequest, completionHandler: {(data,response, error) -> Void in

            if error == nil
            {
                do{
                    let resposneData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    self.delegate?.webserviceCallFinishedWithSuccess(true, responseObj:resposneData as! NSDictionary)
                }
                catch{}
            }
            else
            {
               // print(error?.localizedDescription)
                self.delegate?.webserviceCallFinishedWithSuccess(false, responseObj:[error?.localizedDescription:"error"])
            }
        })
        task.resume()
    }
}
