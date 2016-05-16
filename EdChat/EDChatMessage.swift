//
//  EDChatMessage.swift
//  Eduardo Iglesias
//
//  Created by Eduardo Iglesias on 5/12/16.
//  Copyright © 2016 Eduardo Iglesias. All rights reserved.
//

import UIKit

enum EDChatMessageType {
    case Text
    case Image
}

class EDChatMessage: NSObject {

    
    var message: String!
    var type: EDChatMessageType!
    var isOutgoingMessage: Bool = false
    
    init(withMessage message: String, withType type: EDChatMessageType, isOutgoingMessage: Bool) {
        self.message = message
        self.type = type
        self.isOutgoingMessage = isOutgoingMessage
    }
}
