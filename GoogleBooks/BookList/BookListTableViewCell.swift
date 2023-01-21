//
//  BookListTableViewCell.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/13.
//

import UIKit

final class BookListTableViewCell: UITableViewCell {
  
  
  // MARK: UI
  
  private let bookImageView: UIImageView = {
    let imageView: UIImageView = UIImageView()
    return imageView
  }()
  private let bookTitleLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    return label
  }()
  private let bookAuthorLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .systemGray2
    label.font = .systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  private let ebookLabel: UILabel = {
    let label: UILabel = UILabel()
    label.text = "eBook"
    label.textColor = .systemGray2
    label.font = .systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    contentView.subviews.forEach { $0.removeFromSuperview() }
  }
}


// MARK: - Draw View

extension BookListTableViewCell {
  private func drawView() {
    contentView.addSubview(bookImageView)
    contentView.addSubview(bookTitleLabel)
    contentView.addSubview(bookAuthorLabel)
    contentView.addSubview(ebookLabel)
    
    setLayout()
  }
  
  private func setLayout() {
    bookImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bookImageView.widthAnchor.constraint(equalToConstant: 54),
      bookImageView.heightAnchor.constraint(equalToConstant: 80),
      bookImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      bookImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
    ])
    
    bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.topAnchor),
      bookTitleLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
      bookTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
    ])
    
    bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 5),
      bookAuthorLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
      bookAuthorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
    ])
    
    ebookLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ebookLabel.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor, constant: 5),
      ebookLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
      ebookLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
    ])
  }
}


// MARK: - Bind View

extension BookListTableViewCell {
  func bindView(image: String, title: String, authors: [String], isEbook: Bool) {
    if let url = URL(string: image) {
      bookImageView.load(url: url)
    }
    bookTitleLabel.text = title
    bookAuthorLabel.text = setBookAuthorLabel(authors: authors)
    ebookLabel.isHidden = !isEbook
    
    drawView()
  }
  
  private func setBookAuthorLabel(authors: [String]) -> String {
    var authorString: String = ""
    for index in 0 ..< authors.count {
      if index == 0 {
        authorString = authors[index]
      } else {
        authorString += ", \(authors[index])"
      }
    }
    return authorString
  }
}
