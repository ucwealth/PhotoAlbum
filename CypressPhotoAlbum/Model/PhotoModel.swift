
import Foundation

struct PhotoAlbum: Codable {
    let albumId, id: Int
    let url: String
}

struct AlbumName: Codable {
    let id: Int
    let title: String
}
