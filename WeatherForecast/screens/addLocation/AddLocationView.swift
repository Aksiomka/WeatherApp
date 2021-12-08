//
//  AddLocationView.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 03.12.2021.
//

import SwiftUI
import MapKit

struct AddLocationView<ViewModel>: View where ViewModel: AddLocationViewModelProtocol {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 0) {
                ZStack {
                    MapView(centerCoordinate: $viewModel.centerCoordinate)
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.3)
                        .frame(width: 16, height: 16)
                }
                Spacer().frame(height: 8)
                Button {
                    self.viewModel.addLocation()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add location")
                    }
                    .padding(8)
                    .foregroundColor(.blue)
                    .background(.white)
                    .cornerRadius(12)
                    .padding(1)
                    .background(.blue)
                    .cornerRadius(13)
                }
                Spacer()
            }
        }
        .navigationTitle("Add location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(viewModel: AddLocationViewModel(locationsStorage: LocationsStorage()))
    }
}
