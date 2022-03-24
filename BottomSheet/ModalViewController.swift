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
    
    private let defaultSheetHeight: CGFloat = 300.0
    private let dismissibleSheetHeight: CGFloat = 200.0
    private let maximumSheetHeight: CGFloat = UIScreen.main.bounds.height - 64.0
    
    private var sheetBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dimmedView)
        view.addSubview(bottomSheetView)
        setupConstraints()
        setupGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentSheet()
    }
    
    @objc func handleDismissAction() {
        animateDismissController()
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
            bottomSheetView.heightAnchor.constraint(equalToConstant: defaultSheetHeight)
        ])
        
        sheetBottomConstraint = bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultSheetHeight)
        sheetBottomConstraint?.isActive = true
    }

    private func setupGestureRecognizers() {
        let tapGastureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissAction))
        dimmedView.addGestureRecognizer(tapGastureRecognizer)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        let newHeight = defaultSheetHeight - translation.y
        
        let isDraggingUp = translation.y < 0

        switch gesture.state {
        case .changed:
            if newHeight < defaultSheetHeight {
                sheetBottomConstraint?.constant = translation.y
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleSheetHeight {
                animateDismissController()
            } else if newHeight < defaultSheetHeight || isDraggingUp {
                animatePresentSheet()
            }
        default:
            break
        }
    }
    
    private func animatePresentSheet() {
        UIView.animate(withDuration: 0.3) {
            self.sheetBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animateDismissController() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }

        UIView.animate(withDuration: 0.3) {
            self.sheetBottomConstraint?.constant = self.defaultSheetHeight
            self.view.layoutIfNeeded()
        }
    }
}
