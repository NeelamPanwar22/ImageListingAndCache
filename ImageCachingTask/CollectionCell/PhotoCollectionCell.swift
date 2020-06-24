//
//  PhotoCollectionCell.swift
//  AssignedTask1MG
//
//  Created by neelam panwar on 24/06/20.
//  Copyright © 2020 neelam panwar. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    //MARK::- IBOutlets
    @IBOutlet weak var photoView: ImageCacheView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    var photoUrl : PhotoDetailModel?{
        didSet{
            guard let imgUrl = URL.init(string: photoUrl?.imageUrl ?? "") else { return }
            activityIndicator?.startAnimating()
            photoView?.loadImageWithUrl(imgUrl, callBack: { [weak self] (_, isFinished) in
                self?.activityIndicator?.stopAnimating()
            })
        }
    }
}
