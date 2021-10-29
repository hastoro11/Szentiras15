//
//  SearchResultList.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 29..
//

import SwiftUI

struct SearchResultList: View {
    typealias Result = TextResult.Result
    var results: [Result]
    var onTap: (Result) -> Void
    var body: some View {
        List {
            ForEach(results.indices, id:\.self) { index in
                ResultRow(result: results[index])
                    .onTapGesture {
                        onTap(results[index])
                    }
            }
        }
        .listStyle(.plain)
    }
}

struct ResultRow: View {
    var result: TextResult.Result
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(result.book.abbrev) \(result.chapter),\(result.numv)")
                .font(.Theme.heavy(size: 15))
            Text(result.translation.abbrev.uppercased())
                .font(.Theme.oblique(size: 15))
                .foregroundColor(.Theme.text)
            Text(result.text)
                .font(.Theme.book(size: 15))
                .foregroundColor(Color.Theme.button)
                .lineLimit(3)
        }
    }
}

struct SearchResultList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultList(results: [], onTap: {_ in })
    }
}
