//
//  Extensions.swift
//  MDBSocials
//
//  Created by Sydney Karimi on 11/10/20.
//

import Foundation
import UIKit

extension FeedViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = eventCollectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellWidth: CGFloat
        let cellsize: CGSize?
        
        cellWidth = (heightVal < widthVal) ? bounds.height : bounds.width
        cellsize = CGSize(width: cellWidth, height: cellWidth)
        
        return cellsize!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEvent = eventArray[indexPath.row]
        performSegue(withIdentifier: "FeedToDetailSegue", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue" {
            let controller = segue.destination as! DetailViewController
            controller.event = selectedEvent
        }
    }
}
