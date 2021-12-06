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
            VStack {
                ZStack {
                    MapView(centerCoordinate: $viewModel.centerCoordinate)
                    Circle()
                        .fill(Color.red)
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
                }
            }
        }
        .navigationTitle("Add location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(viewModel: AddLocationViewModel(userDefaultsStorage: UserDefaultsStorage()))
    }
}
