//
//  HomeViewController.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import UIKit
import FontAwesome_swift

class HomeViewController: UIViewController {

    var baseID = 0
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cocktailTableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var cocktailTableViewOriginX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        searchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        menuButton.setTitle(String.fontAwesomeIcon(name: .bars), for: .normal)
        searchButton.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)
        
    }
    
    @IBAction func didTapMenuButton(sender: UIButton) {
    }

    @IBAction func didTapSearchButton(sender: UIButton) {
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case cocktailTableView:
            return 10
        case menuTableView:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case cocktailTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell", for: indexPath) as? CocktailTableViewCell {
                return cell
            }
        case menuTableView:
            break
        default:
            break
        }
        
        return UITableViewCell()
    }
}
