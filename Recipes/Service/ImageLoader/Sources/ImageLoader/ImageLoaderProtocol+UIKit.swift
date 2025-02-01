//
//  File.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/31/25.
//

import UIKit
extension ImageLoaderProtocol {
    public static func transform(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.failToConvertImageFrom(data)
        }
        return image
    }
}
