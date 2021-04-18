//
//  ExampleView.swift
//  InterruptibleAnimations
//
//  Created by Jordan Gustafson on 4/17/21.
//

import SwiftUI


/// Container view that handles the logic of which example view to present depending on the platform
struct ExampleContainerView<ViewModel: ExampleViewModel>: View {
    let viewModel: ViewModel
    
    var body: some View {
        #if os(iOS)
        //On iOS use the VC based implementation
        ExampleVCView(viewModel: viewModel)
        #else
        //On other platforms, use SwiftUI
        ExampleView(viewModel: viewModel)
        #endif
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

/// `ExampleView` for platforms that will be using SwiftUI
struct ExampleView<ViewModel: ExampleViewModel>: View {
    
    @ObservedObject private var viewModel: ViewModel
    @Namespace private var animation
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            blockView()
            Spacer()
        }.overlay(buttonView(), alignment: .bottom)
    }
    
    @ViewBuilder
    private func blockView() -> some View {
        HStack {
            if viewModel.position == .trailing {
                Spacer()
            }
            Color.red
                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            if viewModel.position == .leading {
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func buttonView() -> some View {
        Button(action: {
            viewModel.togglePosition()
        }, label: {
            Text(viewModel.buttonText)
        })
    }
    
}

//MARK: - Previews

struct ExampleView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            Group {
                Preview()
            }
            
            Group {
                Preview()
            }.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
    
    struct Preview: View {
        @StateObject var viewModel = DefaultExampleViewModel()
        
        var body: some View {
            ExampleContainerView(viewModel: viewModel)
        }
    }
    
}

