//
//  SceneDelegate.swift
//  Timetable 3.0
//
//  Created by Konrad on 20/08/2020.
//  Copyright © 2020 Konrad. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    @ObservedObject var settings = Settings()
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
              // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = MainView().environment(\.managedObjectContext, context)
        let onboardView = OnboardingView().environment(\.managedObjectContext, context)
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let selectedColorScheme = settings.selectedColorScheme
            if selectedColorScheme == 0 {
                window.overrideUserInterfaceStyle = .dark
            } else if selectedColorScheme == 1 {
                window.overrideUserInterfaceStyle = .light
            }
            
            //Define if display onboarding view
            if !hasLaunchedBefore{
                window.rootViewController = UIHostingController(rootView: onboardView)
            } else {
                window.rootViewController = UIHostingController(rootView: contentView)
            }

            self.window = window
            if !hasLaunchedBefore{

                let monday = Days(context: context)
                monday.name = "Monday"
                monday.id = 0
                let tuesday = Days(context: context)
                tuesday.name = "Tuesday"
                tuesday.id = 1
                let wednesday = Days(context: context)
                wednesday.name = "Wednesday"
                wednesday.id = 2
                let thursday = Days(context: context)
                thursday.name = "Thursday"
                thursday.id = 3
                let friday = Days(context: context)
                friday.name = "Friday"
                friday.id = 4

                do {
                    try context.save()
                } catch {
                    print(error)
            }
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
           }

            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
 
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        UserDefaults.standard.set(true, forKey: "appBecameInactive")

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        
        UserDefaults.standard.set(true, forKey: "appBecameInactive")
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
    }


}
