//
//  CircleImage.swift
//  MusicApp
//
//  Created by Quoc Huy on 8/3/20.
//  Copyright © 2020 Quoc Huy. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    // MARK: Variable
    var angle = 0
    
    // MARK: Override
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
    }
    
    // MARK: Function
    func loadCoverImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let this = self else { return }

            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        this.image = image
                    }
                }
            }
        }
    }
    
    func rotateCoverImage() {
        // pi : 180
        // ? : 1
        self.angle = (self.angle >= 360) ? 0 : self.angle + 2
        UIView.animate(withDuration: 0.05) {
            let rotateAngle = CGFloat.pi *  CGFloat(self.angle)
            self.transform = .init(rotationAngle: rotateAngle / 180 )
        }
    }
}
