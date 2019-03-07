//
//  ViewController.swift
//  alamofirePractice
//
//  Created by ta_fukase on 2019/03/06.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var url = NSURL()
    
    var pageTitles: [String] = []
    var pageURLs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self
        webView.isHidden = true
        
        let qiitaAPI_Url = "https://qiita.com/api/v2/items"
        
        Alamofire.request(qiitaAPI_Url).responseJSON{ response in
            let json = JSON(response.result.value ?? 0)
            json.forEach{(arg) in
                
                defer {
                    
                    if let titleToShow = self.pageTitles.first {
                        self.label.text = titleToShow
                    } else {
                        print("Failed to get page titles...")
                    }
                }
                
                let (_, data) = arg
                
                let v = data["title"].string
                let w = data["url"].string
                
                if let unwrappedV = v {
                
                    self.pageTitles.append(unwrappedV)
                }
                
                if let unwrappedW = w {
                    
                    self.pageURLs.append(unwrappedW)
                }
            }
        }
    }
    
    @IBAction func goToPage(_ sender: Any) {
        
        confirmBeforeShowingWebView()
    }
    
    @IBAction func backToFirstPage() {
        
        webView.isHidden = true
        
        goButton.isHidden = false
        backButton.isHidden = true
    }
    
    func confirmBeforeShowingWebView() {
        
        //アラートの本体（UIAlertController）のインスタンスを生成
        let alert = UIAlertController(title: "【重要】", message: "Websiteにアクセスします。\nよろしいですか？", preferredStyle: .alert)
        
        //アラートに付属させる選択肢（UIAlertAction）のインスタンスを生成
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.go()
        })
        
        //アラートに付属させる選択肢（UIAlertAction）のインスタンスを生成
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print(action)
            print("Cancel")
        })
        
        //アラート本体に対して、付属させる選択肢を加える
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        //アラートを表示する
        present(alert, animated: true, completion: nil)
    }
    
    private func go() {
    
        if let urlToUse = pageURLs.first {
        self.url = NSURL(string: urlToUse)!
        } else {
        print("Failed to get page URLs...")
        }
        
        webView.isHidden = false
        
        let request = NSURLRequest(url: url as URL)
        webView.loadRequest(request as URLRequest)
        
        goButton.isHidden = true
        backButton.isHidden = false
    }
}
