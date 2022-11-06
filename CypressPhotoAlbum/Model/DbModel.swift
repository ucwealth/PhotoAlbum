//
//  DbModel.swift
//  CypressPhotoAlbum
//
//  Created by Decagon on 03/11/2022.
//

import Foundation
import RealmSwift

class DbPhotoAlbum: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var albumId: Int
    @Persisted var url: String = ""
    
    convenience init(id: Int, albumId: Int, url: String) {
        self.init()
        self.id = id
        self.albumId = albumId
        self.url = url
    }
}

class DbAlbumName: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String = ""
    
    convenience init(id: Int, title: String) {
        self.init()
        self.id = id
        self.title = title
    }
}
