
import Foundation
import RealmSwift

final class StorageManager {
    static var shared = StorageManager()
    let realm = try! Realm()
    
    func save<T: Object>(_ object: T) {
        try! realm.write({
            realm.add(object, update: .modified)
        })
    }
    
    func fetchAll<T: Object>(_ object: T) -> Results<T> {
        return realm.objects(T.self)

    }
    
    func existInDb() {
        
    }

}
