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
    @IBOutlet weak var collectionView: UICollectionView!
    var bases = [Base]()
    var selected = Array(repeating:false, count:9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsMultipleSelection = true
        bases = BaseCoordinator.sharedCoordinator.fetch()
        collectionView.reloadData()
    }

}

extension SelectCocktailBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bases.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == bases.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CocktailSelectStartCollectionViewCell", for: indexPath) as! CocktailSelectStartCollectionViewCell
            cell.arrowLabel.font = UIFont.fontAwesome(ofSize: 28)
            cell.arrowLabel.text = String.fontAwesomeIcon(name: .angleDoubleRight)
            return cell
            
        }
        
        let base = bases[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CocktailSelectCollectionViewCell", for: indexPath) as! CocktailSelectCollectionViewCell
        cell.nameJpLabel.text = "\(base.nameJp)"
        cell.nameEnLabel.text = "\(base.nameEn)"
        cell.cocktailImageView?.image = UIImage(named: base.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != bases.count {
            let cell = collectionView.cellForItem(at: indexPath) as! CocktailSelectCollectionViewCell
            cell.coverView.isHidden = true
            selected[indexPath.item] = true
            return
        }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            CocktailCoordinator.sharedCoordinator.baseID = -1
            CocktailCoordinator.sharedCoordinator.haveCocktails = selected
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.item != bases.count {
            let cell = collectionView.cellForItem(at: indexPath) as! CocktailSelectCollectionViewCell
            cell.coverView.isHidden = false
            selected[indexPath.item] = false
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 6
        let row: CGFloat = 2
        let column: CGFloat = 5
        let ratio: CGFloat = 142/123
        let width = (collectionView.frame.size.width - margin * (column - 1)) / column
        let height = (collectionView.frame.size.height - margin * (row - 1)) / row
        return CGSize(width: width, height: width*ratio)
    }
    
    
}
