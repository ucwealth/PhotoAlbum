//
//  PhotoViewModel.swift
//  CypressPhotoAlbum
//
//  Created by Decagon on 02/11/2022.
//

import Foundation
import UIKit
import RealmSwift

class PhotoViewModel {
    let baseUrl = "https://jsonplaceholder.typicode.com"
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
        let photoUrl = "\(baseUrl)/photos"
        webService.load(from: photoUrl, completion: completion)
    }
 
    // Get Albums 
    public func loadAlbums(completion: @escaping ([AlbumName]) -> ()) {
        let albumUrl = "\(baseUrl)/albums"
        webService.load(from: albumUrl, completion: completion)
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
                self?.saveToDb()
                table.reloadData()
            }
        }

    }
    
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
