//
//  AppInfoViewController.swift
//  Rec Basketball
//
//  Created by Arya Tschand on 7/18/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var LinkBtn: UIButton!
    
    @IBAction func LinkBtnPressed(_ sender: UIButton) {
        if let url = URL(string: "https://aryatschand.wixsite.com/lineupz/help") {
            UIApplication.shared.open(url)
        }
    }
    

}
