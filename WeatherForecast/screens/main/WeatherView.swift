//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                VStack {
                    HStack {
                        Text("Last updated:")
                        Text(viewModel.lastUpdated)
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.5))
                    List {
                        ForEach(viewModel.models, id: \.self) { model in
                            CityWeatherCell(model: model)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.updateData()
                    }
                    if viewModel.errorMessage != nil {
                        Text(viewModel.errorMessage ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.3))
                    }
                }
            }
            .navigationTitle("Weather Forecast")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.updateData()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}
