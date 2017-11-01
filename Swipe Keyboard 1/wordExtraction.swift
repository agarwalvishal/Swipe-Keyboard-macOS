//
//  wordExtraction.swift
//  Swipe Keyboard
//
//  Created by Vishal Agarwal on 10/05/16.
//  Copyright © 2016 Vishal Agarwal. All rights reserved.
//

import Foundation
import CoreFoundation

class wordExtraction
{
    //   Execution time of the code
    //
    //   class ParkBenchTimer {
    //
    //        let startTime:CFAbsoluteTime
    //        var endTime:CFAbsoluteTime?
    //
    //        init() {
    //            startTime = CFAbsoluteTimeGetCurrent()
    //        }
    //
    //        func stop() -> CFAbsoluteTime {
    //            endTime = CFAbsoluteTimeGetCurrent()
    //
    //            return duration!
    //        }
    //
    //        var duration:CFAbsoluteTime? {
    //            if let endTime = endTime {
    //                return endTime - startTime
    //            } else {
    //                return nil
    //            }
    //        }
    //    }
    
    let path = "words.txt";
    var myWords = [String]()
    
    func readFromFile() {
        do {
            let fileContents = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            myWords = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            // print(myWords)
        }
        catch {
            
            /* error handling here */}
    }
    
    
    func readSpecificWordsFromFile(inputPattern : String) {
        
        var firstLetter = inputPattern[inputPattern.startIndex]
        var lastLetter = inputPattern[inputPattern.endIndex.predecessor()]
        
        
        var customPath = "/Users/vishal/Documents/Developer/Swipe Keyboard 1/Swipe Keyboard 1/WordList/"
        customPath.append(firstLetter)
        customPath.append(lastLetter)
        
        print("CustomPath \(customPath)")
        
        do {
            let fileContents = try NSString(contentsOfFile: customPath, encoding: NSUTF8StringEncoding)
            myWords = fileContents.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            // print(myWords)
        }
        catch {
            print(error,"Error Reading from Dictionary!")
            /* error handling here */
        }
        
        print(myWords)
    }
    
    func input() -> NSString {
        //let keyboard = NSFileHandle.fileHandleWithStandardInput()
        //let inputData = keyboard.availableData
        //return NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
        
        var inputData = readLine()
        var tmp : NSString = (NSString(string : inputData!))
        return tmp
    }
    
    
    
    // functions returns the row of a particular character
    // if the character is not present it returns -1.
    func getRowNumber(letter: Character ) -> Int {
        let keyboardRows = ["qwertyuiop","asdfghjkl","zxcvbnm"]
        for (var currentRowNumber = 0 ; currentRowNumber < 3 ; currentRowNumber+=1) {
            for eachLetter in keyboardRows[currentRowNumber].characters {
                if letter == eachLetter {
                    return currentRowNumber
                }
            }
        }
        return -1
    }
    
    
    func findSignificantLetters(inputPattern: String) -> [Int] {
        var significantLetters = [Int]()
        var rowNumber = [Int]()
        for index in inputPattern.characters.indices {
            rowNumber.append(getRowNumber(inputPattern[index]))
        }
        
        print(rowNumber)
        var pos = 0
        for index in inputPattern.characters.indices {
            if index == inputPattern.startIndex || index == inputPattern.endIndex.predecessor() {
                significantLetters.append(0)
                pos += 1
                continue
            }
            else if inputPattern[index.predecessor()] == inputPattern[index.successor()] {
                significantLetters.append(1)
            }
            else if rowNumber[pos - 1] == rowNumber[pos + 1] && rowNumber[pos] != rowNumber[pos + 1]{
                significantLetters.append(1)
            }
            else {
                significantLetters.append(0)
            }
            pos += 1
        }
        print("significant ")
        print(significantLetters)
        return significantLetters
    }
    
    func getMinimumWordLength(inputPattern: String) -> Int {
        let keyboardRows = ["qwertyuiop","asdfghjkl","zxcvbnm"]
        var previousRowNumber = -1;
        var count = 0
        var flag = 0
        for letter in inputPattern.characters {
            var currentRowNumber = getRowNumber(letter)
            if currentRowNumber != previousRowNumber {
                previousRowNumber = currentRowNumber
                count+=1
                flag = 1
            }
        }
        return count - 1
    }
    
    func filterWordsBasedOnFirstAndLastLetter(inputPattern: String) -> [String]{
        var firstLetter = inputPattern[inputPattern.startIndex]
        var lastLetter = inputPattern[inputPattern.endIndex.predecessor()]
        var filteredWords = [String]()
        for word in myWords {
            if  word.characters.count == 0 {
                continue
            }
            if word[word.startIndex] == firstLetter && word[word.endIndex.predecessor()] == lastLetter {
                filteredWords.append(word)
            }
        }
        return filteredWords
    }
    
    func filterWordsBasedOnSubsequence(oldFilteredWords: [String], _ inputPattern: String, _ significantLetters: [Int]) -> [String]
    {
        var filteredWords = [String]()
        for word in oldFilteredWords {
            var i = inputPattern.startIndex
            var j = word.startIndex
            var k = 0
            while( i != inputPattern.endIndex && j != word.endIndex ) {
                if inputPattern[i] == word[j] {
                    j = j.successor()
                    if j != word.endIndex && word[j.predecessor()] == word[j] {
                        j = j.successor()
                    }
                }
                else if significantLetters[k] == 1 {
                    break
                }
                i = i.successor()
                k += 1
            }
            if( j == word.endIndex && i == inputPattern.endIndex) {
                filteredWords.append(word)
            }
        }
        return filteredWords
    }
    
    func compareRowNumberSubsequences(wordRowNumber : [Int], _ patternRowNumber : [Int]) -> Bool {
        // check whether patternRowNumber is a subsequence of wordRowNumber
        
        var wordIndex = 0
        
        for num in patternRowNumber {
            //print("\(num)  \(wordRowNumber[wordIndex])")
            if( num == wordRowNumber[wordIndex]) {
                wordIndex++
            }
            if(wordIndex == wordRowNumber.count) {
                break
            }
        }
        
        if(wordIndex < wordRowNumber.count) {
            return false
        }
        return true
        
    }
    
    
    func filterWordsBasedOnSignificantRows(oldFilteredWords: [String], _ inputPattern :String) -> [String] {
        var filteredWords = [String]()
        
        // get row number
        var rowNumber = [Int]()
        for index in inputPattern.characters.indices {
            rowNumber.append(getRowNumber(inputPattern[index]))
        }
        
        
        
        //Remove repetitions from rowNumber and store in rowNumberTemp
        
        var rowNumberTemp = [Int]()
        //print(rowNumber)
        
        rowNumberTemp.append(rowNumber[0])
        
        for var i = 1; i < rowNumber.count; i++ {
            if(rowNumber[i] != rowNumber[i-1]) {
                rowNumberTemp.append(rowNumber[i])
            }
        }
        //print(rowNumberTemp)
        
        
        // remove insignificant rows from rowNumberTemp
        
        rowNumber = []
        rowNumber.append(rowNumberTemp[0])
        
        for var i = 1; i < rowNumberTemp.count - 1; i++ {
            if rowNumberTemp[i-1] == rowNumberTemp[i+1] {
                rowNumber.append(rowNumberTemp[i])
            }
        }
        
        rowNumber.append(rowNumberTemp[rowNumberTemp.count - 1])
        
        //print("RowNumber: \(rowNumber)")
        
        
        for eachword in oldFilteredWords {
            var wordRowNumber = [Int]()
            for letter in eachword.characters {
                wordRowNumber.append(getRowNumber(letter))
            }
            
            //print(wordRowNumber)
            
            // check whether rownumber  is subsequence of wordRowNumber
            
            if compareRowNumberSubsequences(rowNumber,wordRowNumber) == true {
                filteredWords.append(eachword)
            }
        }
        return filteredWords
    }
    
    
    
    func filterWordsBasedOnMinimumWordLength(oldFilteredWords: [String], _ minimumWordLength: Int) -> [String]{
        var filteredWords = [String]()
        for word in oldFilteredWords {
            if word.characters.count >= 1 {//minimumWordLength {
                filteredWords.append(word)
            }
        }
        return filteredWords
    }
    
    func determinePriority(oldFilteredWords: [String]) -> [String] {
        var filteredWords = oldFilteredWords
        
        for( var i = 0 ; i < filteredWords.count ; i++) {
            var minimum = i;
            for( var j = i + 1 ; j < filteredWords.count ; j+=1) {
                if( filteredWords[j].characters.count > filteredWords[minimum].characters.count ) {
                    minimum = j
                }
                print(j)
            }
            //swapping
            
            var tmpWord = filteredWords[minimum]
            filteredWords[minimum] = filteredWords[i]
            filteredWords[i] = tmpWord
        }
        
        return filteredWords
    }
    
    
    //func sortDictionary() {
    //    for(var i = 97 ; i <= 122 ; i+=1) {
    //        for(var j = 97 ; j <= 122 ; j+=1) {
    //            for word in myWords {
    //                if word[word.startIndex] == (Character(UnicodeScalar(i))) && word[word.endIndex.predecessor()] == (Character(UnicodeScalar(j))) {
    //                    print(word)
    //                }
    //            }
    //        }
    //    }
    //}
    
    //readFromFile()
    
    func mainProcess(inputPattern:String) -> [String] {
        //        let timer = ParkBenchTimer()
        
        readSpecificWordsFromFile(inputPattern)
        
        // inputPattern.removeAtIndex(inputPattern.endIndex.predecessor())
        
        print(inputPattern)
        
        var significantLetters = findSignificantLetters(inputPattern)
        print(significantLetters)
        
        var minimumWordLength = getMinimumWordLength(inputPattern)
        print("minimum word length : \(minimumWordLength)")
        
        
        var filteredWords = filterWordsBasedOnFirstAndLastLetter(inputPattern)
        
        print("FIRST AND LAST LETTER:\n\(filteredWords)")
        
        filteredWords = filterWordsBasedOnSubsequence(filteredWords, inputPattern, significantLetters)
        
        print("SUBSEQUENCE:\n\(filteredWords)")
        
        filteredWords = filterWordsBasedOnMinimumWordLength(filteredWords, minimumWordLength)
        
        print(filteredWords)
        
        filteredWords =  filterWordsBasedOnSignificantRows(filteredWords,inputPattern)
        
        filteredWords = determinePriority(filteredWords)
        
        return filteredWords
        //        print(filteredWords)
        
        //        print("\nThe task took \(timer.stop()) seconds.")
    }
}

//var obj = wordExtraction()
//obj.mainProcess()
