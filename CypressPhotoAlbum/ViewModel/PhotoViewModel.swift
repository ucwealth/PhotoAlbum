
import Foundation
import UIKit
import RealmSwift

class PhotoViewModel {
    let webService = WebService.shared
    let realm = try? Realm()
    let store = StorageManager.shared
    
    var apiPhotoList: [PhotoAlbum]?
    var apiAlbumList: [AlbumName]?
    var fetchDataCompletion: (() -> Void)?
    
    var dbPhotoList = [ [String] ]()
    var dbAlbumList = [String]()
    
    var photoList = [ [String] ]()
    var albumList = [String]()
    
    // Get Photos
    public func loadPhotos(completion: @escaping ([PhotoAlbum]) -> ()) {
        webService.load(from: Constants.photoUrl, completion: completion)
    }
    
    // Get Albums
    public func loadAlbums(completion: @escaping ([AlbumName]) -> ()) {
        webService.load(from: Constants.albumUrl, completion: completion)
    }
    
    func makePhotoRequests(table: UITableView) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadPhotos {  [weak self] photos in
            let first400 = Array(photos[...349])
            // only save first 10 photos of each album
            self?.apiPhotoList = first400
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        loadAlbums {  [weak self] albums in
            self?.apiAlbumList = Array(albums[...10])
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.populateUsableList()
            DispatchQueue.main.async { [weak self] in
                table.reloadData()
                self?.saveToDb()
            }
        }
        
    }
    
    func populateUsableList() {
        apiAlbumList?.forEach({ album in
            albumList.append(album.title)
            var tempList = [String]()
            
            apiPhotoList?.forEach({ photo in
                if photo.albumId == album.id {
                    tempList.append(photo.url)
                }})
            photoList.append(tempList)
            tempList = []
        })
        fetchDataCompletion?()
    }
    
    func offlineCheck(table: UITableView) {
        let albums = store.fetchAll(DbAlbumName())
        let photos = store.fetchAll(DbPhotoAlbum())
        
        if albums.count > 1 && photos.count > 1 {
            fetchFromDb()
        } else {
            makePhotoRequests(table: table)
        }
        
    }

    func fetchFromDb() {
        let albums = store.fetchAll(DbAlbumName())
        let photos = store.fetchAll(DbPhotoAlbum())
        
        for album in albums {
            albumList.append(album.title)
            var tempList = [String]()
            photos.forEach({
                if $0.albumId == album.id {
                    // photo belongs to this album
                    tempList.append($0.url)
                }
            })
            photoList.append(tempList)
            tempList = []
        }
        fetchDataCompletion?()
    }
    
    func saveToDb() {
        apiPhotoList?.forEach({
            let temp = DbPhotoAlbum(id: $0.id, albumId: $0.albumId, url: $0.url)
            store.save(temp)
        })
        apiAlbumList?.forEach({
            let temp = DbAlbumName(id: $0.id, title: $0.title)
            store.save(temp)
        })
    }
    
}
