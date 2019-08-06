//
//  ViewController.swift
//  alamofirePractice
//
//  Created by ta_fukase on 2019/03/06.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var qiitaTitleLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIProvider.setLatestQiitaTitle(on: qiitaTitleLabel)
    }
    
    @IBAction func onButtonReload(_ sender: Any) {
        
        APIProvider.setLatestQiitaTitle(on: qiitaTitleLabel)
    }
}
