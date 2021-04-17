//
//  ExampleViewModel.swift
//  InterruptibleAnimations
//
//  Created by Jordan Gustafson on 4/17/21.
//

import SwiftUI

/// Defines a type that the provides the data need to render the `ExampleView`
protocol ExampleViewModel: ObservableObject {
    /// The position of the square
    var position: ExampleViewModels.Position { get }
    /// Publisher for the project position
    var positionPublisher: Published<ExampleViewModels.Position>.Publisher { get }
    /// The text to display in the button
    var buttonText: String { get }
    /// Publisher for the button text
    var buttonTextPublisher: Published<String>.Publisher { get }
    /// Toggles the position of the square
    func togglePosition()
}

/// Name spaced container for models related to the `ExampleViewModel`
struct ExampleViewModels {
    enum Position {
        case leading
        case trailing
    }
}

//MARK: - Default Implementation

final class DefaultExampleViewModel: ExampleViewModel {
    
    @Published var position: ExampleViewModels.Position = .leading
    var positionPublisher: Published<ExampleViewModels.Position>.Publisher {
        $position
    }
    
    @Published var buttonText: String = "Move Right"
    var buttonTextPublisher: Published<String>.Publisher {
        $buttonText
    }
    
    func togglePosition() {
        withAnimation(.easeInOut) {
            switch self.position {
            case .leading:
                self.position = .trailing
            case .trailing:
                self.position = .leading
            }
            buttonText = self.buttonText(for: position)
        }
    }
    
    private func buttonText(for position: ExampleViewModels.Position) -> String {
        switch position {
        case .leading:
            return "Move Right"
        case .trailing:
            return "Move Left"
        }
    }
    
}
