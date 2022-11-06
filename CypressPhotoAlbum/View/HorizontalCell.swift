//
//  HorizontalCell.swift
//  CypressPhotoAlbum
//
//  Created by Decagon on 02/11/2022.
//

import UIKit
import Kingfisher
class HorizontalCell: UICollectionViewCell {
    static let identifier = "HorizontalCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    lazy var imageBox: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: 0, y: 10, width: 100, height: 100)
        image.backgroundColor = .orange
        image.layer.cornerRadius = 10
        return image
    }()
    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        imageBox.kf.setImage(with: url)
    }
    
}
