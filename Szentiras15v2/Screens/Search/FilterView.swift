//
//  FilterView.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 29..
//

import SwiftUI

struct Filter: Equatable {
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.book == rhs.book && lhs.testament == rhs.testament && lhs.translation == rhs.translation
    }
    
    enum Testament: Int {
        case none = 0
        case oldTestament
        case newTesmament
    }
    
    var book: Int
    var translation: Int
    var testament: Testament
}

struct FilterView: View {
    var books: [Book] = Book.combined
    
    @Binding var showFilter: Bool
    @Binding var filter: Filter

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $filter.book) {
                        Text("Nincs szűrés").tag(0)
                        ForEach(books) { book in
                            Text(book.name)
                                .tag(book.number)
                        }
                    } label: {
                        Text("Válassz")
                            .fixedSize()
                    }

                } header: {
                    Text("Könyvek")
                }
                
                Section {
                    HStack {
                        Text("Nincs szűrés")
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(filter.testament == .none ? 1 : 0)
                    }
                    .onTapGesture {
                        filter.testament = .none
                    }
                    HStack {
                        Text("Ószövetség")
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(filter.testament == .oldTestament ? 1 : 0)
                    }
                    .onTapGesture {
                        filter.testament = .oldTestament
                    }
                    HStack {
                        Text("Újszövetség")
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(filter.testament == .newTesmament ? 1 : 0)
                    }
                    .onTapGesture {
                        filter.testament = .newTesmament
                    }
                    
                } header: {
                    Text("Ó- vagy Újszövetség")
                }
                
                Section {
                    HStack {
                        Text("Nincs szűrés")
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(filter.translation == 0 ? 1 : 0)
                    }
                    .onTapGesture {
                        filter.translation = 0
                    }
                    ForEach(Translation.all()) { tr in
                        HStack {
                            Text(tr.name)
                            Spacer()
                            Image(systemName: "checkmark")
                                .opacity(filter.translation == tr.id ? 1 : 0)
                        }
                        .onTapGesture {
                            filter.translation = tr.id
                        }
                    }
                } header: {
                    Text("Fordítás")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Találatok szűrése")
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
                    Button("Kész") {
                        showFilter.toggle()
                    }
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(showFilter: .constant(false), filter: .constant(Filter(book: 0, translation: 0, testament: .none)))
    }
}
