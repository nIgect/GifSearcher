//
//  GifModel.swift
//  Gif Searcher
//
//  Copyright © 2018 Stas Taraseivch. All rights reserved.
//

import Foundation
import UIKit

class GifModel {
    
    var title : String
    var url : String
    var width : String
    var height : String
    var id: Int
    
    init(title: String, url: String, width: String, height: String, id: Int) {
        
        self.title = title
        self.url = url
        self.width = width
        self.height = height
        self.id = id
    }
}
