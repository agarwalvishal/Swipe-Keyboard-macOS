//
//  wordInsertion.swift
//  Swipe Keyboard
//
//  Created by Vishal Agarwal on 10/05/16.
//  Copyright © 2016 Vishal Agarwal. All rights reserved.
//

import Foundation

class wordInsertion
{
    
    func getPath(word: String) -> String
    {
        
        let firstLetter = word[word.startIndex]
        let lastLetter = word[word.endIndex.predecessor()]
        var customPath = "/Users/vishal/Documents/Developer/Swipe Keyboard 1/Swipe Keyboard 1/WordList/"
        customPath.append(firstLetter)
        customPath.append(lastLetter)
        return customPath
        
    }
    
    
    func getWords(path :String) -> [String]
    {
        
        var wordList = [String]()
        do
        {
            let fileContents = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            wordList = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        }
        catch {}
        
        return wordList
        
    }
    
    func wordExists(wordList: [String], word: String) -> Bool {
        for eachWord in wordList {
            if eachWord == word {
                return true
            }
        }
        return false
    }
    
    func insertWord(word : String)
    {
        let path = getPath(word)
        
        var wordList = getWords(path)
        
        if wordExists(wordList, word: word) == false {
            wordList.append(word)
        }
        
        
        var outputString: String = ""
        for eachWord in wordList
        {
            if(eachWord == ""){
                continue
            }
            outputString = outputString + eachWord
            outputString = outputString + "\n"
        }
        
        // print(outputString)
        
        do
        {
            try outputString.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("File Writing Error")	
        }
    }
}

//var obj1 =  wordInsertion()
//obj1.insertWord("zaaaaz")