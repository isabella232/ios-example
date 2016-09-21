//
//  AppDelegate.swift
//  ApptentiveExample
//
//  Created by Frank Schmitt on 8/6/15.
//  Copyright (c) 2015 Apptentive, Inc. All rights reserved.
//

import UIKit
import Apptentive
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, CrashlyticsDelegate {

	var window: UIWindow?
	var didDetectCrash = false

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		Apptentive.shared.apiKey = "<#Your Apptentive API Key#>"

		precondition(Apptentive.shared.apiKey != "<#Your Apptentive API Key#>", "Please set your Apptentive API key above")

		if let tabBarController = self.window?.rootViewController as? UITabBarController {
			tabBarController.delegate = self
		}

		Crashlytics.sharedInstance().delegate = self
		Fabric.with([Crashlytics.self])

		return true
	}

	// MARK: Tab bar controller delegate
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if tabBarController.viewControllers?.index(of: viewController) ?? 0 == 0 {
			Apptentive.shared.engage(event: "photos_tab_selected", from: tabBarController)
		} else {
			Apptentive.shared.engage(event: "favorites_tab_selected", from: tabBarController)
		}
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		if (didDetectCrash) {
			// Use the default view-controller-crawling behavior to find active VC
			Apptentive.shared.engage(event: "did_crash", from: nil)
			didDetectCrash = false
		}
	}

	func crashlyticsDidDetectReport(forLastExecution report: CLSReport, completionHandler: @escaping (Bool) -> Void) {
		didDetectCrash = true

		completionHandler(true)
	}
}

