//
//  ViewController.swift
//  Swipe Keyboard 1
//
//  Created by Vishal Agarwal on 11/02/16.
//  Copyright © 2016 Vishal Agarwal. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var myView: NSView!
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

    var xGap: CGFloat = 15.6
    var yGap: CGFloat = 15.6
    var keyWidth: CGFloat = 88.7
    var keyHeight: CGFloat = 87.2
    var edgeGapWidth: CGFloat = 0
    var secondRowLeadingGap: CGFloat = 0
    var swipeSymbolKeyWidth: CGFloat = 0
    var commaKeyWidth: CGFloat = 0
    var spacebarKeyWidth: CGFloat = 0
    
    let swipeKeyboardKeys: [String] = ["qwertyuiop~","asdfghjkl~","~zxcvbnm~~~","~~~~~~~"]
    
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

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func returnKeyValue(indexOfKeys: [Int]) -> Character
    {
        var currentRow = indexOfKeys[0] - 1
        var currentColumn = indexOfKeys[1] - 1
        if currentRow >= 0 && currentColumn >= 0 {
            var myKeyboardRow = swipeKeyboardKeys[currentRow]
            var index = myKeyboardRow.startIndex.advancedBy(currentColumn)
            var myKey = myKeyboardRow[index]
            return myKey
        }
        return "~"
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
            
            var indexOfKeys = returnCellPosition(xPos, yPoint: yPos)
            singleTappedCharacter = returnKeyValue(indexOfKeys)
        }
        
        if(touches.count == 3) {
            
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
        for( var currentRow = 4; currentRow >= 0; currentRow--) {
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
        var touches: NSSet = event.touchesMatchingPhase(NSTouchPhase.Touching, inView: myView)
        
        isTappingASingleCharacter = false
        
        if(touches.count == 3) {
            let initialPoint = myView.convertPointFromBacking(event.locationInWindow)
            let xPos = initialPoint.x
            let yPos = initialPoint.y
            
            var indexOfKeys = returnCellPosition(xPos, yPoint: yPos)
            var currentKey = returnKeyValue(indexOfKeys)
            characterAppend(currentKey)
            //            print(initialPoint)
        }
    }
    
    
    override func touchesEndedWithEvent(event: NSEvent) {
        if(isTappingASingleCharacter == true && noOfTouches == 1) {
            if singleTappedCharacter != "~"{
                print(singleTappedCharacter)
            }
            isTappingASingleCharacter = false
        }
        else if (!myString.isEmpty && noOfTouches == 3){
            print(myString)
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

