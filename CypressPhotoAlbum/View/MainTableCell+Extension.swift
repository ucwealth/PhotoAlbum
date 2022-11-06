import UIKit

extension MainTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoUrlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: photoUrlList[indexPath.row])
        return cell
    }
    
}

extension MainTableCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectionStyle = .none
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottom: CGFloat = scrollView.contentSize.width - scrollView.frame.size.width
        let scrollPosition = scrollView.contentOffset.x

        if scrollPosition > (bottom / 2) {
            let newPhotos = photoUrlList
            photoUrlList.append(contentsOf: newPhotos)
            collectionView.reloadData()
        }

    }
    
}

extension MainTableCell {
    func setupSubviews() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
