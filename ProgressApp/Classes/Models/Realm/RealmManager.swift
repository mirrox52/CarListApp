//
//  RealmManager.swift
//  ProgressApp
//
//  Created by Aliaksandr on 22.10.22.
//

import Realm
import RealmSwift

final class RealmManager {
    
    static let shared = RealmManager()
    
    private func getRealm() -> Realm? {
        try? Realm()
    }
    
    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        if !isRealmAccessible() { return nil }
        
        guard let realm = getRealm() else { return nil }
        realm.refresh()
        
        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }
    
    func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        if !isRealmAccessible() { return nil }
        
        guard let realm = getRealm() else { return nil }
        realm.refresh()
        
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    func add<T: Object>(_ data: [T]) {
        if !isRealmAccessible() { return }
        
        guard let realm = getRealm() else { return }
        realm.refresh()
        
        if realm.isInWriteTransaction {
            realm.add(data)
        } else {
            try? realm.write {
                realm.add(data)
            }
        }
    }
    
    func add<T: Object>(_ data: T) {
        add([data])
    }
    
    func runTransaction(action: () -> Void) {
        if !isRealmAccessible() { return }
        
        guard let realm = getRealm() else { return }
        realm.refresh()
        
        try? realm.write {
            action()
        }
    }
    
    func delete<T: Object>(_ data: [T]) {
        if !isRealmAccessible() { return }
        
        guard let realm = getRealm() else { return }
        realm.refresh()
        
        try? realm.write { realm.delete(data) }
    }
    
    func delete<T: Object>(_ data: T) {
        delete([data])
    }
    
    func clearAllData() {
        if !isRealmAccessible() { return }
        
        guard let realm = getRealm() else { return }
        realm.refresh()
        try? realm.write { realm.deleteAll() }
    }
}

extension RealmManager {
    
    private func isRealmAccessible() -> Bool {
        do { _ = try Realm() } catch {
            print("Realm is not accessible")
            return false
        }
        return true
    }

    func configureRealm() {
        let config = RLMRealmConfiguration.default()
        config.deleteRealmIfMigrationNeeded = true
        RLMRealmConfiguration.setDefault(config)
    }
}
