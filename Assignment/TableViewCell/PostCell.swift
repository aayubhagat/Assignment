//
//  PostCell.swift
//  Assignment
//
//  Created by Brijendra Dwivedi on 09/09/23.
//

import UIKit

class PostCell: UITableViewCell {

  static let reuseIdentifier = "PostCell"

  //MARK: - IBOutlets

  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func configureData(data: PostModel) {
    self.titleLabel.text = data.title
  }
}
