//
//  main.swift
//  MentalHealthWeek
//
//  Created by Russell Gordon on 1/12/17.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation
var emptyArray : [[String]] = [[],[],[],[],[]] // Empty array to be used to initialize array of activities

//
// Define Globals.
//
let gradeChoiceNum = [27, 28, 28, 29] // Number of survey questions per grade
let activityChoiceOffset = 12 // Number of survey questions before the activity choices
var columnDescriptors : [String] = [] // An array for the column information
var titles : [String] = [] // An array to hold the titles
var students : [Student] = [] // An array of all the students
var activities : [Activity] = [ // An array of all the activities
    Activity(weekdays: emptyArray, shortName: "MathExam", name: "Math Exam", personCap: 500, supervisorName: "Mr. Fitz"),
    Activity(weekdays: emptyArray, shortName: "Sleep", name: "Sleep In", personCap: 500, supervisorName: "Mr. Fitz"),
    Activity(weekdays: emptyArray, shortName: "Breakfast", name: "Casual Breakfast", personCap: 160, supervisorName: "Ms. Totten"),
    Activity(weekdays: emptyArray, shortName: "Gym", name: "Physical Activity", personCap: 50, supervisorName: "Mr. T/ Mr. S"),
    Activity(weekdays: emptyArray, shortName: "Relaxation", name: "Relaxation", personCap: 160, supervisorName: "Fr. Donkin"),
    Activity(weekdays: emptyArray, shortName: "Academics", name: "Academic Management", personCap: 30, supervisorName: "Fr. D and NVH(Monday) KU (Wed-Fri) TH"),
    Activity(weekdays: emptyArray, shortName: "Yoga", name: "Yoga", personCap: 20, supervisorName: "Ms. McPhedran"),
    Activity(weekdays: emptyArray, shortName: "Animals", name: "Animal Therapy", personCap: 16, supervisorName: "Ms. Kaye/Fitz"),
    Activity(weekdays: emptyArray, shortName: "Massage", name: "Massage", personCap: 12, supervisorName: "Ms."),
]
var input = Input() // Initialize input class

// Open the input file
guard let reader = LineReader(path: "/Users/student/Desktop/github/MentalHealthWeek/survey_response_all_data_new_headers.csv") else {
    exit(0); // cannot open file
}

for (number, line) in reader.enumerated() // Go through the data and process each student
{
    if number == 0 // If we are processing the titles
    {
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        for (column, descriptor) in columnDescriptors.enumerated()
        {
            titles.append(descriptor) // Build descriptor lookup table
        }
    } else { // If we are processing a student
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        let student = input.getAndAssignStudent(data: columnDescriptors, titles: titles) // Get the student and assign them to the activity
        students.append(student) // Append the student to a list of students
    }
}
print(activities)
print(students)



//              .--~~,__
//:-....,-------`~~'._.'
//`-,,,  ,_      ; '~U'
//_,-' ,'`-__; '--.|
//(_/'~~      ''''(;)
//






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

    for i in 0...needChar { //add however many spaces are needed
        newChar.append(" ")
    }
    let newString = String(newChar)
    return newString
}

var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"] //just for printing out

guard let writer = LineWriter(path: "/Users/student/Desktop/MentalHealthWeekFinal/survey_output.txt", appending: false) else {
    print("Cannot open output file")
    exit(0); // cannot open output file
}
//allows for sorting by advisors
var advisorList : [String] = ["Bader Shaw","Beatty","Bibby","Chow","Darvasi","DeBlois","Doerksen","Donnelly","Enfield","Evans","Farrar","Fitz","Ghoreshy","Girvan","Gledhill","Grdon","Hart","Hutton","Kotecha","Lambersky","Newton","O'leary","Rankin","Seale","Spacie","Stevens","Totten", "Van Herk", "Vivares"]

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
        
        writer.write(line: "")
        writer.write(line: "______________________________" )
        writer.write(line: "")
        //prints names of supervisor and activity
        //print(activities[i].name)
        //print(activities[i].supervisorName)
       // print("")
        
        writer.write(line: "\(activities[i].name)")
        writer.write(line: "\(activities[i].supervisorName)")
        
        //prints all students and proper days of week
        for j in 0...4 {
            //print("")
            //print(week[j])
            //print("")
            writer.write(line: "")
            writer.write(line: "\(format(baseWord: week[j]))")
            
            if activities[i].weekdays[j].count-1 > 0 {
                for l in 0...activities[i].weekdays[j].count-1{
                    
                    //print(activities[i].weekdays[j][l])
                    
                    writer.write(line: "\(format(baseWord: activities[i].weekdays[j][l]))")
                    
                }
            }
        }
    }
}

superVisorList2()//for supervisor
indivdualTime() //for advisor

// Close the output file
writer.close() // MAKE NOTE OF THIS
