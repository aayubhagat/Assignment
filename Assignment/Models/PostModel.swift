//
//  PostModel.swift
//  Assignment
//
//  Created by Brijendra Dwivedi on 09/09/23.
//

import Foundation

struct PostModel: Decodable {
    var id : Int!
    var title: String!
  
  init(_ id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

