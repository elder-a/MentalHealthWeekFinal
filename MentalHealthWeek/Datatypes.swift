//
//  Datatypes.swift
//  MentalHealthWeek
//
//  Created by Jeffrey on 2017-01-24.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation


//
// Stuct to model an activity
//
struct Activity
{
    var weekdays : [[String]] // List of students for each weekday
    var name : String // Full name of the activity
    var shortName : String // Short name of the activity
    var personCap : Int // Number of people that the activity can hold
    var supervisorName : String // Name of the teacher that is supervising this activity
    
    // Initialize struct
    init(weekdays: [[String]], shortName: String, name: String, personCap: Int, supervisorName : String)
    {
        self.weekdays = weekdays
        self.name = name
        self.shortName = shortName
        self.personCap = personCap
        self.supervisorName = supervisorName
    }
}


//
// Extension to assist in indexing the global array of activities.
//
extension Activity: Equatable
{
    static func == (lhs: Activity, rhs: Activity) -> Bool
    {
        return
            lhs.name == rhs.name &&
                lhs.shortName == rhs.shortName &&
                lhs.personCap == rhs.personCap &&
                lhs.supervisorName == rhs.supervisorName
    }
}


//
// Struct to model a student.
//
struct Student
{
    var activities: [String] // The names of every activity the student is in for the week
    var email: String // The email of the student
    var advisor: String // The advisor of the student
    
    // Initialize struct
    init(activities: [String], email: String, advisor: String)
    {
        self.activities = activities
        self.email = email
        self.advisor = advisor
    }
}
