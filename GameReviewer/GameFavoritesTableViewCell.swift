//
//  GameFavoritesTableViewCell.swift
//  GameReviewer
//
//  Created by Ethan Mathew on 11/5/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import UIKit

class GameFavoritesTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
