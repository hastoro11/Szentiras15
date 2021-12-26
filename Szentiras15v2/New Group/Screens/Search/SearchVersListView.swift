//
//  SearchVersListView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 12. 24..
//

import SwiftUI

struct SearchVersListView: View {
    @StateObject var model: SearchVersListViewModel
    init(searchResult: SearchResult) {
        _model = StateObject(wrappedValue: SearchVersListViewModel(searchResult: searchResult))
    }
    var body: some View {
        if model.phase == .success {
            Content(
                verses: model.idezet.valasz.versek,
                title: model.idezet.keres.hivatkozas,
                index: model.searchResult.numv - 1,
                translationAbbrev: model.translation?.abbrev.uppercased() ?? ""
            )
        } else if model.phase == .failure {
            Text("Error")
        } else if model.phase == .isLoading {
            ProgressView("Keresés...")
        } else {
            EmptyView()
        }
    }
}

extension SearchVersListView {
    struct Content: View {
        var verses: [Vers]
        var title: String
        var index: Int
        var translationAbbrev: String
        var body: some View {
            VStack {
                VersList(verses: verses, scrollTo: true, index: index)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(title)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Text(translationAbbrev)
                                .foregroundColor(.accentColor)
                        }
                    }
            }
        }
    }
    
}

// MARK: - Previews
struct SearchVersListView_Previews: PreviewProvider {
    static var model: SearchVersListViewModel = .preview
    static var previews: some View {
        NavigationView {
            SearchVersListView.Content(verses: model.idezet.valasz.versek, title: model.idezet.keres.hivatkozas, index: model.searchResult.numv, translationAbbrev: "RUF")
        }
    }
}
