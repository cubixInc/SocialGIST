//
//  UserPreferences.swift
//  QuranApp
//
//  Created by Shoaib on 9/16/15.
//  Copyright (c) 2015 Cubix. All rights reserved.
//

import UIKit

public class GISTUserPreferences: NSObject {
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    private override init() {
        
    }
    
    public class var user:User? {
        get {
            
            if let data: Data = UserDefaults.standard.object(forKey: "USER") as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? User;
            }
            
            return nil;
        }
        
        set {
            if let usr:User = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: usr);
                UserDefaults.standard.set(data, forKey: "USER");
                UserDefaults.standard.synchronize();
            }
        }
    } //P.E.
    
    func removeUserInfo(){
        UserDefaults.standard.removeObject(forKey: "USER")
    } //F.E.
    
} //CLS END

