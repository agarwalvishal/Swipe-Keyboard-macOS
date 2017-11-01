//
//  ToTextFile.swift
//  Swipe Keyboard
//
//  Created by Vishal Agarwal on 12/05/16.
//  Copyright © 2016 Vishal Agarwal. All rights reserved.
//

import Foundation


class ToTextFile
{
    func getWords(path :String) -> String
    {
        var fileContents : NSString = ""
        var wordList = [String]()
        do
        {
            fileContents = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            wordList = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        }
        catch {}
        var outputString: String = ""
        for eachWord in wordList
        {
            if(eachWord == ""){
                continue
            }
            outputString = outputString + eachWord
            outputString = outputString + "\n"
        }
        if !wordList.isEmpty {
            outputString = String(outputString.characters.dropLast())
        }
        outputString = fileContents as String
        return outputString
    }
    func insertWord(outputString : String, path : String)
    {
        do
        {
            try outputString.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("File Writing Error")
        }
    }
    
    func isCharacterPunctuation(character: Character) -> Bool {
        
        if ((character >= "a" && character <= "z") || (character >= "A" && character <= "Z")){
            return false
        }
        return true
    }
    
    func deleteLastWordFromTextFile(outputString: String, previousSwipeWordCount: Int) -> String {
        var editedOutputString = String(outputString.characters.dropLast())
        var count = previousSwipeWordCount
        while editedOutputString.characters.count > 0 && isCharacterPunctuation(editedOutputString[editedOutputString.endIndex.predecessor()]) == false && count > 0{
            editedOutputString = String(editedOutputString.characters.dropLast())
            count -= 1
        }
        return editedOutputString
    }
}