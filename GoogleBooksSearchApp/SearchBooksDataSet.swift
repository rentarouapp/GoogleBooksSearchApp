//
//  SearchBooksDataSet.swift
//  GoogleBooksSearchApp
//
//  Created by Rentaro on 2020/03/11.
//  Copyright © 2020 Rentaro. All rights reserved.
//

import Foundation

// 検索結果全体を格納するクラス
class ResultJson: Codable {
    var items: [Item]
}

// 検索結果を格納するクラス
class Item: Codable {
    var volumeInfo: VolumeInfo?
    }

//商品情報を格納するクラス
class VolumeInfo: Codable {
    var title: String?
    //著者
    var authors: [String]?
    var imageLinks: ImageLink?
}

//JSONのImageLink内の情報を格納するクラス
class ImageLink: Codable {
    var smallThumbnail: String?
}
