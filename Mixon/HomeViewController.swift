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

    var isMenuOpen = false
    
    var bases = [Base]()
    var cocktails = [Cocktail]()
    
    var selectedRow = 0
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cocktailTableView: UITableView!
    
    //DetailView
    @IBOutlet weak var nameJpLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var material1Label: UILabel!
    @IBOutlet weak var material2Label: UILabel!
    @IBOutlet weak var material3Label: UILabel!
    @IBOutlet weak var material4Label: UILabel!
    @IBOutlet weak var material5Label: UILabel!
    @IBOutlet weak var tasteLabel: UILabel!
    
    var didLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        menuButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        searchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        menuButton.setTitle(String.fontAwesomeIcon(name: .bars), for: .normal)
        searchButton.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)
        
        bases = BaseCoordinator.sharedCoordinator.fetch()
        cocktails = CocktailCoordinator.sharedCoordinator.fetch()
        
        cocktailTableView.reloadData()
        
        //DetailView
        setDetailView(cocktail: cocktails[selectedRow])
    }
    
    func setDetailView(cocktail: Cocktail) {
        nameJpLabel.text = cocktail.name
        nameEnLabel.text = cocktail.name
        material1Label.text = ""
        material2Label.text = ""
        material3Label.text = ""
        material4Label.text = ""
        material5Label.text = ""
        if cocktail.material1 != "" {
            material1Label.text = "　・\(cocktail.material1)"
        }
        if cocktail.material2 != "" {
            material2Label.text = "　・\(cocktail.material2)"
        }
        if cocktail.material3 != "" {
            material3Label.text = "　・\(cocktail.material3)"
        }
        if cocktail.material4 != "" {
            material4Label.text = "　・\(cocktail.material4)"
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didLoad = true
    }
    
    @IBAction func didTapMakeButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CocktailMakeViewController") as? CocktailMakeViewController {
            vc.cocktail = cocktails[selectedRow]
            vc.step = 1
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapMenuButton(_ sender: UIButton) {
    }

    @IBAction func didTapSearchButton(_ sender: UIButton) {
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case cocktailTableView:
            return cocktails.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell", for: indexPath) as? CocktailTableViewCell else {
            return UITableViewCell()
        }
        
        let cocktail = cocktails[indexPath.row]
        cell.titleLabel.text = cocktail.name
        cell.cocktailImageView.image = UIImage(named: cocktail.image)
        if !didLoad && indexPath.row == selectedRow {
            cell.coverView.isHidden = true
            cell.titleLabel.isHidden = true
            cell.tasteLabel.isHidden = true
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case selectedRow:
            return 150
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        
        if let cell = tableView.cellForRow(at: IndexPath(row: selectedRow, section: 0)) as? CocktailTableViewCell {
            cell.coverView.isHidden = false
            cell.titleLabel.isHidden = false
            cell.tasteLabel.isHidden = false
            selectedRow = -1
        }
    
        
        let cell = tableView.cellForRow(at: indexPath) as! CocktailTableViewCell
        cell.coverView.isHidden = true
        cell.titleLabel.isHidden = true
        cell.tasteLabel.isHidden = true
        selectedRow = indexPath.row
        
        tableView.endUpdates()
        
        self.setDetailView(cocktail: self.cocktails[self.selectedRow])
    }
    
}
