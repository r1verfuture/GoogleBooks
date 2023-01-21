//
//  BookDetailViewModel.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/13.
//

import Foundation

import RxSwift
import RxRelay

protocol BookDetailViewModelType {
  var input: BookDetailViewModelInput { get }
  var output: BookDetailViewModelOutput { get }
}

protocol BookDetailViewModelInput {
  func getBookDetail()
}

protocol BookDetailViewModelOutput {
  var bookDetail: BehaviorRelay<BookDetailModel?> { get }
}

final class BookDetailViewModel: BookDetailViewModelInput, BookDetailViewModelOutput {
  
  
  // MARK: - Properties
  
  private let id: String
  var bookDetail = BehaviorRelay<BookDetailModel?>(value: nil)
  
  
  // MARK: Initialize
  
  init(id: String) {
    self.id = id
  }

  
  // MARK: Method
  
  func getBookDetail() {
    if let url = URL(string: "https://www.googleapis.com/books/v1/volumes/\(id)") {
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        if let data = data {
          guard let bookListModel = try? JSONDecoder().decode(BookDetailModel.self, from: data) else { return }
          self?.bookDetail.accept(bookListModel)
        } else if let error = error {
          print("Book Detail Error : \(error)")
        }
      }.resume()
    }
  }
}

extension BookDetailViewModel: BookDetailViewModelType {
  var input: BookDetailViewModelInput { self }
  var output: BookDetailViewModelOutput { self }
}
