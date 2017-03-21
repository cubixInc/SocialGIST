//
//  FBConnect.swift
//  eGrocery
//
//  Created by Shoaib on 3/20/15.
//  Copyright (c) 2015 cubixlabs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

public var FB_CONNECT:FBConnect {
    get {
        return FBConnect.shared;
    }
} //P.E.

public class FBConnect: NSObject {
    
    fileprivate var _userData:NSDictionary?;
    
    public var userData:NSDictionary! {
        get {
            return _userData;
        }
    } //P.E.
    
    //MARK: - shared
    public static var shared: FBConnect = FBConnect();
    
    public override init() {
        super.init();
    } //F.E.
  
    //MARK: - login
    public func login(_ completion:@escaping (_ result:NSDictionary?)->()) {
        print("currentAccessToken : \(FBSDKAccessToken.current())");
        if (FBSDKAccessToken.current() != nil &&  _userData != nil) {
            completion(_userData);
            //--
            return;
        }
        
        let loginManager:FBSDKLoginManager = FBSDKLoginManager();
        loginManager.loginBehavior = .web;//.SystemAccount;//.Native;
        
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: nil) { (result:FBSDKLoginManagerLoginResult?, error:Error?) -> Void in
            print("result : \(result) , error : \(error?.localizedDescription)");
            
            if(( FBSDKAccessToken.current() ) != nil){
                FBSDKGraphRequest(graphPath: "/me?fields=id,name,first_name,email,last_name", parameters: nil).start(completionHandler: { (connection:FBSDKGraphRequestConnection?, result:Any?, error:Error?) -> Void in
                    
                    //--
                    self._userData = result as? NSDictionary;
                    completion(self._userData);
                })
            }
        }
    } //F.E.
    
    //MARK: - logout
    public func logout() {
        let loginManager:FBSDKLoginManager = FBSDKLoginManager();
        loginManager.logOut();
        
        _userData = nil;
    } //F.E.
    
} //CLS END
