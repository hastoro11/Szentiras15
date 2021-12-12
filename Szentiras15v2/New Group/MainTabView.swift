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
                BibleChapterView(idezet: TestData.idezetRom16, current: TestData.current)
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
