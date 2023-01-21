//
//  BookDetailViewController.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/13.
//

import UIKit

import RxSwift
import RxCocoa

final class BookDetailViewController: UIViewController {
  
  
  // MARK: Properties
  
  private let disposeBag = DisposeBag()
  private let viewModel: BookDetailViewModelType
  
  
  // MARK: UI
  
  private let bookImageView: UIImageView = {
    let imageView: UIImageView = UIImageView()
    return imageView
  }()
  private let bookTitleLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .black
    label.numberOfLines = 5
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  private let bookAuthorLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .systemGray2
    label.font = .systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  private let ebookAndPageCountLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .systemGray2
    label.font = .systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  private let firstSplitView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = .systemGray2
    return view
  }()
  private let sampleButton: UIButton = {
    let button: UIButton = UIButton()
    button.setTitle("샘플 읽기", for: .normal)
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.backgroundColor = .white
    button.layer.borderColor = UIColor.systemGray2.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 5
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    return button
  }()
  private let wishListButton: UIButton = {
    let button: UIButton = UIButton()
    button.setTitle("위시리스트에 추가", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 5
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    return button
  }()
  private let cautionImageView: UIImageView = {
    let imageView: UIImageView = UIImageView()
    imageView.image = UIImage(systemName: "exclamationmark.circle")
    imageView.tintColor = .systemGray2
    return imageView
  }()
  private let cautionLabel: UILabel = {
    let label: UILabel = UILabel()
    label.numberOfLines = 0
    label.textColor = .systemGray2
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.text = "Google Play 웹사이트에서 구매한 책을 이 앱에서 읽을 수 있습니다."
    return label
  }()
  private let secondSplitView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = .systemGray2
    return view
  }()
  private let descriptionTitleLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .black
    label.text = "eBook 정보"
    label.font = .systemFont(ofSize: 17, weight: .semibold)
    return label
  }()
  private let descriptionLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .systemGray2
    label.numberOfLines = 4
    label.font = .systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  private let dateTitleLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .black
    label.text = "게시일"
    label.font = .systemFont(ofSize: 17, weight: .semibold)
    return label
  }()
  private let dateAndPublisherLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .systemGray2
    label.font = .systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  
  
  // MARK: Initialize
  
  init(viewModel: BookDetailViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available (*, unavailable)
  required init?(coder: NSCoder) { fatalError() }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setNavigation()
    bindView()
  }
}


// MARK: - Draw View

extension BookDetailViewController {
  private func setNavigation() {
    navigationController?.navigationBar.backgroundColor = .white
    
    let backButton: UIBarButtonItem = {
      let button: UIBarButtonItem = UIBarButtonItem()
      button.image = UIImage(named: "buttton_back")
      button.tintColor = .black
      return button
    }()
    navigationItem.leftBarButtonItem = backButton
    
    backButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    let shareButton: UIBarButtonItem = {
      let button: UIBarButtonItem = UIBarButtonItem()
      button.image = UIImage(systemName: "square.and.arrow.up")
      button.tintColor = .black
      return button
    }()
    navigationItem.rightBarButtonItem = shareButton
    
    shareButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        guard let link = self.viewModel.output.bookDetail.value?.volumeInfo?.infoLink else { return }
        let activityVC = UIActivityViewController(
          activityItems: [link],
          applicationActivities: nil
        )
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
  }
  
  private func drawView() {
    view.addSubview(bookImageView)
    view.addSubview(bookTitleLabel)
    view.addSubview(bookAuthorLabel)
    view.addSubview(ebookAndPageCountLabel)
    
    view.addSubview(firstSplitView)
    
    view.addSubview(sampleButton)
    view.addSubview(wishListButton)
    view.addSubview(cautionImageView)
    view.addSubview(cautionLabel)
    
    view.addSubview(secondSplitView)
    
    view.addSubview(descriptionTitleLabel)
    view.addSubview(descriptionLabel)
    
    view.addSubview(dateTitleLabel)
    view.addSubview(dateAndPublisherLabel)
    
    setLayout()
  }
  
  private func setLayout() {
    bookImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bookImageView.widthAnchor.constraint(equalToConstant: 128),
      bookImageView.heightAnchor.constraint(equalToConstant: 200),
      bookImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      bookImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)
    ])
    bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bookTitleLabel.topAnchor.constraint(equalTo: bookImageView.topAnchor),
      bookTitleLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
      bookTitleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
    ])
    bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 5),
      bookAuthorLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
      bookAuthorLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
    ])
    ebookAndPageCountLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ebookAndPageCountLabel.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor, constant: 5),
      ebookAndPageCountLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
      ebookAndPageCountLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
    ])
    
    firstSplitView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      firstSplitView.heightAnchor.constraint(equalToConstant: 0.5),
      firstSplitView.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 10),
      firstSplitView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      firstSplitView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ])
    
    sampleButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sampleButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
      sampleButton.heightAnchor.constraint(equalToConstant: 30),
      sampleButton.topAnchor.constraint(equalTo: firstSplitView.bottomAnchor, constant: 10),
      sampleButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)
    ])
    wishListButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      wishListButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
      wishListButton.heightAnchor.constraint(equalToConstant: 30),
      wishListButton.topAnchor.constraint(equalTo: firstSplitView.bottomAnchor, constant: 10),
      wishListButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
    ])
    cautionImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cautionImageView.widthAnchor.constraint(equalToConstant: 16),
      cautionImageView.heightAnchor.constraint(equalToConstant: 16),
      cautionImageView.topAnchor.constraint(equalTo: sampleButton.bottomAnchor, constant: 10),
      cautionImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)
    ])
    cautionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cautionLabel.centerYAnchor.constraint(equalTo: cautionImageView.centerYAnchor),
      cautionLabel.leftAnchor.constraint(equalTo: cautionImageView.rightAnchor, constant: 5),
      cautionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
    ])
    
    secondSplitView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      secondSplitView.heightAnchor.constraint(equalToConstant: 0.5),
      secondSplitView.topAnchor.constraint(equalTo: cautionLabel.bottomAnchor, constant: 10),
      secondSplitView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      secondSplitView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
    ])
    
    descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionTitleLabel.topAnchor.constraint(equalTo: secondSplitView.bottomAnchor, constant: 20),
      descriptionTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)
    ])
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
      descriptionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
      descriptionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
    ])
    
    dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateTitleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
      dateTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)
    ])
    dateAndPublisherLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateAndPublisherLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 10),
      dateAndPublisherLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16)
    ])
  }
}


// MARK: - Bind View

extension BookDetailViewController {
  private func bindView() {
    viewModel.input.getBookDetail()
    viewModel.output.bookDetail.filter { $0 != nil }
      .observe(on: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { owner, element in
        guard let bookDetail = element else { return }
        if let url = URL(string: bookDetail.volumeInfo?.imageLinks?.thumbnail ?? "") {
          owner.bookImageView.load(url: url)
        }
        
        owner.bookTitleLabel.text = bookDetail.volumeInfo?.title ?? ""
        owner.bookAuthorLabel.text = owner.setBookAuthorLabel(authors: bookDetail.volumeInfo?.authors ?? [])
        owner.ebookAndPageCountLabel.text = "eBook • \(bookDetail.volumeInfo?.pageCount ?? 0)페이지"
        owner.descriptionLabel.attributedText = bookDetail.volumeInfo?.description?.htmlToAttributedString()
        
        if let date = bookDetail.volumeInfo?.publishedDate, let publisher = bookDetail.volumeInfo?.publisher {
          let splitDate = date.components(separatedBy: "-")
          var convertedDate: String = ""
          for index in 0 ..< splitDate.count {
            if index == 0 {
              convertedDate += "\(splitDate[index])년"
            } else if index == 1 {
              convertedDate += " \(splitDate[index])월"
            } else if index == 2 {
              convertedDate += " \(splitDate[index])일"
            }
          }
          owner.dateAndPublisherLabel.text = "\(convertedDate) • \(publisher)"
        } else {
          owner.dateAndPublisherLabel.text = "-"
        }
        
        owner.drawView()
      })
      .disposed(by: disposeBag)
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
