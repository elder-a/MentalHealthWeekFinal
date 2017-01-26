//
//  Input.swift
//  MentalHealthWeek
//
//  Created by Jeffrey on 2017-01-24.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation


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


let gradeChoiceLookup : [Int : Int] = [9 : 0, 10 : 27, 11 : 55, 12 : 83]
let weekdayLookup : [String : Int] = ["Monday" : 0, "Tuesday" : 1, "Wednesday" : 2, "Thursday" : 3, "Friday" : 4]


class Input
{
    //
    // Function to get a students information, and assign them to an activity in the process.
    //
    func getAndAssignStudent(data: [String], titles: [String]) -> Student
    {
        // Get grade
        guard let grade = Int(data[9]) else {
            print("Could not cast grade to integer.")
            exit(0)
        }
        
        let email = data[5] // Get student email
        let advisor = data[10] // Get student advisor
        
        return Student(activities: getStudentActivities(data: data, titles: titles, grade: grade, email: email), email: email, advisor: advisor) // Return student information
    }
    
    
    //
    // Function to parce the student information.
    //
    func getStudentActivities(data: [String], titles: [String], grade: Int, email: String) -> [String]
    {
        let gradeChoiceOffset = gradeChoiceNum[grade - 9] // An offset to get to the correct selection of survey choices
        let offset = gradeChoiceLookup[grade]! as Int
        
        var previousDayCharacter : Character = "M"
        var studentActivities : [String] = []
        var activityRankings : [String] = []
        var dayNames : [String] = []
        
        for i in 0...gradeChoiceOffset - 1 // Iterate over all of the survey choices
        {
            let currentChoiceIndex = activityChoiceOffset + offset + i // The current survey choice
            let currentDay = titles[currentChoiceIndex] // Get the current title
            let currentDayCharacter = currentDay[currentDay.startIndex] // Isolate the first character (the character that shows the day)
            
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
                
                // Process rankings
                for ranking in 1...8 // For every possible ranking...
                {
                    if let currentRankingIndex = activityRankings.index(of: String(ranking)) // Find the activity the student put as n ranking
                    {
                        let currentFullActivityName = dayNames[currentRankingIndex] // Find the corresponding fullname to that ranking
                        let currentActivityName = getActivityName(whole: currentFullActivityName) // Find the name of that activity
                        let currentActivityWeekday = getActivityDay(whole: currentFullActivityName) // Find the day of that activity
                        
                        if let weekdayIndex = weekdayLookup[currentActivityWeekday] // Using the current day name, find out the corresponding index
                        {
                            if let currentActivity = activities.filter({$0.shortName == currentActivityName }).first // Find the activity corresponding to the one we want
                            {
                                studentActivities.append(currentActivity.name) // Append the activity name
                                assignStudent(currentActivity: currentActivity, weekdayIndex: weekdayIndex, email: email) // Assign the student to that activity
                            }
                        }
                    }
                }
                
                dayNames = [] // Reset values
                activityRankings = []
            }
            
            if let activityRank = String(columnDescriptors[currentChoiceIndex]) // Build up a list of the student's activity rankings and the current day
            {
                activityRankings.append(activityRank)
                dayNames.append(currentDay)
            }
            
            previousDayCharacter = currentDayCharacter // Set lagging value of the current day character
        }
        
        return studentActivities // Return the student information
    }
    
    
    //
    // Function to assign the student to a given activity.
    //
    func assignStudent(currentActivity: Activity, weekdayIndex: Int, email: String) // Add a student to the activity they are in
    {
        if (currentActivity.weekdays[weekdayIndex].count < currentActivity.personCap) // If it's not already filled...
        {
            if let activityIndex = activities.index(of: currentActivity) // Find the index of the activity we want
            {
                activities[activityIndex].weekdays[weekdayIndex].append(email) // Append the name of the student to the activity that they are in
            }
        }
    }
}
