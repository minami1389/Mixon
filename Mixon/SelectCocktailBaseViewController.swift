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
            cell.coverView.alpha = 0.8
            cell.isUserInteractionEnabled = false
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
        if indexPath.item == bases.count {
            collectionView.deselectItem(at: indexPath, animated: false)
            if let vc = storyboard?.instantiateViewController(withIdentifier: "UINavigationController") as? UINavigationController {
                BaseCoordinator.sharedCoordinator.haveBases = selected
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CocktailSelectCollectionViewCell
        cell.coverView.alpha = 0.0
        selected[indexPath.item] = true
        
        let startCell = collectionView.cellForItem(at: IndexPath(item:bases.count, section:0)) as! CocktailSelectStartCollectionViewCell
        if startCell.coverView.alpha > 0.5 {
            startCell.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3, animations: {
                startCell.coverView.alpha = 0.0
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.item == bases.count {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! CocktailSelectCollectionViewCell
        selected[indexPath.item] = false
        cell.coverView.alpha = 0.8
        
        let startCell = collectionView.cellForItem(at: IndexPath(item:bases.count, section:0)) as! CocktailSelectStartCollectionViewCell
        if startCell.coverView.alpha < 0.5 && !selected.contains(true) {
            startCell.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3, animations: {
                startCell.coverView.alpha = 0.8
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 123, height: 142)
    }
    
    
}
