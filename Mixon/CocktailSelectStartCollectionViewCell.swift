//
//  CocktailSelectStartCollectionViewCell.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/19.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import UIKit

class CocktailSelectStartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var startLabel: UILabel!
    
    override func awakeFromNib() {
        guard let text = startLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: 2.0, range: NSRange(location: 0, length: text.characters.count))
        attributedString.addAttribute(NSFontAttributeName, value: startLabel.font, range: NSRange(location: 0, length: text.characters.count))
        startLabel.attributedText = attributedString
    }
}
