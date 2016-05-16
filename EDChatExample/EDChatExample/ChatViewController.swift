//
//  ChatViewController.swift
//  EDChatExample
//
//  Created by Eduardo Iglesias on 5/16/16.
//  Copyright © 2016 Eduardo Iglesias. All rights reserved.
//

import UIKit

class ChatViewController: EDChatViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Create messages
        
        for i in 1...20 {
            if i%2 == 0 {
                let message = EDChatMessage(withMessage: "Test Outgoing", withType: .Text, isOutgoingMessage: true)
                self.insertPreviousMessage(message)
            }else{
                let message = EDChatMessage(withMessage: "Test Incoming", withType: .Text, isOutgoingMessage: false)
                self.insertPreviousMessage(message)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func messageDidSend(message: EDChatMessage) {
        print("Message did send with text: \(message.message)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
