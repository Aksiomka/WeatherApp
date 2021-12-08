//
//  LocationCell.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 03.12.2021.
//

import SwiftUI

struct LocationCell: View {
    var model: LocationModel

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(model.city)
                .font(.system(size: 17.0))
            Text(model.country)
                .font(.system(size: 14.0))
            Spacer().frame(height: 4)
            HStack {
                Text("\(model.lat)")
                Text("\(model.lon)")
            }
            .font(.system(size: 10.0))
            .foregroundColor(Color(white: 0.4))
            Spacer().frame(height: 8)
        }
    }
}

struct LocationCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationCell(model: LocationModel(
            city: "Moscow",
            country: "Russia",
            lat: 0.12,
            lon: 0.45
        ))
    }
}
