//
//  CocktailMakeViewController.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import UIKit

class CocktailMakeViewController: UIViewController {

    var cocktail: Cocktail?
    var step = 0
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 70)
        closeButton.setTitle(String.fontAwesomeIcon(name: .timesCircle), for: .normal)
        
        guard let cocktail = cocktail else {
            return
        }
        
        switch step {
        case 1:
            stepLabel.text = "STEP 1"
            cocktailNameLabel.text = cocktail.material1
            quantityLabel.text = "\(cocktail.quantity1)ml"
            view.backgroundColor = UIColor.init(red: 240/255, green: 208/255, blue: 228/255, alpha: 1.0)
        case 2:
            stepLabel.text = "STEP 2"
            cocktailNameLabel.text = cocktail.material2
            quantityLabel.text = "\(cocktail.quantity2)ml"
            view.backgroundColor = UIColor.init(red: 210/255, green: 126/255, blue: 179/255, alpha: 1.0)
        case 3:
            stepLabel.text = "STEP 3"
            cocktailNameLabel.text = cocktail.material3
            quantityLabel.text = "\(cocktail.quantity3)ml"
            view.backgroundColor = UIColor.init(red: 180/255, green: 60/255, blue: 136/255, alpha: 1.0)
        case 4:
            stepLabel.text = "STEP 4"
            cocktailNameLabel.text = cocktail.material4
            quantityLabel.text = "\(cocktail.quantity4)ml"
            view.backgroundColor = UIColor.init(red: 165/255, green: 33/255, blue: 117/255, alpha: 1.0)
        default:
            break
        }
        
    }

    @IBAction func didTap(_ sender: Any) {
        switch step {
        case 1:
            if cocktail?.material2 == "" {
                return
            }
        case 2:
            if cocktail?.material3 == "" {
                return
            }
        case 3:
            if cocktail?.material4 == "" {
                return
            }
        case 4:
            return
        default:
            break
        }

        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CocktailMakeViewController") as? CocktailMakeViewController {
            vc.cocktail = cocktail
            vc.step = (step+1)
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
   
}
