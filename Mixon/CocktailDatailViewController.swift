//
//  CocktailDatailViewController.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import UIKit

class CocktailDatailViewController: UIViewController {

    var cocktail:Cocktail?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var colorView1: UIView!
    @IBOutlet weak var colorView2: UIView!
    @IBOutlet weak var colorView3: UIView!
    @IBOutlet weak var colorView4: UIView!
    
    @IBOutlet weak var colorViewWidth1: NSLayoutConstraint!
    @IBOutlet weak var colorViewWidth2: NSLayoutConstraint!
    @IBOutlet weak var colorViewWidth3: NSLayoutConstraint!
    @IBOutlet weak var colorViewWidth4: NSLayoutConstraint!
    
    @IBOutlet weak var iconView1: UIView!
    @IBOutlet weak var materialLabel1: UILabel!
    @IBOutlet weak var quantityLabel1: UILabel!
    
    @IBOutlet weak var iconView2: UIView!
    @IBOutlet weak var materialLabel2: UILabel!
    @IBOutlet weak var quantityLabel2: UILabel!
    
    @IBOutlet weak var iconView3: UIView!
    @IBOutlet weak var materialLabel3: UILabel!
    @IBOutlet weak var quantityLabel3: UILabel!
    
    @IBOutlet weak var iconView4: UIView!
    @IBOutlet weak var materialLabel4: UILabel!
    @IBOutlet weak var quantityLabel4: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        backButton.setTitle(String.fontAwesomeIcon(name: .angleLeft), for: .normal)
        
        guard let cocktail = cocktail else {
            return
        }

        nameLabel.text = cocktail.name
        imageView.image = UIImage(named:cocktail.image)
        detailLabel.text = cocktail.detail
        
        if cocktail.material1 != "" {
            materialLabel1.text = cocktail.material1
            quantityLabel1.text = "\(cocktail.quantity1)ml"
            iconView1.isHidden = false
        }
        if cocktail.material2 != "" {
            materialLabel2.text = cocktail.material2
            quantityLabel2.text = "\(cocktail.quantity2)ml"
            iconView2.isHidden = false
        }
        if cocktail.material3 != "" {
            materialLabel3.text = cocktail.material3
            quantityLabel3.text = "\(cocktail.quantity3)ml"
            iconView3.isHidden = false
        }
        if cocktail.material4 != "" {
            materialLabel4.text = cocktail.material4
            quantityLabel4.text = "\(cocktail.quantity4)ml"
            iconView4.isHidden = false
        }
        
        
        
    }

    @IBAction func didTapBackButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapMakeButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CocktailMakeViewController") as? CocktailMakeViewController {
            vc.cocktail = cocktail
            vc.step = 1
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }
    
}
