//
//  DetailVC.swift
//  Desidime
//
//  Created by SmartConnect Technologies on 26/10/18.
//  Copyright © 2018 Vinod Tiwari. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailNewsView: UITextView!
    @IBOutlet weak var detailNewTitle: UILabel!
    
    var detailContentText: String?
    var detailContentTitleText: String?
    var detailImageURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if detailContentText != nil {
            
            detailNewsView.text = detailContentText
            detailNewTitle.text = detailContentTitleText
            detailImage.sd_setImage(with: detailImageURL as URL?, completed: nil)
        }
    }
}
