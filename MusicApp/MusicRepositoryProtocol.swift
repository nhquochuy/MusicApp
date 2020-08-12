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
    func getAll() -> Results<MusicModel>
    func getById(id: Int) -> MusicModel?
    func add(musicmodel: MusicModel) -> Bool
    func update(musicmodel: MusicModel) -> Bool
    func delete(id: Int) -> Bool
    func deleteAll()
    func printSomething()
}
