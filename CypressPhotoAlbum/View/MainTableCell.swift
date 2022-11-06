
import UIKit

class MainTableCell: UITableViewCell {
    static let identifier = Constants.AlbumRowID
    let viewModel = PhotoViewModel()

    var photoUrlList = [String]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [titleLabel, collectionView].forEach({ contentView.addSubview($0) })
        setupSubviews()
        completeFetch()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCollectionView()

    }

    func resetCollectionView() {
        guard !photoUrlList.isEmpty else { return }
        photoUrlList = []
        collectionView.reloadData()
        
    }
    
    func configureListView(with title: String, photoUrlArr: [String]) {
        titleLabel.text = title
        photoUrlList = photoUrlArr
        collectionView.reloadData()
    }
    
    func completeFetch() {
        viewModel.fetchDataCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (contentView.bounds.width/3) - 10, height: 90)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
       label.text = "Title"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()

}

