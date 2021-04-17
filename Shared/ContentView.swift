//
//  ContentView.swift
//  Shared
//
//  Created by Jordan Gustafson on 4/17/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = DefaultExampleViewModel()
    
    var body: some View {
        ExampleContainerView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
