//
//  SelectRow.swift
//  Szentiras15v2
//
//  Created by Gabor Sornyei on 2021. 10. 29..
//

import SwiftUI

struct SelectRow: View {
    var abbrev: String
    var name: String
    var selected: Bool
    
    var body: some View {
        HStack {
            Text(abbrev.uppercased())
                .font(.Theme.heavy(size: 15))
                .foregroundColor(.white)
                .frame(width: 50, height: 44)
                .background(selected ? Color.accentColor : Color.Theme.background)
            Text(name)
                .font(.custom("Avenir Book", size: 17))
                .foregroundColor(selected ? Color.Theme.dark : Color.Theme.text)
            Spacer()
        }
    }
}

struct SelectRow_Previews: PreviewProvider {
    static var previews: some View {
        SelectRow(abbrev: "ÓSZ", name: "Ószövetség", selected: false)
            .padding()
            .previewLayout(.sizeThatFits)
        SelectRow(abbrev: "ÚSZ", name: "Újszövetség", selected: true)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
