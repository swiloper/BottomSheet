//
//  ModalViewController.swift
//  BottomSheet
//
//  Created by myronishyn.ihor on 24.03.2022.
//

import UIKit

final class ModalViewController: UIViewController {
    private let maxDimmedAlpha: CGFloat = 0.6
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        setupConstraints()
        let tapGastureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleDismissAction))
        dimmedView.addGestureRecognizer(tapGastureRecogniser)
    }
    
    @objc func handleDismissAction() {
        dismiss(animated: false)
    }
    
    private func setupConstraints() {
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
