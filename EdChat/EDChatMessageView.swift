//
//  EDChatMessageView.swift
//  Eduardo Iglesias
//
//  Created by Eduardo Iglesias on 5/12/16.
//  Copyright © 2016 Eduardo Iglesias. All rights reserved.
//

import UIKit

class EDChatMessageView: UIView {
    
    private var message: EDChatMessage!
    
    //Configuration
    var font: UIFont!
    var sendingMessageBackrgound = UIColor.blueColor()
    var incomingMessageBackrgound = UIColor.grayColor()
    var sendingMessageTextColor = UIColor.whiteColor()
    var incomingMessageTextColor = UIColor.whiteColor()
    
    init(message: EDChatMessage, withFont font: UIFont) {
        super.init(frame: CGRectZero)
        self.message = message
        self.font = font
        
        if self.message.isOutgoingMessage {
            self.backgroundColor = self.sendingMessageBackrgound
        }else{
            self.backgroundColor = self.incomingMessageBackrgound
        }
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.didTapOnBubble(_:)))
        self.addGestureRecognizer(tap)
        
        self.initBubble()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initBubble() {
        
        self.layer.cornerRadius = 5
        
        let label = UILabel()
        label.text = self.message.message
        label.font = self.font
        label.numberOfLines = 0
        
        
        if self.message.isOutgoingMessage {
            label.textColor = self.sendingMessageTextColor
        }else{
            label.textColor = self.incomingMessageTextColor
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: ["label": label]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-|", options: [], metrics: nil, views: ["label": label]))
    }
    
    
    
    func didTapOnBubble(recognizer: UIGestureRecognizer) {
        if recognizer.state == .Began {
            print("Tap")
            //Todo: copy
        }
    }
}
