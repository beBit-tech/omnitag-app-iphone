//
//  MenuItem.swift
//  omnicha-ios
//
//  Created by Eason on 2019/11/26.
//  Copyright © 2019 Eason. All rights reserved.
//

import UIKit

struct MenuItem {
    let title: String
    let callback: () -> Void
    
    init(title: String, callback: @escaping () -> Void) {
        self.title = title
        self.callback = callback
    }
}
