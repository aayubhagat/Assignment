//
//  PostViewModel.swift
//  Assignment
//
//  Created by Brijendra Dwivedi on 09/09/23.
//

import Foundation
import CoreData
import Reachability

class PostViewModel {
  
  // MARK: - Properties
  
  var tabType: TabType = .posts
  
  private var apiService = APIService()
  
  var postModelData: [PostModel]? {
    didSet {
      self.bindViewModelToController()
    }
  }
  
  var favoriteModelData = [PostModel]()
  var bindViewModelToController: (() -> ()) = {}

  private func savePostToCoreData(_ model: PostModel) {
    let entity = NSEntityDescription.entity(forEntityName: "Post", in: appDelegate.persistentContainer.viewContext)
    let post = NSManagedObject(entity: entity!, insertInto: appDelegate.persistentContainer.viewContext)
    post.setValue(model.id, forKey: "id")
    post.setValue(model.title, forKey: "title")
    post.setValue(false, forKey: "favorite")

    do {
        try appDelegate.persistentContainer.viewContext.save()
    } catch {
        print("Failed saving")
    }
  }
  
  func fetchPostFromCoreData() {
    do {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
      let posts = try appDelegate.persistentContainer.viewContext.fetch(request) as! [Post]

      var postData = [PostModel]()
      for post in posts {
        postData.append(PostModel(Int(post.id), title: post.title ?? ""))
      }
      self.postModelData = postData
    }
    catch {
    }
  }
  
  // MARK: - API
  
  func getPost() {
    let reachability = try! Reachability()
    if reachability.connection == .unavailable {
      fetchPostFromCoreData()
    } else {
      apiService.getPost() { posts in
        self.postModelData = posts
        self.postModelData?.forEach({ post in
          self.savePostToCoreData(post)
        })
      }
    }
  }
}
