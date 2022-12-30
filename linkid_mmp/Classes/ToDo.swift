//
//  ToDo.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 30/12/2022.
//

import Foundation

struct ToDo: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}
