//
//  APIProvider.swift
//  alamofirePractice
//
//  Created by ta_fukase on 2019/08/06.
//  Copyright © 2019 ta_fukase. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class APIProvider: NSObject {
    
    static let qiitaAPI_URL = "https://qiita.com/api/v2/items"
    
    @objc static func setLatestQiitaTitle(on label: UILabel) {
        
        var articleInformations: [(title: String, url: String)] = []
        //QiitaのAPIにアクセス。最新の20記事を取得し、最も新しい記事のタイトルを表示する
        Alamofire.request(qiitaAPI_URL).responseJSON{ response in
            
            guard let object = response.result.value else { return }
            let json = JSON(object)
            json.forEach { (_, json) in
                
                // 記事タイトルを配列に追加
                let title = json["title"].string ?? "XXX"
                let url = json["url"].string ?? "XXX"
                
                articleInformations.append((title: title, url: url))
            }
            
            // 最新の記事を画面に表示する
            label.text = articleInformations.first?.title
                        
            /*↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓デバッグ関連↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓*/
            
            // 取得した記事タイトルを出力
            for info in articleInformations {
                print(info)
            }
            
            // 取得した記事の数を出力
            print(articleInformations.count)
            
            /*↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑+デバッグ関連↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑*/
        }
    }
}
