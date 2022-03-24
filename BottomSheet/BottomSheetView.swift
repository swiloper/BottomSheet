//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by myronishyn.ihor on 24.03.2022.
//

import UIKit

final class BottomSheetView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 32.0, y: 32.0, width: 270.0, height: 25.0))
        label.text = "This is my bottom sheet!"
        label.font = .systemFont(ofSize: 24.0)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 32.0, y: 65.0, width: UIScreen.main.bounds.width - 64, height: 50.0))
        label.text = "The bottom sheet is very often used in applications to help it conveniently display some useful information. You can also add the ability to change the height of the bottom sheet to display data of different sizes."
        label.font = .systemFont(ofSize: 20.0)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBottomSheetSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addBottomSheetSubviews()
    }
    
    private func addBottomSheetSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
}
