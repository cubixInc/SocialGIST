//
//  SocialConnect.swift
//  UserAuthentication
//
//  Created by Alizain on 09/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit
import SocialGIST
import Google
import GoogleSignIn

enum AuthType:String{
    case custom, facebook, gmail, twitter
}

class UserAuthenticate: NSObject {
    
    static let sharedInstance = UserAuthenticate();
    
    fileprivate var _authType:AuthType?
    
    fileprivate override init() {}
    
    func login(withContext context:UIViewController, authType:AuthType, completion:@escaping (_ userInfo:User?)->() ){
        
        //Holding Auth Type
        _authType = authType;
        
        switch authType {
            
        case .facebook:
            FB_CONNECT.login({ (result) in
                NSLog("result \(result)")
                
                let user:User!;
                
                if let dict:NSDictionary = result {
                    user = User();
                    //--
                    user.socialId = dict["id"] as? String;
                    user.emailAddress = dict["email"] as? String;
                    user.username = dict["name"] as? String;
                    user.firstName = dict["first_name"] as? String;
                    user.lastName = dict["last_name"] as? String;
                    user.profilePic = "https://graph.facebook.com/\(user!.socialId!)/picture?type=square&width=600";
                    user.thumbnail = "http://graph.facebook.com/\(user!.socialId!)/picture?type=square&width=150";
                    user.authType = authType;
                }
                
                completion(user);
            })
        break;
            
        case .gmail:
            
            GOOGLE_CONNECT.login(withContext: context, completion: { (result:GIDGoogleUser) in
                NSLog("result \(result)");
                
                let user:User = User();
                
                user.socialId = result.userID;
                user.emailAddress = result.profile.email;
                user.username = result.profile.givenName;
                
                let nameArr:[String] = result.profile.name.components(separatedBy: " ");
                
                if nameArr.count > 1 {
                    user.firstName = nameArr[0];
                    user.lastName = nameArr[1];
                } else {
                    user.firstName = result.profile.name;
                }
                
                if(result.profile.hasImage){
                    user.profilePic = result.profile.imageURL(withDimension: 600).absoluteString;
                    user.thumbnail = result.profile.imageURL(withDimension: 150).absoluteString;
                }
                
                user.authType = authType;

                completion(user);
                
            })
 
         break;
            
             /*
        case .Twitter:
            TWITTER_CONNECT.login({ (result) in
               
                self.loginType = type
                var userDict = [String:AnyObject]();
                let id = result!["id"];
                
                userDict["socialId"]                = id
                userDict["userprofileFirstName"]    = result!["name"]
                userDict["userPic"]                 = (result!["profile_image_url"] as! String ).stringByReplacingOccurrencesOfString("_normal", withString: "_bigger", options: NSStringCompareOptions.LiteralSearch, range: nil)
                userDict["userThumbPic"]            = result!["profile_image_url"]
                
                completion(result: userDict);
 
            })
 
        break;
         */
            
        default:
            break;
        }
    } //F.E.
    
    func logout(authType:AuthType?) {
        guard authType != nil else {
            return;
        }
        
        switch authType! {
        case .gmail:
            GOOGLE_CONNECT.logout();
            break;
            
        case .facebook:
            FB_CONNECT.logout();
            break;
            
            //        case .Twitter:
            //            TWITTER_CONNECT.logout()
            //            break;
            //
            
        default:
            break;
        }
    } //F.E.
    
} //CLS END
