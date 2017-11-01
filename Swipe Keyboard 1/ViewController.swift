//
//  ViewController.swift
//  Swipe Keyboard 1
//
//  Created by Vishal Agarwal on 11/02/16.
//  Copyright © 2016 Vishal Agarwal. All rights reserved.
//

import Cocoa
import CoreGraphics

class ViewController: NSViewController {
    @IBOutlet var myView: NSView!
    @IBOutlet var Label1: NSTextField!
    @IBOutlet var Label2: NSTextField!
    @IBOutlet var Label3: NSTextField!
    @IBOutlet var myKeboardImage: NSImageView!
    var initialTouches = [NSTouch]()
    var currentTouches = [NSTouch]()
    var isTracking = true
    var endTrackingAction = true
    var beginTrackingAction = true
    var updateTrackingAction = true
    var threshold: CGFloat = 1
    var myViewWidth: CGFloat! = 0.0
    var myViewHeight: CGFloat! = 0.0
    var initialKey: Character = "~";
    var myString = ""
    var isTappingASingleCharacter = false
    var singleTappedCharacter: Character = "a"
    var noOfTouches = 0
    var singleTappedString: String = ""
    var isUppercase: Bool = false
    var isNumeric: Bool = false
    var isSymbol: Bool = false
    var indexOfKeysForKeyboardBehaviour: [Int] = [0,0]
    let editorPath = "/Users/vishal/Desktop/output.txt"
    var isPreviousSwipe: Bool = false
    var prevoiusSwipeWordCount: Int = 0
    
    var xGap: CGFloat = 15.6
    var yGap: CGFloat = 15.6
    var keyWidth: CGFloat = 88.7
    var keyHeight: CGFloat = 87.2
    var edgeGapWidth: CGFloat = 0
    var secondRowLeadingGap: CGFloat = 0
    var swipeSymbolKeyWidth: CGFloat = 0
    var commaKeyWidth: CGFloat = 0
    var spacebarKeyWidth: CGFloat = 0
    
    let swipeKeyboardKeys: [String] = ["~~~","qwertyuiop\u{8}","asdfghjkl\n","~zxcvbnm?!~","~~, .~~"]
    let swipeKeyboardNumericKeys: [String] = ["~~~","1234567890\u{8}","@$&_():;\"\n","~*-#=/+'?!~","~~, .~~"]
    let swipeKeyboardSymbolKeys: [String] = ["~~~","•™®`^¥op{}\u{8}","asdfghjkl\n","~zxcvbnm?!~","~~, .~~"]
    
    func initializeVariables() {
        xGap = 15.6 / 1198 * myViewWidth
        yGap = 15.6 / 483 * myViewHeight
        keyWidth = 88.7 / 1198 * myViewWidth
        keyHeight = 87.2 / 483 * myViewHeight
        edgeGapWidth = 6.5 / 1198 * myViewWidth
        secondRowLeadingGap = 57 / 1198 * myViewWidth
        swipeSymbolKeyWidth = 132 / 1198 * myViewWidth
        commaKeyWidth = 101 / 1198 * myViewWidth
        spacebarKeyWidth = 392 / 1198 * myViewWidth
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.acceptsTouchEvents = true
        //createCustomKeyboardEvent()
        // Do any additional setup after loading the view.
    }
    

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func returnKeyValue(indexOfKeys: [Int]) -> Character
    {
        let currentRow = indexOfKeys[0] //- 1
        let currentColumn = indexOfKeys[1] - 1
        if currentRow >= 0 && currentColumn >= 0 {
            var myKeyboardRow = swipeKeyboardKeys[currentRow]
            if isNumeric == true {
                myKeyboardRow = swipeKeyboardNumericKeys[currentRow]
            }
            if isSymbol == true {
                myKeyboardRow = swipeKeyboardSymbolKeys[currentRow]
            }
            let index = myKeyboardRow.startIndex.advancedBy(currentColumn)
            let myKey = myKeyboardRow[index]
            return myKey
        }
        return "~"
    }
    
    func changeKeyboardBehaviour(indexOfSpecialKey: [Int]) {
        
        if (indexOfSpecialKey[0] == 3 && indexOfSpecialKey[1] == 1) || (indexOfSpecialKey[0] == 3 && indexOfSpecialKey[1] == 11) {
            
            // Symbol keypad key is pressed
            
            if isNumeric == true && isSymbol == false {
                myKeboardImage.image = NSImage(named: "keyboardSymbol")
                isSymbol = true
            }
            else if isNumeric == true && isSymbol == true {
                myKeboardImage.image = NSImage(named: "keyboardNumeric")
                isSymbol = false
            }
                
            // Capslock key is pressed
                
            else {
                isSymbol = false
                if isUppercase == false {
                    myKeboardImage.image = NSImage(named: "keyboardCaps")
                    isUppercase = true
                }
                else {
                    myKeboardImage.image = NSImage(named: "keyboardSmall")
                    isUppercase = false
                }
            }
        }
        
        // Numeric keypad key is pressed
        
        if (indexOfSpecialKey[0] == 4 && indexOfSpecialKey[1] == 2) || (indexOfSpecialKey[0] == 4 && indexOfSpecialKey[1] == 6) {
            isUppercase = false
            isSymbol = false
            if isNumeric == false {
                myKeboardImage.image = NSImage(named: "keyboardNumeric")
                isNumeric = true
            }
            else {
                myKeboardImage.image = NSImage(named: "keyboardSmall")
                isNumeric = false
            }
        }
        
        // Word in suggestion box is selected
        
        if indexOfSpecialKey[0] == 0 && isPreviousSwipe == true{
            var toTextFileObj = ToTextFile()
            var wordString = toTextFileObj.getWords(editorPath)
            wordString = toTextFileObj.deleteLastWordFromTextFile(wordString, previousSwipeWordCount: prevoiusSwipeWordCount)
            if indexOfSpecialKey[1] == 1 && !Label1.stringValue.isEmpty {
                wordString = wordString + Label1.stringValue + " "
                toTextFileObj.insertWord(wordString, path : editorPath)
            }
            else if indexOfSpecialKey[1] == 2 && !Label2.stringValue.isEmpty {
                wordString = wordString + Label2.stringValue + " "
                toTextFileObj.insertWord(wordString, path : editorPath)
            }
            else if indexOfSpecialKey[1] == 3 && !Label3.stringValue.isEmpty {
                wordString = wordString + Label3.stringValue + " "
                toTextFileObj.insertWord(wordString, path : editorPath)
            }
            Label1.stringValue = ""
            Label2.stringValue = ""
            Label3.stringValue = ""
        }
    }
    
    override func touchesBeganWithEvent(event: NSEvent) {
        myString = ""
        initialKey = "~"
        myViewWidth = myView.bounds.width
        myViewHeight = myView.bounds.height
        
        initializeVariables()
        
        let touches: NSSet = event.touchesMatchingPhase(NSTouchPhase.Touching, inView: myView)
        let initialPoint = myView.convertPointFromBacking(event.locationInWindow)
        let xPos = initialPoint.x
        let yPos = initialPoint.y
        
        noOfTouches = touches.count
        if(touches.count == 1) {
            print(myViewHeight, myViewWidth)
            print("positions")
            print(xPos)
            print(yPos)
            isTappingASingleCharacter = true
            singleTappedCharacter = "~"
            
            let indexOfKeys = returnCellPosition(xPos, yPoint: yPos)
            indexOfKeysForKeyboardBehaviour = indexOfKeys
            singleTappedCharacter = returnKeyValue(indexOfKeys)
            
//            var myRect = NSRect(x: 0, y: 0, width: myViewWidth, height: myViewHeight)
//            
//            var path : NSBezierPath = NSBezierPath(rect: myRect)
//            let color = NSColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
//            color.set()
//            path.moveToPoint(NSPoint(x: xPos,y: yPos))
//            path.lineToPoint(NSPoint(x: 10,y: 10))
//            path.lineWidth = 5.0
//            path.stroke()
        }
        
        if(touches.count == 3) {
            
            singleTappedString = ""
            
            let array: NSArray = touches.allObjects
            
            initialTouches.append(array.objectAtIndex(0) as! NSTouch)
            initialTouches.append(array.objectAtIndex(1) as! NSTouch)
            currentTouches.append(initialTouches[0])
            currentTouches.append(initialTouches[1])
            
            //            print("positions")
            //            print(xPos);
            //            print(yPos);
            //            print("myVIewWidth & myViewHeight:")
            //            print(myViewWidth,myViewHeight)
            
            //            var currentKey = returnCellPosition(xPos, yPoint: yPos)
            //            characterAppend(currentKey)
        }
        else if(touches.count > 3) {
            if(isTracking) {
                cancelTracking()
            }
            else {
                releaseTouches()
            }
        }
    }
    
    func rowOneAndThree(xPoint: CGFloat) -> Int {
//        var keys: [Character] = ["q","w","e","r","t","y","u","i","o","p","\b"]
        var x  = edgeGapWidth
        for (var keyNumber = 1; keyNumber <= 10; keyNumber++) {
            if xPoint >= x && xPoint <= x + keyWidth {
                return keyNumber
            }
            x += keyWidth + xGap
        }
        if xPoint >= x && xPoint <= myViewWidth - edgeGapWidth {
            return 11
        }
        return 0
    }
    
    func rowTwo(xPoint: CGFloat) -> Int {
        var x  = secondRowLeadingGap
        for (var keyNumber = 1; keyNumber <= 9; keyNumber++) {
            if xPoint >= x && xPoint <= x + keyWidth {
                return keyNumber
            }
            x += keyWidth + xGap
        }
        if xPoint >= x && xPoint <= myViewWidth - edgeGapWidth {
            return 10
        }
        return 0
    }
    
    func rowFour(xPoint: CGFloat) -> Int {
        var x = edgeGapWidth
        if xPoint >= x && xPoint <= x + swipeSymbolKeyWidth {
            return 1
        }
        x += swipeSymbolKeyWidth + xGap
        if xPoint >= x && xPoint <= x + commaKeyWidth {
            return 2
        }
        x += commaKeyWidth + xGap
        if xPoint >= x && xPoint <= x + commaKeyWidth {
            return 3
        }
        x += commaKeyWidth + xGap
        if xPoint >= x && xPoint <= x + spacebarKeyWidth {
            return 4
        }
        x += spacebarKeyWidth + xGap
        if xPoint >= x && xPoint <= x + commaKeyWidth {
            return 5
        }
        x += commaKeyWidth + xGap
        if xPoint >= x && xPoint <= x + swipeSymbolKeyWidth {
            return 6
        }
        x += swipeSymbolKeyWidth + xGap
        if xPoint >= x && xPoint <= x + swipeSymbolKeyWidth {
            return 7
        }
        return 0
    }
    
    
    func rowSuggestionBox(xPoint: CGFloat) -> Int {
        var suggestionBoxSize = myViewWidth / 3
        var x: CGFloat = 0
        for (var keyNumber = 1; keyNumber <= 3; keyNumber++) {
            if xPoint >= x && xPoint <= x + suggestionBoxSize {
                return keyNumber
            }
            x += suggestionBoxSize
        }
        return 0
    }
    
    func returnCellPosition(xPoint: CGFloat, yPoint: CGFloat) -> [Int] {
        var y: CGFloat = 0.0 ;
        var myRow = -1, myColumn = -1;
        var indexOfKey: [Int] = [0,0]
        
        //determines row number
        for var currentRow = 4; currentRow >= 0; currentRow-- {
            if yPoint >= y && yPoint <= y+keyHeight {
                myRow = currentRow
                break
            }
            y = y + keyHeight + yGap
        }
        
        switch(myRow)
        {
            case 0: myColumn =  rowSuggestionBox(xPoint)
            case 1: myColumn =  rowOneAndThree(xPoint)
            case 2: myColumn =  rowTwo(xPoint)
            case 3: myColumn =  rowOneAndThree(xPoint)
            case 4: myColumn =  rowFour(xPoint)
            default: break
        }
        indexOfKey[0] = myRow
        indexOfKey[1] = myColumn
//            print("row \(myRow)")
//            print("column \(myColumn)")
        return indexOfKey
        
    }
    
    func characterAppend(currentKey: Character){
        if currentKey != initialKey {
            initialKey = currentKey
            if(initialKey != "~") {
                myString.append(initialKey)
            }
            print(myString)
            //            print(initialKey)
        }
    }
    
    func cancelTracking() {
        if(isTracking) {
            if(endTrackingAction){
                //                NSApp.sendAction(Selector(endTrackingAction), to: myView, from: self)
                isTracking = false
                releaseTouches()
            }
        }
    }
    
    func releaseTouches() {
        initialTouches.removeAll()
        currentTouches.removeAll()
    }
    
    override func touchesMovedWithEvent(event: NSEvent) {
        //        if (!self.isEnabled) {
        //            return
        //        }
        //        modifiers = event.modifierFlags
        let touches: NSSet = event.touchesMatchingPhase(NSTouchPhase.Touching, inView: myView)
        
        isTappingASingleCharacter = false
        
        if(touches.count == 3) {
            let initialPoint = myView.convertPointFromBacking(event.locationInWindow)
            let xPos = initialPoint.x
            let yPos = initialPoint.y
            
            let indexOfKeys = returnCellPosition(xPos, yPoint: yPos)
            let currentKey = returnKeyValue(indexOfKeys)
            characterAppend(currentKey)
            //            print(initialPoint)
        }
    }
    
    func updateLabel() {
        let obj = wordExtraction()
        var filteredWords:[String] = []
        filteredWords = obj.mainProcess(myString)
        Label1.stringValue = ""
        Label2.stringValue = ""
        Label3.stringValue = ""
        if isUppercase == false {
            if filteredWords.count >= 1 {
                Label1.stringValue = filteredWords[0]
            }
            if filteredWords.count >= 2 {
                Label2.stringValue = filteredWords[1]
            }
            if filteredWords.count >= 3 {
                Label3.stringValue = filteredWords[2]
            }
        }
        else if isUppercase == true {
            if filteredWords.count >= 1 {
                Label1.stringValue = filteredWords[0].uppercaseString
            }
            if filteredWords.count >= 2 {
                Label2.stringValue = filteredWords[1].uppercaseString
            }
            if filteredWords.count >= 3 {
                Label3.stringValue = filteredWords[2].uppercaseString
            }
        }
    }
    
    func isCharacterPunctuation(character: Character) -> Bool {
        
        if ((character >= "a" && character <= "z") || (character >= "A" && character <= "Z")){
            return false
        }
        return true
    }
    
    func appendSingleCharacterToTextFile(character: Character) {
        var toTextFileObj = ToTextFile()
        var wordString = toTextFileObj.getWords(editorPath)
        
        wordString.append(character)
        
        toTextFileObj.insertWord(wordString,path : editorPath)
    }
    
    override func touchesEndedWithEvent(event: NSEvent) {
        if(isTappingASingleCharacter == true && noOfTouches == 1) {
            if singleTappedCharacter != "~" {
                print(singleTappedCharacter)
                
                //backspace checking
                if singleTappedCharacter == "\u{8}" {
                    
                    // Backspace handling in Text File
                    
                    if isPreviousSwipe == true {
                        var toTextFileObj = ToTextFile()
                        var wordString = toTextFileObj.getWords(editorPath)
                        wordString = toTextFileObj.deleteLastWordFromTextFile(wordString, previousSwipeWordCount: prevoiusSwipeWordCount)
                        toTextFileObj.insertWord(wordString,path : editorPath)
                    }
                    else {
                        var toTextFileObj = ToTextFile()
                        var wordString = toTextFileObj.getWords(editorPath)
                        wordString = String(wordString.characters.dropLast())
                        toTextFileObj.insertWord(wordString,path : editorPath)
                    }
                    
                    // Backspace functioning in the label
                    
                    if singleTappedString.characters.count != 0 {
                        singleTappedString = String(singleTappedString.characters.dropLast())
                    }
                    Label1.stringValue = singleTappedString
                    Label2.stringValue = ""
                    Label3.stringValue = ""
                }
                else if isCharacterPunctuation(singleTappedCharacter) == false{
                    
                        if isUppercase == false {
                            singleTappedString.append(singleTappedCharacter)
                            appendSingleCharacterToTextFile(singleTappedCharacter)
                        }
                        else if isUppercase == true {
                            var tempString: String = ""
                            tempString.append(singleTappedCharacter)
                            tempString = tempString.uppercaseString
                            singleTappedString.append(tempString[tempString.startIndex])
                            appendSingleCharacterToTextFile(tempString[tempString.startIndex])
                        }
                    Label1.stringValue = singleTappedString
                    Label2.stringValue = ""
                    Label3.stringValue = ""
                }
                else {
                    let obj =  wordInsertion()
                    if singleTappedString.characters.count != 0 {
                        obj.insertWord(singleTappedString)
                    }
                    singleTappedString = ""
                    
                    // Append punctuation to the text file
                    var toTextFileObj = ToTextFile()
                    var wordString = toTextFileObj.getWords(editorPath)
                    if wordString[wordString.endIndex.predecessor()] == " " {
                        wordString = String(wordString.characters.dropLast())
                        wordString.append(singleTappedCharacter)
                        toTextFileObj.insertWord(wordString, path: editorPath)
                    }
                    else {
                        appendSingleCharacterToTextFile(singleTappedCharacter)
                    }
                }
            }
            else {
                changeKeyboardBehaviour(indexOfKeysForKeyboardBehaviour)
            }
            isTappingASingleCharacter = false
            isPreviousSwipe = false
        }
        else if (!myString.isEmpty && noOfTouches == 3){
            print(myString)
            updateLabel()
            var toTextFileObj = ToTextFile()
            var wordString = toTextFileObj.getWords(editorPath)
            
            if !Label1.stringValue.isEmpty{
                wordString = wordString + Label1.stringValue + " "
            }
            toTextFileObj.insertWord(wordString,path : editorPath)
            isPreviousSwipe = true
            prevoiusSwipeWordCount = Label1.stringValue.characters.count
        }
        noOfTouches = 0
    }
    
    func deltaOrigin() -> NSPoint {
        if (initialTouches.isEmpty && currentTouches.isEmpty) {
            return NSZeroPoint
        }
        let x1 = min(initialTouches[0].normalizedPosition.x, initialTouches[1].normalizedPosition.x)
        let x2 = min(currentTouches[0].normalizedPosition.x, currentTouches[1].normalizedPosition.x)
        let y1 = min(initialTouches[0].normalizedPosition.y, initialTouches[1].normalizedPosition.y)
        let y2 = min(currentTouches[0].normalizedPosition.y, currentTouches[1].normalizedPosition.y)
        let deviceSize = initialTouches[0].deviceSize
        var delta: NSPoint = CGPoint(x: 0.0, y: 0.0)
        delta.x = (x2 - x1) * deviceSize.width;
        delta.y = (y2 - y1) * deviceSize.height;
        return delta;
    }
}