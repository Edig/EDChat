//
//  EDChat.swift
//  Eduardo Iglesias
//
//  Created by Eduardo Iglesias on 5/12/16.
//  Copyright © 2016 Eduardo Iglesias. All rights reserved.
//


// NOTE: This is only chat UI, not server conections
//TODO:
/*
 
 - User is typing
 - incoming typing
 - failed message
 - Send images - !important
 - custom left button
 - re-try failed messages
 - Date Send - !important
 - Status -> sending message, message sended
 
 */

import UIKit

class EDChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, DynamicTextViewDelegate {

    private let tableView = UITableView()
    private var textField: DynamicTextView!
    private let textBar = UIView()
    private let sendBtn = UIButton(type: .Custom)
    
    private var _keyboardFrame: CGRect!
    private var keyboardIsOpen = false
    
    var messages = [EDChatMessage]()
    
    // MARK: - Config Options
    var defaultFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
    var canSendEmptyMessages: Bool = false
    
    //TextBar
    var textBarBackground = UIColor(rgba: "#333341")
    var textBarHeight:CGFloat = 50
    
    //TextField
    var textFieldPlaceholder = "Send Message"
    var textFieldBackground = UIColor.whiteColor()
    var textFieldCornerRadius:CGFloat = 5
    var textFieldLeftMargin: CGFloat = 8
    var textFieldTextFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
    
    //SendButton
    var sendButtonText = "Send"
    var sendButtonTextColor = UIColor.whiteColor()
    var sendButtonTextFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
    var sendButtonDisabledTextColor = UIColor.lightGrayColor()
    
    
    //Variable Constraints
    private var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - EDChat
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.tableView.bounces = false
        
        //Customize tableview
        self.tableView.separatorStyle = .None
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        self.tableView.keyboardDismissMode = .Interactive
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardWillShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardFrameDidChange(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnTableView(_:)))
        self.tableView.addGestureRecognizer(tap)
        
        
        //Set layout of the tableView
//        self.tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-self.textBarHeight)
        self.tableView.frame = CGRectMake(0, 0, 0, 0)

        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil, views: ["tableView": self.tableView]))

        //We need to add this kind of constrains instead of visual, so we can modify the constant
        let topConstraint = NSLayoutConstraint(item: self.tableView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0)
        tableViewBottomConstraint = NSLayoutConstraint(item: self.tableView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -self.textBarHeight)
        
        self.view.addConstraint(topConstraint)
        self.view.addConstraint(tableViewBottomConstraint)

        //We generate the textTextBar
        self.createTextBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Message
    final func insertMessage(message: EDChatMessage, andScrollToPosition scroll: Bool) {
        self.messages.append(message)
        let indexPath = NSIndexPath(forRow: self.messages.count-1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        if scroll {
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
        }
    }
    
    final func insertPreviousMessage(message: EDChatMessage) {
        self.messages.insert(message, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Text Toolbar
    final func createTextBar() {
        //self.view.frame.height-textBarHeight
        textBar.frame = CGRectMake(0, self.tableView.frame.height, self.view.frame.width, self.textBarHeight)
        textBar.backgroundColor = self.textBarBackground
        
        sendBtn.setTitle(self.sendButtonText, forState: .Normal)
        sendBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
        sendBtn.sizeToFit()
        sendBtn.frame = CGRectMake(textBar.frame.width-sendBtn.frame.width, 8, sendBtn.frame.width, textBarHeight-16)
        sendBtn.setTitleColor(self.sendButtonDisabledTextColor, forState: .Normal)
        sendBtn.titleLabel?.font = self.sendButtonTextFont
        sendBtn.addTarget(self, action: #selector(self.sendMessage), forControlEvents: .TouchUpInside)
        sendBtn.enabled = false
        
        //24 -> 16 separation in sendBtn + 8 separation from sendBTn
        // | -8- [textField] -8- [sendBtn] |
        self.textField = DynamicTextView(frame: CGRectMake(8, 8, textBar.frame.width-sendBtn.frame.width-8, textBarHeight-16))
        self.textField.backgroundColor = self.textFieldBackground
        self.textField.layer.cornerRadius = self.textFieldCornerRadius
        self.textField.font = self.textFieldTextFont
        self.textField.text = self.textFieldPlaceholder
        self.textField.textColor = UIColor.lightGrayColor()
        self.textField.dynamicDelegate = self
        self.textField.delegate = self
        
        textBar.addSubview(self.textField)
        textBar.addSubview(sendBtn)
        self.view.addSubview(self.textBar)
        
        self.textBar.translatesAutoresizingMaskIntoConstraints = false

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textBar]|", options: [], metrics: nil, views: ["textBar": self.textBar]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tableView][textBar(\(Int(self.textBarHeight)))]", options: [], metrics: nil, views: ["tableView": self.tableView, "textBar": self.textBar]))
        
    }
    
    
    final func sendMessage() {
        //Create message
        let message = EDChatMessage(withMessage: self.textField.text!, withType: .Text, isOutgoingMessage: true)
        self.messageWillSend(message)
        
        self.insertMessage(message, andScrollToPosition: true)
        
        
        sendBtn.setTitleColor(self.sendButtonDisabledTextColor, forState: .Normal)
        sendBtn.enabled = false
        self.textField.text = self.textFieldPlaceholder
        self.textField.textColor = UIColor.lightGrayColor()
        self.textField.selectedTextRange = self.textField.textRangeFromPosition(self.textField.beginningOfDocument, toPosition: self.textField.beginningOfDocument)

        
        self.messageDidSend(message)
    }
    
    // MARK: - Overridible
    
    // MARK: Message View
    func viewFromMessage(message: EDChatMessage) -> UIView {
        return EDChatMessageView(message: message, withFont: self.defaultFont)
    }
    
    // MARK: - UITableViewDataSource
    final func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    final func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    final func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let message = self.messages[indexPath.row]
        let cellView = self.viewFromMessage(message)
        
        cell.contentView.addSubview(cellView)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        if message.isOutgoingMessage {
            //To the right
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|->=80-[cellView]-16-|", options: [], metrics: nil, views: ["cellView": cellView]))
        }else{
            //To the left
            cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[cellView]->=80-|", options: [], metrics: nil, views: ["cellView": cellView]))
        }
        
        
        cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[cellView]-4-|", options: [], metrics: nil, views: ["cellView": cellView]))
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func didTapOnTableView(recognizer: UIGestureRecognizer) {
        self.textField.resignFirstResponder()
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let fingerLocation = scrollView.panGestureRecognizer.locationInView(scrollView)
        let absoluteFingerLocation = scrollView.convertPoint(fingerLocation, toView: self.view)
        
        if keyboardIsOpen && scrollView.panGestureRecognizer.state == .Changed && absoluteFingerLocation.y >= (self.view.frame.size.height - _keyboardFrame.size.height) {
            self.tableViewBottomConstraint.constant  =  (absoluteFingerLocation.y - self.view.frame.height) - self.textBar.frame.height
            print(self.view.frame.height)
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            //Disable sendButton
            
            sendBtn.setTitleColor(self.sendButtonDisabledTextColor, forState: .Normal)
            sendBtn.enabled = false
            
            textView.text = self.textFieldPlaceholder
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        //Enable only if the text its different from the place holder
        if textView.text != self.textFieldPlaceholder {
            //Enable sendButton
            sendBtn.setTitleColor(self.sendButtonTextColor, forState: .Normal)
            sendBtn.enabled = true
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
    
    // MARK: - Keyboard
    final func keyBoardWillShown(notif: NSNotification) {
        keyboardIsOpen = true
        let size: CGSize! = notif.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size
        let duration: Double! = notif.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) {
            Void in
            self.tableViewBottomConstraint.constant = -size.height-self.textBarHeight
            self.view.layoutIfNeeded()
            self.tableView.scrollToBottom()
        }
    }

    
    final func keyBoardWillHide(notif: NSNotification) {
        keyboardIsOpen = false
        UIView.animateWithDuration(0.3) {
            Void in
            self.tableViewBottomConstraint.constant = -self.textBarHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func keyBoardFrameDidChange (notif: NSNotification) {
        _keyboardFrame = notif.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
    }
    

    // MARK: - DynamicTextViewDelegate
    func dynamicTextViewDidResizeHeight(textview: DynamicTextView, height: CGFloat, previousHeight: CGFloat) {
        let difference = height - previousHeight
        
        self.textBar.frame = CGRectMake(0, self.textBar.frame.origin.y-difference, self.textBar.frame.width, height+16)
        self.sendBtn.frame = CGRectMake(self.textBar.frame.width-self.sendBtn.frame.width, self.textBar.frame.height-self.sendBtn.frame.height-8, self.sendBtn.frame.width, self.textBarHeight-16)
    }
    
    // MARK: - EDCHAT OVERRIDIBLE
    
    internal func messageWillSend(message: EDChatMessage) {
        
    }
    
    internal func messageDidSend(message: EDChatMessage) {
        
    }

}
