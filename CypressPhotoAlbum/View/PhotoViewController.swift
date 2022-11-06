
import UIKit

class PhotoViewController: UIViewController {
    let viewModel = PhotoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        viewModel.setPhotoRequests(table: tableView)
        viewModel.fetchFromDb()
    }

    lazy var tableView: UITableView = {
        let view = UITableView(frame: view.bounds)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.register(AlbumRow.self, forCellReuseIdentifier: AlbumRow.identifier)
        return view
    }()

}

extension PhotoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.albumArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumRow.identifier, for: indexPath) as? AlbumRow else {
            return UITableViewCell()
        }
        let title = viewModel.albumArr[indexPath.row].capitalized
        let urls = viewModel.photoArr[indexPath.row]
        cell.configureListView(with: title, photoUrlArr: urls)

        return cell
    }
    
}

extension PhotoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellBuffer: CGFloat = 2

        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = cellBuffer * 160

        let scrollPosition = scrollView.contentOffset.y

        // Reached the bottom of the list
         if scrollPosition > bottom - buffer {
             // Add more albums to the bottom
             guard let newAlbum = viewModel.albumList else { return }
             viewModel.albumList?.append(contentsOf: newAlbum)
//             viewModel.saveToDb()
             // Update the tableView
             tableView.reloadData()

         }
    }
  
}
