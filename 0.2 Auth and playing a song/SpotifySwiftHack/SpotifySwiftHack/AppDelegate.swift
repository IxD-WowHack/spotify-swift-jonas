//
//  AppDelegate.swift
//  SpotifySwiftHack
//
//  Created by Jonas Berglund on 17/07/15.
//  Copyright © 2015 Jonas Berglund. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var session: SPTSession?
    var player: SPTAudioStreamingController?
    
    let kClientId = "9921258e4129458da3bd81ca20ca0751"
    let kCallbackURL = "spotify-swift-hack://callback"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let auth = SPTAuth.defaultInstance()
        auth.clientID = kClientId
        auth.redirectURL = NSURL(string: kCallbackURL)
        auth.requestedScopes = [SPTAuthPlaylistModifyPublicScope,SPTAuthUserReadPrivateScope, SPTAuthPlaylistReadPrivateScope, SPTAuthStreamingScope]
        let loginURL = auth.loginURL
        delay(0.1) {
            application.openURL(loginURL)
            return
        }
        
        return true
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if SPTAuth.defaultInstance().canHandleURL(url) {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, session) -> Void in
                if error != nil {
                    print(error.localizedDescription)
                    return
                }
                
                self.playUsingSession(session)
                
            })
        }
        
        return false
    }
    
    func playUsingSession(session:SPTSession) {
        // Create a new player if needed
        if (self.player == nil) {
            self.player = SPTAudioStreamingController(clientId: kClientId)
        }
        self.player?.loginWithSession(session, callback: { (error) -> Void in
            if (error != nil) {
                print("*** Enabling playback got error: \(error)")
                return
            } else {
                

                var trackURIs: [NSURL] = []
                trackURIs.append(NSURL(string: "spotify:track:3j9uGwbiRJrsOzOYloTE1b")!)
                
                self.player?.playURIs(trackURIs, fromIndex: 0, callback: nil)
                
            }
        })
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

