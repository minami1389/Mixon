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
    
    var numberOfRow = 0
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cocktailTableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //DetailView
    @IBOutlet weak var nameJpLabel: UILabel!
    @IBOutlet weak var nameEnLabel: UILabel!
    @IBOutlet weak var material1Label: UILabel!
    @IBOutlet weak var material2Label: UILabel!
    @IBOutlet weak var material3Label: UILabel!
    @IBOutlet weak var material4Label: UILabel!
    @IBOutlet weak var material5Label: UILabel!
    @IBOutlet weak var tasteLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var contentOffSet = CGPoint(x:0, y:0)
    @IBOutlet weak var scrollCoverView: UIView!
    
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var searchResultView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarOriginY: NSLayoutConstraint!
    var searchText = ""
    
    var didLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        menuView.isHidden = (searchText != "")
        searchBar.isHidden = (searchText != "")
        searchResultView.isHidden = (searchText == "")
        searchResultLabel.text = "\"\(searchText)\"の検索結果"
        
        bases = BaseCoordinator.sharedCoordinator.fetch()
        if searchText == "" {
            let have = BaseCoordinator.sharedCoordinator.haveBases
            for i in 0..<bases.count {
                if have[i] {
                    cocktails += CocktailCoordinator.sharedCoordinator.fetch(baseID: i)
                }
            }
        } else {
            let data = CocktailCoordinator.sharedCoordinator.fetch(baseID: -1)
            for d in data {
                if d.nameJp.hasPrefix(searchText) {
                    cocktails.append(d)
                }
            }
        }
        numberOfRow = cocktails.count
        cocktailTableView.reloadData()
        
        //DetailView
        if cocktails.count != 0 {
            setDetailView(cocktail: cocktails[selectedRow])
        } else {
            detailView.isHidden = true
        }
        
        prepareMenuTab()
        prepareMenuGradienView()
        
        searchBarOriginY.constant = -searchBar.frame.size.height
    }
    
    override func viewDidLayoutSubviews() {
        if !didLoad {
            UIView.animate(withDuration: 0.3, animations: {
                let y = 0 * 50 - 76
                self.cocktailTableView.contentOffset = CGPoint(x:0, y:y)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didLoad = true
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
    
    func prepareMenuGradienView() {
        let startColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85).cgColor
        let endColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let layer = CAGradientLayer()
        layer.colors = [startColor, endColor, startColor]
        layer.startPoint = CGPoint(x:0, y:0.5)
        layer.endPoint = CGPoint(x:1, y:0.5)
        layer.frame = scrollCoverView.frame
        scrollCoverView.layer.addSublayer(layer)
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
        backgroundImageView.image = UIImage(named: cocktail.image)
        
        nameJpLabel.text = cocktail.nameJp
        nameEnLabel.text = cocktail.nameEn
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
    
    @IBAction func didTapMakeButton(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CocktailMakeViewController") as? CocktailMakeViewController {
            vc.cocktail = cocktails[selectedRow]
            vc.step = 1
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapMenuButton(_ sender: UIButton) {
        dismiss(animated: true, completion: {})
    }

    @IBAction func didTapSearchButton(_ sender: UIButton) {
        if searchBarOriginY.constant == 0 {
            searchBarOriginY.constant = -searchBar.frame.size.height
            searchBar.resignFirstResponder()
            searchBar.text = ""
        } else {
            searchBarOriginY.constant = 0
            searchBar.becomeFirstResponder()
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func didTapSearchResultBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarOriginY.constant = -searchBar.frame.size.height
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        if let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            vc.searchText = searchBar.text!
            navigationController?.show(vc, sender: self)
            searchBar.text = ""
        }
        
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == self.scrollView else { return }
        let index = Int((scrollView.contentOffset.x + 50) / 100) 
        let x = index * 100
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.contentOffset = CGPoint(x:x, y:0)
        })
        didSelectBaseCategory(index: index)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        let index = Int((scrollView.contentOffset.x - 50) / 100) + 1
        let x = index * 100
        UIView.animate(withDuration: 1.0, animations: {
            scrollView.contentOffset = CGPoint(x:x, y:0)
        })
        didSelectBaseCategory(index: index)
    }
    
    func didSelectBaseCategory(index: Int) {
        cocktails = []
        if index == 9 { //その他
            cocktails = CocktailCoordinator.sharedCoordinator.fetch(baseID: 4)
        } else if index == 4 { //おすすめ
            let have = BaseCoordinator.sharedCoordinator.haveBases
            for i in 0..<bases.count {
                if have[i] {
                    cocktails += CocktailCoordinator.sharedCoordinator.fetch(baseID: i)
                }
            }
        } else {
            cocktails = CocktailCoordinator.sharedCoordinator.fetch(baseID: index)
        }
        
        numberOfRow = cocktails.count
        selectedRow = 0
        cocktailTableView.reloadData()
        if cocktails.count != 0 {
            detailView.isHidden = false
            setDetailView(cocktail: cocktails[selectedRow])
        } else {
            detailView.isHidden = true
        }
        UIView.animate(withDuration: 0.3, animations: {
            let y = 0 * 50 - 76
            self.cocktailTableView.contentOffset = CGPoint(x:0, y:y)
        })
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case cocktailTableView:
            return numberOfRow
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailTableViewCell") as? CocktailTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.row >= cocktails.count {
            cell.isHidden = true
            return cell
        }
        
        cell.isHidden = false
        let cocktail = cocktails[indexPath.row]
        cell.titleLabel.text = cocktail.nameJp
        cell.cocktailImageView.image = UIImage(named: cocktail.image)
        if indexPath.row == selectedRow {
            cell.coverView.isHidden = true
            cell.titleLabel.isHidden = true
            cell.tasteLabel.isHidden = true
        } else {
            cell.coverView.isHidden = false
            cell.titleLabel.isHidden = false
            cell.tasteLabel.isHidden = false
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case selectedRow:
            return 156
        case cocktails.count:
            if selectedRow == cocktails.count - 1 {
                return 93
            } else {
                return 43
            }
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.3, animations: {
            let y = indexPath.row * 50 - 76
            tableView.contentOffset = CGPoint(x:0, y:y)
            self.setDetailView(cocktail: self.cocktails[indexPath.row])
        })
        
        if indexPath.row > cocktails.count - 3 && cocktails.count > 2 {
            numberOfRow = cocktails.count + 1
        } else {
            numberOfRow = cocktails.count
        }
        cocktailTableView.reloadData()
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            tableView.beginUpdates()
            
            if let cell = tableView.cellForRow(at: IndexPath(row: self.selectedRow, section: 0)) as? CocktailTableViewCell {
                cell.coverView.isHidden = false
                cell.titleLabel.isHidden = false
                cell.tasteLabel.isHidden = false
                self.selectedRow = -1
            }
            
            
            let cell = tableView.cellForRow(at: indexPath) as! CocktailTableViewCell
            cell.coverView.isHidden = true
            cell.titleLabel.isHidden = true
            cell.tasteLabel.isHidden = true
            self.selectedRow = indexPath.row
            
            tableView.endUpdates()
        })
      
    }
    
}
