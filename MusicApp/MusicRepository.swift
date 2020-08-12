//
//  MusicRepository.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/26/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation
import RealmSwift

class MusicRepository: MusicRepositoryProtocol {
    
    // MARK: Static Instance
    static let instance = MusicRepository()
    
    private init() {}
    
    // MARK: Variable
    
    
    // MARK: Function
    func getAll() -> Results<MusicModel> {
        let realm = try! Realm()
        let result = realm.objects(MusicModel.self).sorted(byKeyPath: "name")
        return result
    }
    
    func getById(id: Int) -> MusicModel? {
        let realm = try! Realm()
        //var result = MusicModel()
        let result = realm.objects(MusicModel.self).filter("id == " + String(id)).first
        return result
    }
    
    func add(musicmodel: MusicModel) -> Bool {
        let realm = try! Realm()
        try! realm.write {
            realm.add(musicmodel)
        }
        return true
    }
    
    func update(musicmodel: MusicModel) -> Bool {
        let realm = try! Realm()
        let music = musicmodel
        
        try! realm.write {
            realm.add(music, update: .modified)
        }
        return true
    }
    
    func delete(id: Int) -> Bool {
        let realm = try! Realm()
        guard let music = realm.objects(MusicModel.self).filter("id == " + String(id)).first else { return false }
        try! realm.write {
            realm.delete(music)
        }
        return true
    }
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func printSomething() {
        print("MusicRepository Print Something")
    }
}
