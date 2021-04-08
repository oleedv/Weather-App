//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Ole Edvard Nørholm on 11/19/20.
//

import Foundation
import UIKit
class weatherCell: UITableViewCell {
    
    @IBOutlet weak var label1:UILabel!
    @IBOutlet weak var tempLabel:UILabel!
    @IBOutlet weak var label3:UILabel!
    //view2
    // @IBOutlet weak var nowLabel:UILabel!
    // @IBOutlet weak var vaerLabel:UILabel!
    @IBOutlet weak var amount_max:UILabel!
    @IBOutlet weak var symbolCode:UILabel!
    //view 3
    // @IBOutlet weak var next6Label:UILabel!
    // @IBOutlet weak var vaerLabel1:UILabel!
    @IBOutlet weak var amount_max1:UILabel!
    @IBOutlet weak var symbolCode1:UILabel!
    //view 4
    // @IBOutlet weak var next12Label:UILabel!
    // @IBOutlet weak var vaerLabel2:UILabel!
    //@IBOutlet weak var amount_max2:UILabel!
    @IBOutlet weak var symbolCode2:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
