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
        VStack(spacing: 2) {
            Text("\(model.city), \(model.country)")
                .font(.system(size: 14.0))
            Text("\(model.lat)")
                .font(.system(size: 12.0))
                .foregroundColor(Color(white: 0.4))
            Text("\(model.lon)")
                .font(.system(size: 12.0))
                .foregroundColor(Color(white: 0.4))
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
