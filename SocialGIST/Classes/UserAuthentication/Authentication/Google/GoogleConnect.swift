//
//  GPlusConnect.swift
//  eGrocery
//
//  Created by Shoaib on 3/20/15.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn

public var GOOGLE_CONNECT:GoogleConnect {
    get {
        return GoogleConnect.shared;
    }
} //P.E.

public class GoogleConnect: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    static var shared: GoogleConnect = GoogleConnect();
    
    private var _parentVC:UIViewController!
    
    private var _completion:((_ result:GIDGoogleUser)->())?
    
    public var googlePlusUser:GIDGoogleUser! {
        get {
            return GIDSignIn.sharedInstance().currentUser;
        }
    } //P.E.
    
    override init() {
        super.init();
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError);
        //--
        
        let googleSignin = GIDSignIn.sharedInstance();
        googleSignin?.shouldFetchBasicProfile = true;
        //--
        googleSignin?.scopes = ["profile","email"];//[kGTLAuthScopePlusUserinfoProfile]
        googleSignin?.delegate = self;
        googleSignin?.uiDelegate = self;
        
    } //F.E.
    
    //MARK: - Gmail
    func login(withContext context:UIViewController, completion:@escaping (_ result:GIDGoogleUser)->()){
        
        let googleSignin = GIDSignIn.sharedInstance()!;
        _completion = completion;
        
        if (googleSignin.hasAuthInKeychain()) {
            if(googleSignin.currentUser == nil){
                GIDSignIn.sharedInstance().signInSilently();
            } else {
                completion(googleSignin.currentUser);
            }
        } else {
            _parentVC = context;
            //--
            googleSignin.signIn();
        }
        
    } //F.E.
    
    func logout(){
        GIDSignIn.sharedInstance().signOut();
        GIDSignIn.sharedInstance().disconnect();
        //--
        _completion = nil;
        _parentVC = nil;
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (user != nil) {
            _completion?(user);
            //--
            _completion = nil;
            _parentVC = nil;
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        _parentVC.present(viewController, animated: true, completion: nil);
    } //F.E.
    
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil);
    } //F.E.
    
} //CLS END

