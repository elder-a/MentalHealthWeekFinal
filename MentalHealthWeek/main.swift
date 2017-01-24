//
//  main.swift
//  MentalHealthWeek
//
//  Created by Russell Gordon on 1/12/17.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation


//
// Define Globals.
//
let gradeChoiceLookup : [Int : Int] = [9 : 0, 10 : 27, 11 : 55, 12 : 83]
let gradeChoiceNum = [27, 28, 28, 29] // 27, 28, 28, 29
let activityChoiceOffset = 12
var columnDescriptors : [String] = []
var descriptorLookup : [String] = []
var emptyArray : [[String]] = [[],[],[],[],[]]
var students : [Student] = []
var activities : [Activity] = [
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
var weekdayLookup : [String : Int] = ["Monday" : 0, "Tuesday" : 1, "Wednesday" : 2, "Thursday" : 3, "Friday" : 4]


// Read the text file (place in your home folder)
// Path will probably be /Users/student/survey_response_sample.txt
// Obtain the data file on Haiku, Day 37
guard let reader = LineReader(path: "/Users/student/Desktop/MentalHealthWeekFinal/survey_response_all_data_new_headers.csv") else {
    exit(0); // cannot open file
}


//
// A function to parse the activity full name into the activity name.
//
func getActivityName (whole: String) -> String  {
    var switchNow = 0
    var charSetup = [Character]()
    var output = ""
    for char in whole.characters {
        if switchNow == 2 {
            charSetup.append(char)
            
        }
        
        if char == "_" {
            switchNow += 1
        }
    }
    output = String(charSetup)
    return output
}


//
// A function to parse the activity full name into the activitiy week day.
//
func getActivityDay (whole: String) -> String  {
    var charSetup = [Character]()
    var output = ""
    for char in whole.characters {
        if char == "_" {
            output = String(charSetup)
            return output
        }
        charSetup.append(char)
    }
    return output
}


for (number, line) in reader.enumerated()
{
    if number == 0
    {
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        for (column, descriptor) in columnDescriptors.enumerated()
        {
            descriptorLookup.append(descriptor) // Build descriptor lookup table
        }
    } else {
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        var studentEmail = columnDescriptors[5]
        var studentGrade = columnDescriptors[9]
        var studentAdvisor = columnDescriptors[10]
        var studentActivities : [String] = []
        
        
        if let studentGradeInt = Int(studentGrade)
        {
            let index = studentGradeInt - 9
            let gradeChoiceOffset = gradeChoiceNum[index] // An offset to get to the correct selection of survey choices
            var offset = gradeChoiceLookup[studentGradeInt]! as Int
            
            var previousDayCharacter : Character = "M"
            var activityRankings : [String] = []
            var dayNames : [String] = []
            
            for i in 0...gradeChoiceOffset - 1 // Iterate of all of the survey choices
            {
                let currentChoiceIndex = activityChoiceOffset + offset + i
                //var currentChoice = columnDescriptors[currentChoiceIndex]
                
                let currentDay = descriptorLookup[currentChoiceIndex]
                
                let currentDayCharacter = currentDay[currentDay.startIndex]
                
                if (currentDayCharacter != previousDayCharacter || i == gradeChoiceOffset - 1)
                {
                    if (i == gradeChoiceOffset - 1)
                    {
                        if let activityRank = String(columnDescriptors[currentChoiceIndex])
                        {
                            activityRankings.append(activityRank)
                            dayNames.append(currentDay)
                        }
                    }
                    
                    for ranking in 1...8
                    {
                        if let currentRankingIndex = activityRankings.index(of: String(ranking))
                        {
                            let currentFullActivityName = dayNames[currentRankingIndex]
                            let currentActivityName = getActivityName(whole: currentFullActivityName)
                            let currentActivityWeekday = getActivityDay(whole: currentFullActivityName)
                            if let weekdayIndex = weekdayLookup[currentActivityWeekday]
                            {
                                if var currentActivity = activities.filter({$0.shortName == currentActivityName }).first
                                {
                                    if (currentActivity.weekdays[weekdayIndex].count < currentActivity.personCap)
                                    {
                                        if let activityIndex = activities.index(of: currentActivity)
                                        {
                                            activities[activityIndex].weekdays[weekdayIndex].append(studentEmail)
                                            studentActivities.append(currentActivity.name)
                                            
                                            break
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    dayNames = []
                    activityRankings = []
                }
                
                if let activityRank = String(columnDescriptors[currentChoiceIndex])
                {
                    activityRankings.append(activityRank)
                    dayNames.append(currentDay)
                }
                
                previousDayCharacter = currentDayCharacter
            }
            
            students.append(Student(activities: studentActivities, email: studentEmail, advisor: studentAdvisor))
        }
    }
}
//print(activities)
//print(students)

//___oo#:#o__
//o##########o###-
//####o#~:~#~#####:~o______________
//#####o~ -- ~  ~~~~ ~            ~~--_   _o---~- -o
//~-##~_~-__                           ~-~::######oo:o
//~~##-~~ ~   _oooooo___        o_____    ~ ~~~#~##~o_
//_~~~~     _o##############__  _########o_      #~~~####
//o~         o#####~~~~~~#####~~ #############o    ~-###_~o
//#o       _####_~  _ooo#o###:   ########~~:###:_   ~####~
//o~        #o####_o_######~#o#    #######-  ~-##_##~#--~
//#         ###########~~~~:::~     ~######    #######_
//#          #######:~~~ ~########o_  ######o_o########
//#          -~~~~~~~     ~########~ _#################
//~_            _         ~~#~~~ ~ -#~################
//~_        _  ~-__       o~        ~~###########~#-
//~o_  -_  #      ~~~~---#              ~~~-~~:_~~
//_oo_~-_:~~~o             ~o_          ____--~ ~~#__    ____
//#####o#_-~-~#o #_o---          :#::~#--##~--ooo_o_o###~:    ~~_
//######:o-    ~#_ ~##o_      __-~~####oo_~~~~-_:~ ##o_   ~~o_o-~~
//######~~~      ~o:~~###o--~~      ~~~####oo_  ~~  ~###  ##o~~-_


func format (baseWord: String) -> String {
    
    let standardAmount = 20
    var needChar = 0
    var charAmount = 0
    var newChar = [Character]()
    
    for char in baseWord.characters {
        newChar.append(char)
        charAmount += 1
    }
    if (standardAmount > charAmount) {
        needChar = standardAmount - charAmount
    }
    for _ in 0...needChar {
        newChar.append(" ")
    }
    let newString = String(newChar)
    return newString
}


var week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]

guard let writer = LineWriter(path: "/Users/student/Desktop/MentalHealthWeekFinal/survey_output.txt", appending: false) else {
    print("Cannot open output file")
    exit(0); // cannot open output file
}

func indivdualTime () {
    //var activites : [String] =
    for i in 0...students.count-3 {
        //if
        writer.write(line: "\(format(baseWord: students[i].email)) -> \(format(baseWord:  students[i].advisor))")
        writer.write(line: "" )
        
        writer.write(line: "\(format(baseWord: week[0]))\(format(baseWord: week[1]))\(format(baseWord: week[2]))\(format(baseWord: week[3]))\(format(baseWord: week[4]))")
        writer.write(line: "" )
        
        writer.write(line: "\(format(baseWord: students[i].activities[0]))\(format(baseWord: students[i].activities[1]))\(format(baseWord: students[i].activities[2]))\(format(baseWord: students[i].activities[3]))\(format(baseWord: students[i].activities[4]))")
        writer.write(line: "" )
        writer.write(line: "______________________________________________________________________________________________" )
        writer.write(line: "" )
    }
}


func superVisorList2 (){
    for i in 1...activities.count-1 {
        
        writer.write(line: "")
        writer.write(line: "______________________________" )
        writer.write(line: "")
        
        print(activities[i].name)
        print(activities[i].supervisorName)
        print("")
        
        writer.write(line: "\(activities[i].name)")
        writer.write(line: "\(activities[i].supervisorName)")
        
        for j in 0...4 {
            print("")
            print(week[j])
            print("")
            writer.write(line: "")
            writer.write(line: "\(format(baseWord: week[j]))")
            
            if activities[i].weekdays[j].count-1 > 0 {
                for l in 0...activities[i].weekdays[j].count-1{
                    
                    print(activities[i].weekdays[j][l])
                    
                    writer.write(line: "\(format(baseWord: activities[i].weekdays[j][l]))")

                }
            }
        }
    }

}


superVisorList2()
//indivdualTime()

// Close the output file
writer.close() // MAKE NOTE OF THIS






