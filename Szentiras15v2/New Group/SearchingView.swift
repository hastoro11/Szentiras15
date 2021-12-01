//
//  SearchingView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 11. 30..
//

import SwiftUI

// MARK: - SearchingView
struct SearchingView: View {
    var results: [TextResult.Result]
    var body: some View {
        VStack {
            SearchingView.SearchField(onCommit: {}, onClear: {}, onCancel: {})
                .padding()
            FilterBar(count: results.count)
                .padding(.horizontal)
            SearchListView(results: results)
            Spacer()
            
        }
    }
}

// MARK: - FilterBar
extension SearchingView {
    struct FilterBar: View {
        var count: Int
        var isActive: Bool = false
        var body: some View {
            HStack {
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .iconButtonStyle(active: isActive)
                }
                Spacer()
                Text("\(count) találat")
                    .font(.Theme.regular(size: 17))
            }
        }
    }

}

// MARK: - SearchListView
extension SearchingView {
    struct SearchListView: View {
        var results: [TextResult.Result]
        var body: some View {
            List {
                ForEach(results.indices, id:\.self) { index in
                    SearchListRow(result: results[index])
                }
            }
            .listStyle(.plain)
        }
    }

}

// MARK: - SearchListRow
extension SearchingView.SearchListView {
    struct SearchListRow: View {
        var result: TextResult.Result
        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(result.book.abbrev) \(result.chapter),\(result.numv)")
                    .font(.Theme.medium(size: 15))
                Text(result.translation.abbrev.uppercased())
                    .font(.Theme.regular(size: 15))
                    .foregroundColor(Color.light)
                Text(result.text)
                    .font(.Theme.light(size: 15))
                    .foregroundColor(Color("Title"))
                    .lineLimit(3)
            }
            .padding(.bottom, 6)
        }
    }

}

// MARK: - SearchField
extension SearchingView {
    struct SearchField: View {
        @State var text: String = ""
        @State var isEditing: Bool = false
        var onCommit: () -> Void
        var onClear: () -> Void
        var onCancel: () -> Void
        
        var body: some View {
            HStack {
                TextField("Keresés ...", text: $text, onCommit: onCommit)
                    .padding(12)
                    .padding(.horizontal, 25)
                    .background(Color(uiColor: .systemGray5))
                    .cornerRadius(8)
                    .font(.Theme.light(size: 17))
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                    onClear()
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                            .foregroundColor(Color.dark)
                    )
                    .onTapGesture {
                        withAnimation {
                            self.isEditing = true
                        }
                    }
                if isEditing {
                    Button(action: {
                        withAnimation {
                            self.isEditing = false
                        }
                        self.text = ""
                        onCancel()
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Mégsem")
                            .font(.Theme.regular(size: 17))
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                }
            }
            
        }
    }
    
}

// MARK: - Previews
struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView(results: TestData.results)
        
        SearchingView.FilterBar(count: 212)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")
        
        SearchingView.FilterBar(count: 212, isActive: true)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FilterBar")
        
        SearchingView(results: TestData.results)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("SearchListView")
//            .environment(\.colorScheme, .dark)
        
        SearchingView.SearchListView.SearchListRow(result: TestData.results[0])
            .previewLayout(.sizeThatFits)
            .previewDisplayName("SearchListRow")
        
        Group {
            SearchingView.SearchField(text: "", isEditing: true, onCommit: {}, onClear: {}, onCancel: {})
            SearchingView.SearchField(text: "", isEditing: false, onCommit: {}, onClear: {}, onCancel: {})
            SearchingView.SearchField(text: "", isEditing: true, onCommit: {}, onClear: {}, onCancel: {})
                .environment(\.colorScheme, .dark)
            SearchingView.SearchField(text: "", isEditing: false, onCommit: {}, onClear: {}, onCancel: {})
                .environment(\.colorScheme, .dark)

        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("SearchField")
        
        
    }
}
