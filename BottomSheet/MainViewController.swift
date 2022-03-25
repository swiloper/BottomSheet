//
//  ViewController.swift
//  BottomSheet
//
//  Created by myronishyn.ihor on 24.03.2022.
//

import UIKit

final class MainViewController: UIViewController {
    /// The button that shows the BottomSheet.
    private let showingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show bottom sheet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15.0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(showingButton)
        setupConstraints()
        showingButton.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)
    }
    
    /// This function sets up the constrains for the views.
    private func setupConstraints() {
        showingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            showingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showingButton.heightAnchor.constraint(equalToConstant: 60.0),
            showingButton.widthAnchor.constraint(equalToConstant: view.frame.width - 60.0)
        ])
    }
    
    @objc func showBottomSheet() {
        let modalController = ModalViewController()
        modalController.modalPresentationStyle = .overCurrentContext
        present(modalController, animated: false)
    }
}

