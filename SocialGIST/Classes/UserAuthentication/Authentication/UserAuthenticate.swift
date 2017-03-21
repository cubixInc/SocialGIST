//
//  SocialConnect.swift
//  UserAuthentication
//
//  Created by Shoaib on 3/20/17.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit

import Google
import GoogleSignIn

public class UserAuthenticate: NSObject {
    
    public static let sharedInstance = UserAuthenticate();
    
    fileprivate var _platformType:PlatformType?
    
    fileprivate override init() {}
    
    public func login(withContext context:UIViewController, platformType:PlatformType, completion:@escaping (_ user:User?)->() ){
        
        //Holding Platform Type
        _platformType = platformType;
        
        switch platformType {
            
        case .facebook:
            FB_CONNECT.login({ (result) in
                NSLog("result \(result)")
                
                if let dict:NSDictionary = result {
                    let user:User = User();
                    
                    user.socialId = dict["id"] as? String;
                    user.email = dict["email"] as? String;
                    user.name = dict["name"] as? String;
                    user.firstName = dict["first_name"] as? String;
                    user.lastName = dict["last_name"] as? String;
                    user.image = "https://graph.facebook.com/\(user.socialId!)/picture?type=square&width=600";
                    user.thumb = "http://graph.facebook.com/\(user.socialId!)/picture?type=square&width=150";
                    user.platformType = platformType;
                    
                    completion(user);
                } else {
                    completion(nil);
                }
                
            })
        break;
            
        case .gmail:
            
            GOOGLE_CONNECT.login(withContext: context, completion: { (result:GIDGoogleUser) in
                NSLog("result \(result)");
                
                let user:User = User();
                
                user.socialId = result.userID;
                user.email = result.profile.email;
                user.name = result.profile.givenName;
                
                let nameArr:[String] = result.profile.name.components(separatedBy: " ");
                
                if nameArr.count > 1 {
                    user.firstName = nameArr[0];
                    user.lastName = nameArr[1];
                } else {
                    user.firstName = result.profile.name;
                }
                
                if(result.profile.hasImage){
                    user.image = result.profile.imageURL(withDimension: 600).absoluteString;
                    user.thumb = result.profile.imageURL(withDimension: 150).absoluteString;
                }
                
                user.platformType = platformType;

                completion(user);
                
            })
 
         break;
            
            
        case .twitter:
            TWITTER_CONNECT.login(completion: { (result:NSDictionary?) in
                if let dict:NSDictionary = result {
                    let user:User = User();
                    
                    user.socialId = dict["id"] as? String;
                    user.name = dict["name"] as? String;
                    user.email = dict["email"] as? String;
                    
                    if let userImg:String = dict["profile_image_url"] as? String {
                        user.thumb = userImg;
                        user.image = userImg.replacingOccurrences(of: "_normal", with: "_bigger", options: .literal, range: nil);
                    }
                    
                    if let fullName:String = dict["name"] as? String {
                        let nameArr:[String] = fullName.components(separatedBy: " ");
                        
                        if nameArr.count > 1 {
                            user.firstName = nameArr[0];
                            user.lastName = nameArr[1];
                        } else {
                            user.firstName = fullName;
                        }
                    }
                    
                    user.platformType = platformType;
                    
                    completion(user);
                } else {
                    completion(nil);
                }
            })
            
 
        break;
            
        default:
            break;
        }
    } //F.E.
    
    //Holding Platform Type
    public func logout(platformType:PlatformType?) {
        guard platformType != nil else {
            return;
        }
        
        switch platformType! {
        case .gmail:
            GOOGLE_CONNECT.logout();
            break;
            
        case .facebook:
            FB_CONNECT.logout();
            break;
            
            case .twitter:
                TWITTER_CONNECT.logout()
            break;
            
            
        default:
            break;
        }
    } //F.E.
    
} //CLS END
