//
//  ExampleViewController.swift
//  InterruptibleAnimations (iOS)
//
//  Created by Jordan Gustafson on 4/17/21.
//

import UIKit
import SwiftUI
import Combine

/// Wrapper view for `ExampleViewController`
struct ExampleVCView<ViewModel: ExampleViewModel>: UIViewControllerRepresentable {
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> ExampleViewController<ViewModel> {
        return ExampleViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: ExampleViewController<ViewModel>, context: Context) {
        //
    }
}

/// UIKit implementation of the `ExampleView`
final class ExampleViewController<ViewModel: ExampleViewModel>: UIViewController {
    
    private let viewModel: ViewModel
    
    private lazy var block: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 50),
            view.heightAnchor.constraint(equalToConstant: 50),
        ])
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.buttonText, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.titleEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(toggleTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var blockLeadingConstraint: NSLayoutConstraint = {
        let constraint = block.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        constraint.isActive = viewModel.position == .leading
        return constraint
    }()
    
    private lazy var blockTrailingConstraint: NSLayoutConstraint = {
        let constraint = block.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        constraint.isActive = viewModel.position == .trailing
        return constraint
    }()
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpSubscriptions()
    }
    
    private func setUpViews() {
        view.addSubview(block)
        view.addSubview(button)
        NSLayoutConstraint.activate(
            [block.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
             button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)]
        )
        view.layoutIfNeeded()
    }
    
    private func setUpSubscriptions() {
        viewModel.positionPublisher.sink {[weak self] position in
            guard let self = self else { return }
            self.positionUpdated(position: position)
        }.store(in: &cancellables)
        
        viewModel.buttonTextPublisher.sink {[weak self] buttonText in
            guard let self = self else { return }
            self.buttonTextUpdated(buttonText: buttonText)
        }.store(in: &cancellables)
    }

    private func positionUpdated(position: ExampleViewModels.Position) {
        switch position {
        case .leading:
            blockTrailingConstraint.isActive = false
            blockLeadingConstraint.isActive = true
        case .trailing:
            blockLeadingConstraint.isActive = false
            blockTrailingConstraint.isActive = true
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func buttonTextUpdated(buttonText: String) {
        UIView.animate(withDuration: 0.15) {
            self.button.titleLabel?.alpha = 0.0
        } completion: { _ in
            self.button.setTitle(buttonText, for: .normal)
            UIView.animate(withDuration: 0.15) {
                self.button.titleLabel?.alpha = 1.0
            }
        }
    }
    
    @objc private func toggleTapped(_ sender: Any) {
        viewModel.togglePosition()
    }
}
