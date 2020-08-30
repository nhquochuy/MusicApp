//
//  MusicRepositoryProtocol.swift
//  MusicApp
//
//  Created by Quoc Huy on 7/26/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import Foundation
import RealmSwift

protocol MusicRepositoryProtocol {
    associatedtype T where T: Object
    associatedtype I
    func getAll() -> Results<T>
    func getById(id: I) -> T?
    func add(musicmodel: T)
    func updateStateProp(id: I, isSelected: Bool, isPlaying: Bool)
    func resetDefaultStateProp()
    func delete(id: I)
    func deleteAll()
    func printSomething()
}
