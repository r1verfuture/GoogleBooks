//
//  BookListModel.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/13.
//

import Foundation


// MARK: - BookListModel

struct BookListModel: Codable {
  let items: [BookListItem]?
}


// MARK: - BookListItem

struct BookListItem: Codable {
  let id: String?
  let volumeInfo: BookListVolumeInformation?
  let saleInfo: BookListSaleInformation?
}


// MARK: - BookListSaleInformation

struct BookListSaleInformation: Codable {
  let isEbook: Bool?
}


// MARK: - BookListVolumeInformation

struct BookListVolumeInformation: Codable {
  let title: String?
  let authors: [String]?
  let imageLinks: BookListThumbnailImageLink?
}


// MARK: - ImageLinks

struct BookListThumbnailImageLink: Codable {
  let smallThumbnail: String?
}
