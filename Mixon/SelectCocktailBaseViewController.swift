//
//  SelectCocktailBaseViewController.swift
//  Mixon
//
//  Created by Baba Minami on 2016/11/12.
//  Copyright © 2016年 Baba Minami. All rights reserved.
//

import UIKit
import RealmSwift

class SelectCocktailBaseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var bases = [Base]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bases = BaseCoordinator.sharedCoordinator.fetch()
        tableView.reloadData()
    }

}

extension SelectCocktailBaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let base = bases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCocktailTableViewCell", for: indexPath) as! SelectCocktailTableViewCell
        cell.titleLabel.text = "\(base.nameJp)　\(base.nameEn)"
        cell.cocktailImageView?.image = UIImage(named: base.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            homeVC.baseID = bases[indexPath.row].id
            self.present(homeVC, animated: true, completion: nil)
        }
    }
    
}
