//
//  TaskModel.swift
//  AirVetSwiftUI
//
//  Created by Jian Ma on 8/27/24.
//

import Foundation

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var isCompleted: Bool = false
}
