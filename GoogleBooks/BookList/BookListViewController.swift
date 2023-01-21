//
//  BookListViewController.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/12.
//

import UIKit

import RxSwift
import RxCocoa

final class BookListViewController: UIViewController {
  
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  private let viewModel: BookListViewModelType
  
  
  // MARK: UI
  
  private let searchBar: UISearchBar = {
    let searchBar: UISearchBar = UISearchBar()
    searchBar.placeholder = "Play 북에서 검색"
    return searchBar
  }()
  private let tableView: UITableView = {
    let tableView: UITableView = UITableView()
    tableView.rowHeight = 90
    tableView.register(BookListTableViewCell.self, forCellReuseIdentifier: "BookListTableViewCell")
    return tableView
  }()
  
  
  // MARK: Initialize
  
  init(viewModel: BookListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available (*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    hideKeyboardWhenTappedAnywhere()
    setNavigation()
    drawView()
    bindView()
  }
}


// MARK: - Draw View

extension BookListViewController {
  private func setNavigation() {
    navigationController?.navigationBar.backgroundColor = .white
    navigationItem.hidesBackButton = true

    let titleLabel: UILabel = {
      let label: UILabel = UILabel()
      label.text = "Google Play 검색결과"
      label.textColor = .black
      label.font = .systemFont(ofSize: 22, weight: .bold)
      return label
    }()
    let leftItem = UIBarButtonItem(customView: titleLabel)
    navigationItem.leftBarButtonItem = leftItem
  }
  
  private func drawView() {
    view.addSubview(searchBar)
    view.addSubview(tableView)
    
    setLayout()
  }
  
  private func setLayout() {
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchBar.heightAnchor.constraint(equalToConstant: 36),
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      searchBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
    ])
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}


// MARK: - Bind View

extension BookListViewController {
  private func bindView() {
    viewModel.output.bookList.filter { $0 != nil }.map { $0!.items! }
      .bind(to: tableView.rx.items(
        cellIdentifier: "BookListTableViewCell",
        cellType: BookListTableViewCell.self
      )) { _, element, cell in
        cell.bindView(
          image: element.volumeInfo?.imageLinks?.smallThumbnail ?? "",
          title: element.volumeInfo?.title ?? "",
          authors: element.volumeInfo?.authors ?? [],
          isEbook: element.saleInfo?.isEbook ?? false
        )
      }
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(BookListItem.self)
      .withUnretained(self)
      .subscribe(onNext: { owner, element in
        let bookDetailVC = BookDetailViewController(viewModel: BookDetailViewModel(id: element.id ?? ""))
        bookDetailVC.hidesBottomBarWhenPushed = true
        owner.navigationController?.pushViewController(bookDetailVC, animated: true)
      })
      .disposed(by: disposeBag)
    
    searchBar.rx.text
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.tableView.isHidden = true
        owner.viewModel.input.initializeBookList()
      })
      .disposed(by: disposeBag)
    searchBar.rx.searchButtonClicked
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.view.endEditing(true)
        guard let text = owner.searchBar.text else { return }
        if text != "" {
          owner.tableView.isHidden = false
          owner.viewModel.input.getBookList(searchText: text)
        } else {
          owner.tableView.isHidden = true
          owner.viewModel.input.initializeBookList()
        }
      })
      .disposed(by: disposeBag)
  }
}


// MARK: - Keyboard

extension BookListViewController {
  private func hideKeyboardWhenTappedAnywhere() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc
  private func dismissKeyboard() {
    view.endEditing(true)
  }
}
