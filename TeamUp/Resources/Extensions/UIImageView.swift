//
//  UIImageView.swift
//  TeamUp
//
//  Created by alihizardere on 13.08.2024.
//
import UIKit

extension UIImageView {
    func startGifAnimation(name: String, duration: TimeInterval) {
        guard let images = loadGifImages(name: name) else { return }
        self.animationImages = images
        self.animationDuration = duration
        self.startAnimating()
    }

    private func loadGifImages(name: String) -> [UIImage]? {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif"),
              let data = NSData(contentsOfFile: path) else { return nil }

        let options = [kCGImageSourceShouldCache as String: kCFBooleanTrue]
        guard let imageSource = CGImageSourceCreateWithData(data, options as CFDictionary) else { return nil }

        var images = [UIImage]()
        let count = CGImageSourceGetCount(imageSource)

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, options as CFDictionary) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
        return images
    }
}
