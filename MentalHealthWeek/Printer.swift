//
//  Printer.swift
//  MentalHealthWeek
//
//  Created by Andy-E on 2017-01-27.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation


class Printer  {
    
    var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"] //just for printing out
    
    //allows for sorting by advisors
    var advisorList : [String] = ["Bader Shaw","Beatty","Bibby","Chow","Darvasi","DeBlois","Doerksen","Donnelly","Enfield","Evans","Farrar","Fitz","Ghoreshy","Girvan","Gledhill","Grdon","Hart","Hutton","Kotecha","Lambersky","Newton","O'leary","Rankin","Seale","Spacie","Stevens","Totten", "Van Herk", "Vivares"]
    
    var students : [Student] //going to hold the info from the stucts
    var activities : [Activity]
    
    var writer = LineWriter(path: "/Users/student/Desktop/MentalHealthWeekFinal/survey_output.txt", appending: false)! //got to have this to open writing process
    
    init (stu: [Student], act : [Activity]) {
        
        self.students = stu
        self.activities = act
        
    }
    
    
    func format (baseWord: String) -> String {
        //this funciton formats a string by adding up the charicters
        //then it adds space until is reachs the start amount to allow for proper formating
        let standardAmount = 20
        var needChar = 0
        var charAmount = 0
        var newChar = [Character]()
        
        for char in baseWord.characters { //counts how many charicter are in given string
            newChar.append(char)
            charAmount += 1
        }
        if (standardAmount > charAmount) { //detemines if extra spaces are needed
            needChar = standardAmount - charAmount
        }
        for _ in 0...needChar { //add however many spaces are needed
            newChar.append(" ")
        }
        return String(newChar)
        
    }
    
    
    func indivdualTime () { //this is for the advisors and students
        
        for name in advisorList {
            for i in 0...students.count-3 {
                //this only prints if in correct advisors thereby sorting the students into there advisors
                if name == students[i].advisor {
                    writer.write(line: "\(format(baseWord: students[i].email)) -> \(format(baseWord:  students[i].advisor))")
                    writer.write(line: "" )
                    
                    writer.write(line: "\(format(baseWord: week[0]))\(format(baseWord: week[1]))\(format(baseWord: week[2]))\(format(baseWord: week[3]))\(format(baseWord: week[4]))")
                    writer.write(line: "" )
                    //Here I simply acsess the structs in order print out the proper info
                    writer.write(line: "\(format(baseWord: students[i].activities[0]))\(format(baseWord: students[i].activities[1]))\(format(baseWord: students[i].activities[2]))\(format(baseWord: students[i].activities[3]))\(format(baseWord: students[i].activities[4]))")
                    writer.write(line: "" )
                    writer.write(line: "______________________________________________________________________________________________" )
                    writer.write(line: "" )
                }
            }
        }
    }
    
    
    func superVisorList2 (){ //This is for the activity supervisors
        for i in 1...activities.count-1 {
            
            //prints names of supervisor and activity
            writer.write(line: "")
            writer.write(line: "______________________________" )
            writer.write(line: "")
            
            
            writer.write(line: "\(activities[i].name)")
            writer.write(line: "\(activities[i].supervisorName)")
            
            //prints all students and proper days of week
            for j in 0...4 {
                
                writer.write(line: "")
                writer.write(line: "\(format(baseWord: week[j]))")
                
                if activities[i].weekdays[j].count-1 > 0 {
                    for l in 0...activities[i].weekdays[j].count-1{
                        writer.write(line: "\(format(baseWord: activities[i].weekdays[j][l]))")
                        
                    }
                }
            }
        }
    }
}



