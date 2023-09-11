//
//  ViewController.swift
//  Assignment
//
//  Created by Brijendra Dwivedi on 09/09/23.
//

import UIKit
import CoreData
import Reachability

class ViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var imgBarLineLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Properties
  
  let viewModel = PostViewModel()
  
  // MARK: - ViewController's View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureObserver()
    bindingData()
  }
  
  // MARK: - Private Methods
  
  private func configureUI () {
    updateView(postButton)
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func configureObserver() {
    let reachability = try! Reachability()
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do{
      try reachability.startNotifier()
    }catch{
      print("could not start reachability notifier")
    }
  }
  
  @objc func reachabilityChanged(note: Notification) {
    
    let reachability = note.object as! Reachability
    
    switch reachability.connection {
    case .cellular, .wifi:
      viewModel.getPost()
    case .unavailable:
      showAlert("Internet connection is not available")
    default:
      break
    }
  }
  private func bindingData() {
    viewModel.bindViewModelToController = {
      self.tableView.reloadData()
    }
  }
  
  private func fetchFavoritePosts() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
    request.predicate = NSPredicate(format: "favorite = true")
    let posts = try? appDelegate.persistentContainer.viewContext.fetch(request) as? [Post]
    self.viewModel.favoriteModelData.removeAll()
    if let result = posts, result.count > 0 {
      for post in result {
        self.viewModel.favoriteModelData.append(PostModel(Int(post.id), title: post.title ?? ""))
      }
    }
    self.tableView.reloadData()
  }
  
  private func updateView(_ uiButton: UIButton) {
    switch uiButton {
    case postButton:
      self.imgBarLineLeadingConstraint.constant = postButton.frame.origin.x
      self.viewModel.tabType = .posts
      self.viewModel.getPost()
      
    case favoriteButton:
      self.imgBarLineLeadingConstraint.constant = favoriteButton.frame.origin.x
      self.viewModel.tabType = .favorite
      self.fetchFavoritePosts()
      
    default:
      break
    }
  }
  
  // MARK: - IBAction
  
  @IBAction func tabButtonAction(_ sender: UIButton) {
    updateView(sender)
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.tabType == .posts ? (viewModel.postModelData?.count ?? 0) : self.viewModel.favoriteModelData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let postCell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier) as? PostCell else { return UITableViewCell() }
    
    guard let item = viewModel.tabType == .posts ? viewModel.postModelData?[indexPath.row] : viewModel.favoriteModelData[indexPath.row] else { return postCell }
    postCell.configureData(data: item)
    return postCell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard viewModel.tabType == .posts else {
      return
    }
    let commentController = self.storyboard?.instantiateViewController(withIdentifier: "CommentController") as! CommentController
    commentController.viewModel.postId = viewModel.postModelData?[indexPath.row].id ?? 0
    self.navigationController?.pushViewController(commentController, animated: true)
  }
}
