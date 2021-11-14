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
    
    var selectedBookName: String {
        guard let book = Book.combined.first(where: {$0.number == filter.book }) else { return "" }
        return book.abbrev.prefix(3).description
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $filter.book) {
                        Text("Nincs szűrés").tag(0)
                            .font(.Theme.regular(size: 17))
                        ForEach(books) { book in
                            Text(book.name)
                                .font(.Theme.light(size: 17))
                                .tag(book.number)
                        }
                    } label: {
                        Text(filter.book == 0 ? "" : selectedBookName)
                            .font(.Theme.bold(size: 15))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 44)
                            .background(filter.book == 0 ? Color.light : Color.accentColor)
                    }
                    
                } header: {
                    Text("Könyvek")
                }
                
                Section {
                    SelectRow(abbrev: "", name: "Nincs szűrés", selected: filter.testament == .none)
                        .onTapGesture {
                            filter.testament = .none
                        }
                    SelectRow(abbrev: "ÓSZ", name: "Ószövetség", selected: filter.testament == .oldTestament)
                        .onTapGesture {
                            filter.testament = .oldTestament
                        }
                    SelectRow(abbrev: "ÚSZ", name: "Újszövetség", selected: filter.testament == .newTesmament)
                        .onTapGesture {
                            filter.testament = .newTesmament
                        }
                    
                } header: {
                    Text("Ó- vagy Újszövetség")
                }
                
                Section {
                    SelectRow(abbrev: "", name: "Nincs szűrés", selected: filter.translation == 0)
                    .onTapGesture {
                        filter.translation = 0
                    }
                    .foregroundColor(filter.translation != 0 ? Color("Title"): Color.light)
                    ForEach(Translation.all()) { tr in
                        SelectRow(abbrev: tr.abbrev.uppercased(), name: tr.name, selected: filter.translation == tr.id)
                        .onTapGesture {
                            filter.translation = tr.id
                        }
                    }
                } header: {
                    Text("Fordítás")
                }
            }
            .listStyle(.grouped)
            .font(.Theme.regular(size: 17))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.cancellationAction) {
                    Button {
                        filter = Filter(book: 0, translation: 0, testament: .none)
                        showFilter.toggle()
                    } label: {
                        Image(systemName: "trash")
                        .font(.Theme.regular(size: 17))
                    }

                }
                ToolbarItem(placement: ToolbarItemPlacement.principal) {
                    Text("Találatok szűrése").font(.Theme.bold(size: 17))
                }
                ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
                    Button {
                        showFilter.toggle()
                    } label: {
                        Text("Kész")
                        .font(.Theme.regular(size: 17))
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
