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
    
    @IBOutlet weak var scrollView: UIScrollView!
    var contentOffSet = CGPoint(x:0, y:0)
    
    var didLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        bases = BaseCoordinator.sharedCoordinator.fetch()
        cocktails = CocktailCoordinator.sharedCoordinator.fetch()
        
        cocktailTableView.reloadData()
        
        //DetailView
        setDetailView(cocktail: cocktails[selectedRow])
        
        prepareMenuTab()
    }
    
    func prepareMenuTab() {
        var bases = BaseCoordinator.sharedCoordinator.fetch()
        let others = bases[4]
        bases.remove(at: 4)
        bases.append(others)
        
        let width:CGFloat = 100
        let headLabelWidth = scrollView.frame.size.width/2 - width/2
        let headLabel = UILabel()
        headLabel.frame = CGRect(x:0, y:0, width:headLabelWidth, height:43)
        scrollView.addSubview(headLabel)
        
        var originX:CGFloat = headLabelWidth
        for base in bases {
            scrollView.addSubview(menuLabel(title: base.nameJp, x: originX))
            originX += width
            if base.nameJp == "ラム" {
                scrollView.addSubview(menuLabel(title: "おすすめ", x: originX))
                originX += width
            }
        }
        
        let tailLabel = UILabel()
        tailLabel.frame = CGRect(x:originX, y:0, width:headLabelWidth, height:43)
        scrollView.addSubview(tailLabel)
        originX += headLabelWidth
        
        scrollView.contentSize = CGSize(width:originX, height:scrollView.frame.size.height)
        
        let diff =  headLabelWidth + 450 - scrollView.frame.size.width / 2
        scrollView.contentOffset = CGPoint(x:diff, y:scrollView.contentOffset.y)
        contentOffSet = scrollView.contentOffset
    }
    
    func menuLabel(title:String, x:CGFloat) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.frame = CGRect(x:x, y:0, width:100, height:43)
        label.font = UIFont(name: "HiraKakuProN-W6",size: 15.0)
        label.textColor = UIColor.white
        label.text = title
        return label
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let index = Int((scrollView.contentOffset.x + 50) / 100) 
        let x = index * 100
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.contentOffset = CGPoint(x:x, y:0)
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x - 50) / 100) + 1
        let x = index * 100
        UIView.animate(withDuration: 1.0, animations: {
            scrollView.contentOffset = CGPoint(x:x, y:0)
        })
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
