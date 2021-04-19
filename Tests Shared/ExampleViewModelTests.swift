//
//  ExampleViewModelTests.swift
//  SharedViewModels
//
//  Created by Jordan Gustafson on 4/19/21.
//

@testable import SharedViewModels
import XCTest
import Combine

class ExampleViewModelTests: XCTestCase {

    private var viewModel: DefaultExampleViewModel = DefaultExampleViewModel()
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    override func setUp() {
        super.setUp()
        cancellables = Set()
        viewModel = DefaultExampleViewModel()
    }
    
    func testButtonTitleUpdates() throws {
        let expectation = XCTestExpectation(description: "Button Text Will Update")
        //Subscribe to button changes
        viewModel.buttonTextPublisher
            .dropFirst()
            .sink { buttonText in
                XCTAssert(buttonText == "Move Left")
                expectation.fulfill()
            }.store(in: &cancellables)
        viewModel.togglePosition()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testPositionUpdates() throws {
        let expectation = XCTestExpectation(description: "Position Will Update")
        //Subscribe to button changes
        viewModel.positionPublisher
            .dropFirst()
            .sink { position in
                XCTAssert(position == .trailing)
                expectation.fulfill()
            }.store(in: &cancellables)
        viewModel.togglePosition()
        wait(for: [expectation], timeout: 1.0)
    }
    
}
