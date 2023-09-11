//
//  CommentViewModel.swift
//  Assignment
//
//  Created by Brijendra Dwivedi on 09/09/23.
//

import Foundation

class CommentViewModel {
  
  // MARK: - Properties
  
  private var apiService = APIService()
  var postId = 0

  var commentModelData : [CommentModel]? {
    didSet {
      self.bindViewModelToController()
    }
  }
  var bindViewModelToController : (() -> ()) = {}
  
  // MARK: - API
  
  func getPostComments() {
    apiService.getPostDetail(postId) { comments in
      self.commentModelData = comments
    }
  }
}
