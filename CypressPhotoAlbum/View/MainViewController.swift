
import UIKit

class MainViewController: UIViewController {
    let viewModel = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        viewModel.offlineCheck(table: tableView)
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: view.bounds)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.separatorColor = .black
        view.separatorStyle = .singleLine
        view.register(MainTableCell.self, forCellReuseIdentifier: MainTableCell.identifier)
        return view
    }()
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albumList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableCell.identifier, for: indexPath) as? MainTableCell else {
            return UITableViewCell()
        }
        let title = viewModel.albumList[indexPath.row].capitalized
        let urls = viewModel.photoList[indexPath.row]
        cell.configureListView(with: title, photoUrlArr: urls)
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.allowsSelection = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Enable endless scrolling
        let cellBuffer: CGFloat = 2
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = cellBuffer * 160
        let scrollPosition = scrollView.contentOffset.y

        // Reached the bottom of the list
        if scrollPosition > bottom - buffer {
            let newAlbum = viewModel.albumList
            viewModel.albumList.append(contentsOf: newAlbum)
            
            let newPhotos = viewModel.photoList
            viewModel.photoList.append(contentsOf: newPhotos)
            tableView.reloadData()

        }
    }
    
}
