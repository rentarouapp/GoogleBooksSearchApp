//
//  ViewController.swift
//  GoogleBooksSearchApp
//
//  Created by Rentaro on 2020/03/11.
//  Copyright © 2020 Rentaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchGoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンに角丸を付ける処理
        self.searchGoButton.layer.cornerRadius = 8
        
        //テキストフィールドデリゲートを自分自身に設定
        searchTextField.delegate = self
        
        // ツールバーを生成する
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        // スタイルをデフォルトに設定
        toolBar.barStyle = UIBarStyle.default
        // 画面の幅にサイズを合わせる
        toolBar.sizeToFit()
        // 「done」ボタンを配置するためのスペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 「done」ボタンを生成
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        // スペーサーと、「done」ボタンを右側に配置
        toolBar.items = [spacer, doneButton]
        // searchTextFiledのキーボードにツールバーを設定
        searchTextField.inputAccessoryView = toolBar
        
    }
    
    //リターンキーを押したときにキーボードを閉じるための処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    //「done」ボタンをタップしたときの処理
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    //次の画面に遷移する処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let nextController = segue.destination as? SearchResultTableViewController {
                //テキストが入力されていたら、次の画面にデータを渡す
                if self.searchTextField != nil {
                    nextController.inputText = self.searchTextField.text!
                }
                    
            }

        }

    }
