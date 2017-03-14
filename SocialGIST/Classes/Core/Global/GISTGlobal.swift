//
//  GISTGlobal.swift
//  SocialGIST
//
//  Created by Shoaib Abdul on 14/03/2017.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit

public let GIST_GLOBAL = GISTGlobal.shared;

/// GISTGlobal is a singleton instance class to hold default shared data.
public class GISTGlobal: NSObject {
    static let shared = GISTGlobal();
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {} //C.E.
    
    var deviceToken:String?;
    
    var baseURL:URL!
    var apiURL:URL!
    
} //F.E.
