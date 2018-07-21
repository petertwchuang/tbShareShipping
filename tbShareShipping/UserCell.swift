//
//  UserCell.swift
//  taobaoWeight
//
//  Created by Peter on 2018/7/2.
//  Copyright © 2018年 Peter. All rights reserved.
//

import UIKit

protocol EnterWeightDelegate {
    func weightButtonTapped(at index:IndexPath, sender: UIButton)
}


class UserCell: UITableViewCell {
    
    var delegate:EnterWeightDelegate!
    var indexPath:IndexPath!
    
    @IBOutlet weak var nameTextField: UITextField!    
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBAction func tappedAction(_ sender: UIButton) {
        self.delegate.weightButtonTapped(at: indexPath, sender: sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameTextField.text = ""
        weightButton.titleLabel?.text = "weight?"
        priceLabel.text = "$ 0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
