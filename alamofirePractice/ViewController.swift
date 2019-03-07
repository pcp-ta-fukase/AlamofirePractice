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

    @IBOutlet weak var qiitaTitleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var pageURL = NSURL()
    
    var pageTitles: [String] = []
    var pageURLs: [String] = []
    let qiitaAPI_Url = "https://qiita.com/api/v2/items"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self
        webView.isHidden = true
        
        getLatestQiitaInfo()
    }
    
    @IBAction func onButtonGo(_ sender: Any) {
        
        confirmBeforeShowingWebView()
    }
    
    @IBAction func onButtonReload(_ sender: Any) {
        
        getLatestQiitaInfo()
    }
    
    @IBAction func onButtonBack() {
        
        webView.isHidden = true
        
        goButton.isHidden = false
        reloadButton.isHidden = false
        backButton.isHidden = true
    }
    
    private func confirmBeforeShowingWebView() {
        
        let alertTitle = "【重要】"
        let alertMessage = "Websiteにアクセスします。\nよろしいですか？"
        let titleForDefaultAction = "OK"
        let titleForCancelAction = "キャンセル"
        
        //アラートの本体（UIAlertController）のインスタンスを生成
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        //アラートに付属させる選択肢（UIAlertAction）のインスタンスを生成
        let defaultAction = UIAlertAction(title: titleForDefaultAction, style: .default, handler: {
            // OKボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.toWebPage()
        })
        
        //アラートに付属させる選択肢（UIAlertAction）のインスタンスを生成
        let cancelAction: UIAlertAction = UIAlertAction(title: titleForCancelAction, style: .cancel, handler:{
            // キャンセル・ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print(action)
        })
        
        //アラート本体に対して、付属させる選択肢を加える
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        //アラートを表示する
        present(alert, animated: true, completion: nil)
    }
    
    private func toWebPage() {
    
        //APIで取得済みのURLのうち最新の記事にアクセスし、Webビューに表示する
        if let urlToUse = pageURLs.first {
            self.pageURL = NSURL(string: urlToUse)!
        } else {
            print("Failed to get page URLs...")
        }
        
        let request = NSURLRequest(url: pageURL as URL)
        webView.loadRequest(request as URLRequest)
        
        webView.isHidden = false

        goButton.isHidden = true
        reloadButton.isHidden = true
        backButton.isHidden = false
    }
    
    private func getLatestQiitaInfo() {
        
        //一覧情報を更新するため、配列の中身を空にする
        pageTitles = []
        pageURLs = []
        
        //QiitaのAPIにアクセス。最新の20記事を取得し、最も新しい記事のタイトルを表示する
        Alamofire.request(qiitaAPI_Url).responseJSON{ response in
            let json = JSON(response.result.value ?? 0)
            json.forEach{(arg) in
                
                defer {
                    
                    if let titleToShow = self.pageTitles.first {
                        self.qiitaTitleLabel.text = titleToShow
                    } else {
                        print("Failed to get page titles...")
                    }
                    
                    print(self.pageTitles.count)
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
}
