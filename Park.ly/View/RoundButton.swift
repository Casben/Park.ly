//
//  RoundButton.swift
//  Park.ly
//
//  Created by Herbert Dodge on 5/20/21.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.height / 2
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
    }

}
