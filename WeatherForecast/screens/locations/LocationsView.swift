//
//  LocationsView.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 03.12.2021.
//

import SwiftUI

struct LocationsView<ViewModel>: View where ViewModel: LocationsViewModelProtocol {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                List {
                    ForEach(viewModel.locations, id: \.self) { location in
                        LocationCell(model: location)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Locations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: {
                    AddLocationFactory().make()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color(white: 0))
                })
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView(viewModel: LocationsViewModel(userDefaultsStorage: UserDefaultsStorage()))
    }
}
