//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Nekki T on 2015/07/31.
//  Copyright (c) 2015年 next3. All rights reserved.
//

import Foundation
class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }

}
