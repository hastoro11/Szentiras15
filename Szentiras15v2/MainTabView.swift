//
//  MainTabView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 12..
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            NavigationView {
                BibleChapterView()
            }
            .tabItem {
                Label("Biblia", systemImage: "book.fill")
            }
            
            NavigationView {
                SearchingView()
            }
            .tabItem {
                Label("Keresés", systemImage: "magnifyingglass")
            }
            SettingsView()
                .tabItem {
                    Label("Beállítások", systemImage: "gear")
                }
        }
//        .overlay(SplashScreen())
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
