//
//  CommentController.swift
//  Assignment
//
//  Created by Brijendra Dwivedi on 09/09/23.
//

import UIKit
import CoreData

class CommentController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var favButton: UIButton!

  // MARK: - Properties
  
  let viewModel = CommentViewModel()

  // MARK: - ViewController's View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindingData()
  }
  
  // MARK: - Private Methods

  private func configureUI () {
    viewModel.getPostComments()
    fetchPostFromCoreData()
  }

  private func bindingData() {
    viewModel.bindViewModelToController = {
      self.tableView.reloadData()
    }
  }

  func fetchPostFromCoreData() {
    do {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
      request.predicate = NSPredicate(format: "id = %d", viewModel.postId)
      let results = try appDelegate.persistentContainer.viewContext.fetch(request)
      let post: Post = results.first as! Post
      favButton.setImage(UIImage(systemName: post.favorite ? "star.fill" : "star"), for: .normal)
    } catch {}

  }
  
  // MARK: - IBAction

  @IBAction func backButtonAction(_ sender: UIButton) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func favButtonAction(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    favButton.setImage(UIImage(systemName: sender.isSelected ? "star.fill" : "star"), for: .normal)
    do {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
      request.predicate = NSPredicate(format: "id = %d", viewModel.postId)
      let results = try appDelegate.persistentContainer.viewContext.fetch(request)
      let post: Post = results.first as! Post
      post.favorite = sender.isSelected
      do {
          try appDelegate.persistentContainer.viewContext.save()
      } catch {
          print("Failed saving")
      }
    } catch {}
  }

}

// MARK: - UITableViewDataSource

extension CommentController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.commentModelData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let commentCell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier) as? CommentCell else { return UITableViewCell() }
    guard let item = viewModel.commentModelData?[indexPath.row] else { return commentCell }
    commentCell.configureData(data: item)
    return commentCell
  }
}

