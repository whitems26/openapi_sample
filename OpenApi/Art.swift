//
//  Art.swift
//  OpenApi
//
//  Created by ktds 19 on 2017. 8. 31..
//  Copyright © 2017년 cjon. All rights reserved.
//

import Foundation
import UIKit

class Art {
    var title:String?
    var artist:String?
    var thumbImageUrl:String?
    var thumbImage:UIImage?
    
    init(title:String?, artist:String?, thumbImageUrl:String?) {
        self.title = title
        self.artist = artist
        self.thumbImageUrl = thumbImageUrl
        self.thumbImage = nil
    }
    
    
}
