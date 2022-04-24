//
//  TodoTableViewCell.swift
//  MiniApp-ToDoApp-Realm
//
//  Created by 近藤米功 on 2022/04/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet var todoLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        todoLabel.text = ""
        dateLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
