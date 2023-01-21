//
//  BookDetailModel.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/13.
//

import Foundation

// MARK: - BookDetailModel

struct BookDetailModel: Codable {
  let volumeInfo: BookDetailVolumeInformation?
  let saleInfo: BookDetailSaleInformation?
}


// MARK: - BookDetailSaleInformation

struct BookDetailSaleInformation: Codable {
  let isEbook: Bool?
}


// MARK: - BookDetailVolumeInformation

struct BookDetailVolumeInformation: Codable {
  let title: String?
  let pageCount: Int?
  let authors: [String]?
  let publisher: String?
  let publishedDate: String?
  let description: String?
  let imageLinks: BookDetailImageLink?
  let infoLink: String?
}


// MARK: - BookDetailImageLink

struct BookDetailImageLink: Codable {
  let thumbnail: String?
}
