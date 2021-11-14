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
                .font(.Theme.bold(size: 15))
                .foregroundColor(Color.white)
                .frame(width: 50, height: 44)
                .background(selected ? Color.accentColor : Color(uiColor: UIColor.systemGray3))
            Text(name)
                .font(.Theme.light(size: 17))
                .foregroundColor(selected ? Color("Title") : Color(uiColor: .systemGray3))
            Spacer()
        }
    }
}

struct SelectRow_Previews: PreviewProvider {
    static var previews: some View {
        SelectRow(abbrev: "ÓSZ", name: "Ószövetség", selected: false)
            .preferredColorScheme(.dark)
            .padding()
            .previewLayout(.sizeThatFits)
        SelectRow(abbrev: "ÚSZ", name: "Újszövetség", selected: true)
            .preferredColorScheme(.dark)
            .padding()
            .previewLayout(.sizeThatFits)
        SelectRow(abbrev: "ÚSZ", name: "Újszövetség", selected: true)
            .preferredColorScheme(.light)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
