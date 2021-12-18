//
//  MainTabView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 12..
//

import SwiftUI

struct MainTabView: View {
    @StateObject var bibleController: BibleController = BibleController()
    var body: some View {
        TabView {
            NavigationView {
                BibleChapterView()
                    .environmentObject(bibleController)
            }
            .tabItem {
                Label("Biblia", systemImage: "book.fill")
            }
            
            NavigationView {
                SearchingView(results: TestData.results)
            }
            .tabItem {
                Label("Keresés", systemImage: "magnifyingglass")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
