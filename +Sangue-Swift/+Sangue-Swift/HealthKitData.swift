//
//  HealthKitData.swift
//  +Sangue-Swift
//
//  Created by Mariana Medeiro on 19/02/16.
//  Copyright © 2016 Mariana Medeiro. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitData: NSObject {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        let healthKitTypesToRead = Set(
            arrayLiteral: HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType)!,HKObjectType.characteristicTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.workoutType()
        )
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            completion(success:success,error:error)
        }
        
    }
    
    
    func returnSex() -> String{
        do{
            let sex = try healthKitStore.biologicalSex()
            switch (sex.biologicalSex){
                case HKBiologicalSex.Female: return "Feminino"
                case HKBiologicalSex.Male: return "Masculino"
                case HKBiologicalSex.NotSet: return "Não Definido"
                case HKBiologicalSex.Other: return "Outros"
                default: return "Não Definido"
            }
            
        }
        catch{
            return "Deu erro no HK"
        }
    }
    
    
    func returnBlood() -> String{
        do {
            
            let blood = try healthKitStore.bloodType()
            switch (blood.bloodType) {
                case HKBloodType.APositive: return "A+"
                case HKBloodType.ANegative: return "A-"
                case HKBloodType.BPositive: return "B+"
                case HKBloodType.BNegative: return "B-"
                case HKBloodType.OPositive: return "O+"
                case HKBloodType.ONegative: return "O-"
                case HKBloodType.ABPositive: return "AB+"
                case HKBloodType.ABNegative: return "AB-"
            default: return "-"
            }
        }
        catch {
            return "Deu erro no HK"
        }
    }
    
    func returnAge() -> String{
        let date = NSDate()
        do{
            let birthDay = try healthKitStore.dateOfBirth()
            let ageComponent = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: birthDay, toDate: date, options: NSCalendarOptions.WrapComponents)
            let userAge = ageComponent.year
            return "\(userAge) anos"
        }
        catch{
           return "Deu erro no HK"
        }
    }
}
