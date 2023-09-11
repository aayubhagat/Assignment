//
//  APIService.swift
//  Assignment
//
//  Created by Brijendra Dwivedi on 09/09/23.
//

import Foundation

class APIService {
  
  func getPost(completion: @escaping ([PostModel]) -> ()) {
    
    let postAPIUrl = "https://jsonplaceholder.typicode.com/posts/"
    let url = URL(string: postAPIUrl)!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      DispatchQueue.main.async {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        guard let data = data else {
          print("Invalid data or response")
          return
        }
        
        do {
          let items = try JSONDecoder().decode([PostModel].self, from: data)
          completion(items)
        } catch {
          print(error.localizedDescription)
        }
      }
    } .resume()
  }
  
  func getPostDetail(_ postId : Int, completion : @escaping ([CommentModel]) -> ()) {
    
    let postDetailAPIUrl = "https://jsonplaceholder.typicode.com/posts/\(postId)/comments"
    let url = URL(string: postDetailAPIUrl)!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      
      DispatchQueue.main.async {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        guard let data = data else {
          print("Invalid data or response")
          return
        }
        
        do {
          let items = try JSONDecoder().decode([CommentModel].self, from: data)
          completion(items)
        } catch {
          print(error.localizedDescription)
        }
      }
    }
    .resume()
  }
  
}
