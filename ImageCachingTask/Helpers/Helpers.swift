//
//  Helpers.swift
//  AssignedTask1MG
//
//  Created by neelam panwar on 24/06/20.
//  Copyright © 2020 neelam panwar. All rights reserved.
//

import UIKit

struct APIConstants {
    
    static let  apiKey = "5a1f6a17bc6c82e7477f35c936c19310"
    static let basePath = "https://www.flickr.com/services/rest/"
    
}

struct ScreenSize{
    
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCALE = UIScreen.main.scale
}

extension NSObject {
    class var reuseableIdentifier: String {
        return String(describing: self)
    }
}


extension UICollectionView {
    func reloadData(success: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            success?()
        }
        reloadData()
        CATransaction.commit()
    }
}


enum InfiniteScrollStatus {
    case loading
    case finishedLoading
    case noData
}
