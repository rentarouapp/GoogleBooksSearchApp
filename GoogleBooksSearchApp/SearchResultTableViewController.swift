//
//  SearchResultTableViewController.swift
//  GoogleBooksSearchApp
//
//  Created by Rentaro on 2020/03/11.
//  Copyright © 2020 Rentaro. All rights reserved.
//

import UIKit

class SearchResultTableViewController: UITableViewController {
    
    //前画面から受け取った文字列を格納する変数
    var inputText: String = ""
    //TableViewに表示するデータ（配列）を格納
    var bookDataArray = [VolumeInfo]()
    //画像データをキャッシュするための変数を定義
    var imageCache = NSCache<AnyObject, UIImage>()
    
    //「Google Books APIs」のURLを格納
    let apiUrl = "https://www.googleapis.com/books/v1/volumes?q="
    //12件を上限とする指定を行うURLを格納
    let maxResult = "&maxResults=12"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //受け取った文字列のエンコード処理
        guard let encodeValue = inputText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            print("エンコード失敗")
            return
        }
        
        //URLを生成するための処理
        let requestUrl = apiUrl + encodeValue + maxResult
        
        // 保持している商品をいったん削除
         bookDataArray.removeAll()
    
         // APIをリクエストする
         request(requestUrl: requestUrl)
    }

    // リクエストを行う処理の定義
    func request(requestUrl: String) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // URL生成失敗
            return
        }
        // リクエスト生成
        let request = URLRequest(url: url)
        // 商品検索APIをコールして商品検索を行う
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data:Data?,
            response:URLResponse?, error:Error?) in
            // 通信完了後の処理
            // エラーチェック
            guard error == nil else {
                // エラー表示
                let alert = UIAlertController(title: "エラー",
                                              message: error?.localizedDescription,
                                              preferredStyle: UIAlertController.Style.alert)
                // UIに関する処理をメインスレッドで行う
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            // JSONで返却されたデータをパースして格納する
            guard let data = data else {
                // データなし
                return
            }
            do {
                // パース実施
                let resultSet =
                    try JSONDecoder().decode(ResultJson.self,
                                             from: data)
                
                // オブジェクトの存在を確認して、商品のリストに追加
                for count in 0...11 {
                    if resultSet.items[count].volumeInfo != nil {
                    self.bookDataArray.append(resultSet.items[count].volumeInfo!)
                    } else {
                        break
                    }
                }
            
            } catch let error {
                print("## error: \(error)")
            }
            // テーブルの描画処理を実施
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 通信開始
        task.resume()
    }
    // MARK: - Table view data source
    
    //テーブルビューのセクション数の設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //テーブルビューのセルの数の設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookDataArray.count
    }
    
    //セルの詳細を設定して返すための処理
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "booksCell") as? BooksTableViewCell else {
            return UITableViewCell()
        }
        let bookData = bookDataArray[indexPath.row]
    
        //本のタイトルを設定
        cell.bookTitleLabel.text = bookData.title
        //本の作者を設定
        if bookData.authors != nil {
            //作者がいる場合の処理
            let hitAuthors = bookData.authors?.joined(separator: ",")
            cell.bookAuthorsLabel.text = hitAuthors
        } else {
            //作者がいなかった場合
            cell.bookAuthorsLabel.text = "作者なし"
        }
        
        //画像を設定する処理
        guard let bookImageUrl = bookData.imageLinks?.smallThumbnail else {
            //画像がない商品
            return cell
        }
        
        //キャッシュの画像を取り出す
        if let cacheImage = imageCache.object(forKey: bookImageUrl as AnyObject) {
            //キャッシュ画像を設定する
            cell.bookImage.image = cacheImage
            return cell
        }
        
        //キャッシュの画像がないときダウンロードをする
        guard let url = URL(string: bookImageUrl) else {
            //urlが生成できなかったときの処理
            return cell
        }
        
        //画像のリクエストに関する処理
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {(data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else {
                //エラーあり
                return
            }
            
            guard let data = data else {
                //データがない
                return
            }
            
            guard let image = UIImage(data: data) else {
                //imageが生成できなかった
                return
            }
            
            //ダウンロードした画像をキャッシュに登録する処理
            self.imageCache.setObject(image, forKey: bookImageUrl as AnyObject)
            //画像に関する処理をメインスレッドで設定
            DispatchQueue.main.async {
                cell.bookImage.image = image
            }
        }
        
        //通信開始
        task.resume()
        //完成したセルを返す
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
