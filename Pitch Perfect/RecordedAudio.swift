//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Stratos Pavlakis on 10/11/15.
//  Copyright © 2015 Stratos Pavlakis. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String, url: NSURL) {
        self.title = title
        self.filePathUrl = url
    }
    
}
