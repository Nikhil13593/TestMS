//
//  PostDetailTabTVC.swift
//  TestMediSage
//
//  Created by NIKHIL KISHOR PATIL on 28/04/21.
//

import UIKit

class PostDetailTabTVC: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblExplanation: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
