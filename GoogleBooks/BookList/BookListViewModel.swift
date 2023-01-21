//
//  BookListViewModel.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/13.
//

import Foundation

import RxSwift
import RxRelay

protocol BookListViewModelType {
  var input: BookListViewModelInput { get }
  var output: BookListViewModelOutput { get }
}

protocol BookListViewModelInput {
  func initializeBookList()
  func getBookList(searchText: String)
}

protocol BookListViewModelOutput {
  var bookList: BehaviorRelay<BookListModel?> { get }
}

final class BookListViewModel: BookListViewModelInput, BookListViewModelOutput {
  
  
  // MARK: - Properties
  
  var bookList = BehaviorRelay<BookListModel?>(value: nil)

  
  // MARK: Method
  
  func getBookList(searchText: String) {
    if let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(searchText)") {
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        if let data = data {
          guard let bookListModel = try? JSONDecoder().decode(BookListModel.self, from: data) else { return }
          self?.bookList.accept(bookListModel)
        } else if let error = error {
          print("Book List Error : \(error)")
        }
      }.resume()
    }
  }
  
  func initializeBookList() {
    bookList.accept(BookListModel(items: []))
  }
}

extension BookListViewModel: BookListViewModelType {
  var input: BookListViewModelInput { self }
  var output: BookListViewModelOutput { self }
}
