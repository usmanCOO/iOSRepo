//
//  DealMenuTableViewCell.swift
//  DealDoc
//
//  Created by Asad Khan on 9/20/22.
//

import UIKit

class DealMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var dealNameLabel: UILabel!
    @IBOutlet weak var dealColorImage: UIImageView!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
