//
//  SwiftExtension.swift
//  GoogleBooks
//
//  Created by 강미래 on 2022/11/13.
//

import UIKit

extension UIImageView {
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self?.image = image
        }
      }
    }
  }
}

extension String {
  func htmlToAttributedString() -> NSAttributedString? {
    guard let data = self.data(using: .utf8) else {
      return NSAttributedString()
    }
    
    do {
      return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
      return NSAttributedString()
    }
  }
}
