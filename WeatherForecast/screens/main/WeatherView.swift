//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import SwiftUI

struct WeatherView<ViewModel>: View where ViewModel: WeatherViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    
    let locationsView = LocationsFactory().make()
    
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
                    if !viewModel.isEmptyLocations {
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
                    } else {
                        Spacer()
                        Text("There are no locations")
                        Spacer()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: {
                        locationsView
                    }, label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color(white: 0))
                    })
                }
            }
        }
        .onAppear {
            viewModel.updateData()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService(), locationsStorage: LocationsStorage()))
    }
}
