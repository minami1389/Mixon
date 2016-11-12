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
    var isMenuOpen = false
    
    var bases = [Base]()
    var cocktails = [Cocktail]()
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cocktailTableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var cocktailTableViewOriginX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        cocktailTableViewOriginX.constant = 0
        
        menuButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        searchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        menuButton.setTitle(String.fontAwesomeIcon(name: .bars), for: .normal)
        searchButton.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)
        
        bases = BaseCoordinator.sharedCoordinator.fetch()
        cocktails = CocktailCoordinator.sharedCoordinator.fetch()
        
        cocktailTableView.reloadData()
        menuTableView.reloadData()
    }
    
    func toggleMenu() {
        isMenuOpen = !isMenuOpen
        if isMenuOpen {
            cocktailTableViewOriginX.constant = 250
        } else {
            cocktailTableViewOriginX.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func didTapMenuButton(_ sender: UIButton) {
        toggleMenu()
    }

    @IBAction func didTapSearchButton(_ sender: UIButton) {
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case cocktailTableView:
            return cocktails.count
        case menuTableView:
            return bases.count + 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case cocktailTableView:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell", for: indexPath) as? CocktailTableViewCell {
                let cocktail = cocktails[indexPath.row]
                cell.titleLabel.text = cocktail.name
                cell.cocktailImageView.image = UIImage(named: cocktail.image)
                return cell
            }
        case menuTableView:
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTopTableViewCell", for: indexPath) as? MenuTopTableViewCell {
                    cell.iconImageView.image = UIImage.fontAwesomeIcon(name: .home, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
                    cell.titleLabel.text = "ホーム"
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTopTableViewCell", for: indexPath) as? MenuTopTableViewCell {
                    cell.iconImageView.image = UIImage.fontAwesomeIcon(name: .star, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
                    cell.titleLabel.text = "My cocktails"
                    return cell
                }
            default:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell {
                    cell.titleLabel.text = bases[indexPath.row-2].nameJp
                    return cell
                }
            }
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case cocktailTableView:
            return 150
        case menuTableView:
            switch indexPath.row {
            case 0,1:
                return 60
            default:
                return 50
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case cocktailTableView:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "CocktailDatailViewController") as? CocktailDatailViewController {
                vc.cocktail = cocktails[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        case menuTableView:
            toggleMenu()
            baseID = indexPath.row - 1
            CocktailCoordinator.sharedCoordinator.baseID = baseID
            cocktails = CocktailCoordinator.sharedCoordinator.fetch()
            cocktailTableView.reloadData()
        default:
            break
        }
    }
    
}
