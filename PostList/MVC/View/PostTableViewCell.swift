//
//  PostTableViewCell.swift
//  PostList
//
//  Created by Samreen kaur on 25/04/24.
//

import UIKit

class PostTableViewCell: UITableViewCell 
{
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    //MARK: Variable
    var post: Post?
    {
        didSet
        {
            self.cellLoad()
        }
    }
    
    //MARK: Init Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: Private Functions
    private func cellLoad()
    {
        if let post = post
        {
            titleLabel.text = "\(post.id): \(post.title)"
            bodyLabel.text = post.body
        }
    }
}
