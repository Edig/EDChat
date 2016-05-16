# EDChat
Simple UI Chat Farmework -  SWIFT

Note: This is only a UIChat, does not include any server for it

## Installation

```ruby
pod "EDChat"
```

## Usage

##### *First Step*

Import the framework

```swift
import EDChat
```

##### *Second Step*

Subclass your `UIViewController` with `EDChatViewController`

Now you can run your view and it should work as a chat

##EDMessage
Object of EDMessage

```swift
var message: String!
var type: EDChatMessageType!
var isOutgoingMessage: Bool = false
```

## Configuration

All posible configuration and their default values

```swift 
// MARK: - Config Options
var defaultFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
var canSendEmptyMessages: Bool = false

//TextBar
var textBarBackground = UIColor.grayColor()
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
```

## Insert Messages
To insert a message you need to create an object called `EDChatMessage` and calling.

If you want to load the screen with messages, call ```insertMessage``` on ```viewDidLoad```

#### *Inserting new messages*

```swift 
self.insertMessage(message: EDChatMessage, andScrollToPosition scroll: Bool)
```

#### *Insert previous messages*

```swift
final func insertPreviousMessage(message: EDChatMessage)
```

## Customize Bubble
Beside ```EDChat``` has a default message view you can create your own view. ```EDChat``` will care about the size of the view with constraints, you only need to create your own internal constraints.

In any way you need to override this function
```swift
override func viewFromMessage(message: EDChatMessage) -> UIView
```

#### *Default Bubble*
To customize the default bubble you need to create an object ```EDChatView``` and this will care about the text based on the message you create
```swift
func viewFromMessage(message: EDChatMessage) -> UIView {
    return EDChatMessageView(message: message, withFont: self.defaultFont)
}
```

Posible configurations
```swift
var sendingMessageBackrgound = UIColor.blueColor()
var incomingMessageBackrgound = UIColor.grayColor()
var sendingMessageTextColor = UIColor.whiteColor()
var incomingMessageTextColor = UIColor.whiteColor()
```

#### *New Bubble*
You can create your own UIView by returning it on the overrided function

##### *Override Methods*

```swift
func messageWillSend(message: EDChatMessage) 
func messageDidSend(message: EDChatMessage)
func viewFromMessage(message: EDChatMessage) -> UIView
```
