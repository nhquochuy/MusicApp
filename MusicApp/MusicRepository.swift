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
    typealias T = MusicModel
    typealias I = Int
    
    // MARK: Static Instance
    static let shared = MusicRepository()
    
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
        let result = realm.objects(MusicModel.self).filter("id == " + String(id)).first
        return result
    }
    
    private func incrementPrimaryKey() -> Int {
        let realm = try! Realm()
      return (realm.objects(MusicModel.self).max(ofProperty: "index") as Int? ?? 0) + 1
    }
    
    func add(musicmodel: MusicModel) {
        let realm = try! Realm()
        try! realm.write {
            musicmodel.index = incrementPrimaryKey()
            realm.add(musicmodel)
        }
    }
    
    func updateStateProp(id: Int, isSelected: Bool, isPlaying: Bool){
        let realm = try! Realm()
        
        let objects = realm.objects(MusicModel.self)
        
        try! realm.write {
            for object in objects {
                if object.id == id {
                    object.isSelected = isSelected
                    object.isPlaying = isPlaying
                } else {
                    object.isSelected = false
                    object.isPlaying = false
                }
                realm.add(object, update: .modified)
            }
        }
    }
    
    func resetDefaultStateProp() {
        let realm = try! Realm()
        
        let objects = realm.objects(MusicModel.self)
        
        try! realm.write {
            for object in objects {
                object.isSelected = false
                object.isPlaying = false
                realm.add(object, update: .modified)
            }
        }
    }
    
    func delete(id: Int){
        let realm = try! Realm()
        guard let music = realm.objects(MusicModel.self).filter("id == " + String(id)).first else { return }
        try! realm.write {
            realm.delete(music)
        }
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
