//
//  TaskModel.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var isCompleted: Bool

    init(id: UUID = UUID(), name: String, description: String, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.isCompleted = isCompleted
    }
}
