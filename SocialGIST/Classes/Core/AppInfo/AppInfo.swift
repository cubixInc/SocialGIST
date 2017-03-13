//
//  AppInfo.swift
//  GIST
//
//  Created by Shoaib Abdul on 29/04/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

class AppInfo: NSObject {
    
    static var bundleNumber:String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "";
        }
    } //P.E.
    
    static var versionNumber:String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "";
        }
    } //P.E.

    static var versionNBuildNumber:String {
        get {
            return "\(self.versionNumber) (\(self.bundleNumber))";
        }
    } //P.E.
    
    
    static var bundleIdentifier:String {
        get {
            return Bundle.main.bundleIdentifier ?? "";
        }
    } //P.E.

    /*
    +(NSString*) releaseDate
    {
    NSString* myString = [NSString stringWithUTF8String:__DATE__];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
    dateFormatter.dateFormat = @"MMM dd yyyy";
    NSDate *yourDate = [dateFormatter dateFromString:myString];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    return [dateFormatter stringFromDate:yourDate];
    }//F.E.
     */
    
} //CLS END
