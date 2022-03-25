//
//  ModalViewController.swift
//  BottomSheet
//
//  Created by myronishyn.ihor on 24.03.2022.
//

import UIKit

final class ModalViewController: UIViewController {
    private let maxDimmedAlpha: CGFloat = 0.6
    /// View, which will dim the previous controller.
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
    private lazy var currentSheetHeight: CGFloat = defaultSheetHeight
    /// The height at which BottomSheet will automatically disappear.
    private let dismissibleSheetHeight: CGFloat = 200.0
    /// Maximum height of the BottomSheet.
    private let maximumSheetHeight: CGFloat = UIScreen.main.bounds.height - 64.0
    
    private var sheetHeightConstraint: NSLayoutConstraint?
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
            
        ])
        
        sheetBottomConstraint = bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultSheetHeight)
        sheetBottomConstraint?.isActive = true
        
        sheetHeightConstraint = bottomSheetView.heightAnchor.constraint(equalToConstant: defaultSheetHeight)
        sheetHeightConstraint?.isActive = true
    }

    private func setupGestureRecognizers() {
        let tapGastureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissAction))
        dimmedView.addGestureRecognizer(tapGastureRecognizer)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    private func animateSheetHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.sheetHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentSheetHeight = height
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newSheetHeight = currentSheetHeight - translation.y
        // If translation.y is negative, then the direction of dragging is up
        let isDraggingUp = translation.y < 0

        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newSheetHeight < maximumSheetHeight {
                // Keep updating the height constraint
                sheetHeightConstraint?.constant = newSheetHeight
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag
            // If new height is below dismissibleSheetHeight, dismiss controller
            if newSheetHeight < dismissibleSheetHeight {
                animateDismissController()
            }
            // If new height is below default, animate back to defaultSheetHeight
            else if newSheetHeight < defaultSheetHeight {
                animateSheetHeight(defaultSheetHeight)
            }
            // If new height is below maximumSheetHeight and going down, set to defaultSheetHeight
            else if newSheetHeight < maximumSheetHeight && !isDraggingUp {
                animateSheetHeight(defaultSheetHeight)
            }
            // If new height is below maximumSheetHeight and going up, set to maximumSheetHeight at top
            else if newSheetHeight > defaultSheetHeight && isDraggingUp {
                animateSheetHeight(maximumSheetHeight)
            }
        default:
            break
        }
    }
    
    /// This function animates the appearance of the controller.
    private func animatePresentSheet() {
        UIView.animate(withDuration: 0.3) {
            self.sheetBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    /// This function animates the appearance of the dimmed view.
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    /// This function animates disappearance of BottomSheetController.
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
