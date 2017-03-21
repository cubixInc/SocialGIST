//
//  TwitterHelper.swift
//  TwitterHelper
//
//  Created by Alizain on 29/04/2016.
//  Copyright © 2017 Social Cubix Inc. All rights reserved.


import UIKit
import TwitterKit

public var TWITTER_CONNECT:TwitterConnect {
    get {
        return TwitterConnect.sharedInstance;
    }
} //P.E.

public class TwitterConnect: NSObject {
    
    private var _userData:NSDictionary?;
    public var userData:NSDictionary! {
        get {
            return _userData;
        }
    } //P.E.
    
    //MARK: - sharedInstance
    static var sharedInstance: TwitterConnect = TwitterConnect();
    
    private override init() {
        super.init();
        
        //??let CONSUMER_KEY = "kIjwnskgyq2zplz9bGLr0g";
        //??let SECRET_KEY = "xgsHdWsHT65iJIMzgGhFhkZaCy3bQYQszdyOg9zFEKo";
        
        //??Twitter.sharedInstance().start(withConsumerKey: CONSUMER_KEY, consumerSecret: SECRET_KEY);
    } //F.E.
    
    func login(completion:@escaping (_ result:NSDictionary?)->()){
        let store = Twitter.sharedInstance().sessionStore
        
        if (store.session()?.userID != nil && _userData != nil)  {
            completion(_userData);
            //--
            return;
        }
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            self.requestForUserData(completion: completion);
        }
    } //F.E.
    
    private func requestForUserData(completion:@escaping (_ result:NSDictionary?)->()){
        
        let client = TWTRAPIClient.withCurrentUser()
        let request = client.urlRequest(withMethod: "GET",
                                        url: "https://api.twitter.com/1.1/account/verify_credentials.json",
            parameters: ["include_email": "true", "skip_status": "true"],
            error: nil)
        
        client.sendTwitterRequest(request) { response, data, connectionError in
            
            if connectionError != nil {
                print("Error: \(connectionError)")
                completion(nil);
            }
            do {
                if response != nil {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    completion(json as? NSDictionary);
                }
            } catch  {
                completion(nil);
            }
        }
    } //F.E.
    
    func logout(){
        let store = Twitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID  {
            store.logOutUserID(userID)
        }
    } //F.E.

} //CLS END
