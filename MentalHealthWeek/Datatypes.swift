//
//  Datatypes.swift
//  MentalHealthWeek
//
//  Created by Jeffrey on 2017-01-24.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation


struct Activity
{
    var weekdays : [[String]]
    var name : String
    var shortName : String
    var personCap : Int
    var supervisorName : String
    
    init(weekdays: [[String]], shortName: String, name: String, personCap: Int, supervisorName : String)
    {
        self.weekdays = weekdays
        self.name = name
        self.shortName = shortName
        self.personCap = personCap
        self.supervisorName = supervisorName
    }
}

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

struct Student
{
    var activities: [String]
    var email: String
    var advisor: String
    
    init(activities: [String], email: String, advisor: String)
    {
        self.activities = activities
        self.email = email
        self.advisor = advisor
    }
}
