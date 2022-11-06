
import Foundation
import UIKit
import RealmSwift

class PhotoViewModel {
    let webService = WebService.shared
    let realm = try? Realm()
    let store = StorageManager.shared
    
    var photoList: [PhotoAlbum]?
    var photoListSlice: [PhotoAlbum] = []

    var albumList: [AlbumName]?
    var fetchFromDBCompletion: (() -> Void)?
    var photoArr = [ [String] ]()
    var albumArr = [String]()

    // Get Photos
    public func loadPhotos(completion: @escaping ([PhotoAlbum]) -> ()) {
        webService.load(from: Constants.photoUrl, completion: completion)
    }
 
    // Get Albums 
    public func loadAlbums(completion: @escaping ([AlbumName]) -> ()) {
        webService.load(from: Constants.albumUrl, completion: completion)
    }
    
    func setPhotoRequests(table: UITableView) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        loadPhotos {  [weak self] photos in
            self?.photoList = Array(photos[...349])
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        loadAlbums {  [weak self] albums in
            self?.albumList = Array(albums[...7])
            dispatchGroup.leave()
        }
                
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                table.reloadData()
                self?.saveToDb()
            }
        }

    }
    
    func offlineCheck() {
        if store
    }
    
    // If objects already exist in DB, dont do network call, fetch from DB
    // Else, do a network call. populate UI and save to db
    
    func fetchFromDb() {
        let albums = store.fetchAll(DbAlbumName())
        let photos = store.fetchAll(DbPhotoAlbum())

        for album in albums {
            albumArr.append(album.title)
            var innerArr = [String]()

            for photo in photos {
                if photo.albumId == album.id {
                    // photo belongs to this album
                    innerArr.append(photo.url)
                }
            }
            photoArr.append(innerArr)
            innerArr = []
        }
        fetchFromDBCompletion?()
    }
    
    func saveToDb() {
        photoList?.forEach({
            let temp = DbPhotoAlbum(id: $0.id, albumId: $0.albumId, url: $0.url)
            store.save(temp)
        })
        albumList?.forEach({
            let temp = DbAlbumName(id: $0.id, title: $0.title)
            store.save(temp)
        })
    }
 
}
