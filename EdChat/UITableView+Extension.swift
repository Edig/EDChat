//
//  UITableView+Extension.swift
//  Eduardo Iglesias
//
//  Created by Eduardo Iglesias on 5/13/16.
//  Copyright © 2016 Eduardo Iglesias. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRowsInSection(section - 1)
            if row > 0 {
                self.scrollToRowAtIndexPath(NSIndexPath(forRow: row - 1, inSection: section - 1), atScrollPosition: .Bottom, animated: animated)
            }
        }
    }
}