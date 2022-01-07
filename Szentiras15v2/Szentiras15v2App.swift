//
//  Szentiras15v2App.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 21..
//

import SwiftUI

@main
struct Szentiras15v2App: App {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var bibleController: BibleController = BibleController()
    @StateObject var searchController: SearchController = SearchController()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(bibleController)
                .environmentObject(searchController)
                .environmentObject(PartialSheetManager())
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .inactive:
                bibleController.saveUserDefaults()
            default:
                break
            }
        }
    }
    
    init() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}
