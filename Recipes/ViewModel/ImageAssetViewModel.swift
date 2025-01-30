//
//  ImageAssetViewModel.swift
//  Recipes
//
//  Created by Peter Wu on 1/29/25.
//

import Foundation
import ImageLoader
import UIKit

@Observable
final class ImageAssetViewModel {
    private let imageService: any ImageLoaderProtocol
    
    init(imageService: any ImageLoaderProtocol) {
        self.imageService = imageService
    }
    
    enum ImageResult {
        case loaded(UIImage)
        case withError(String)
    }
    
    func fetchImage(by urlString: String) async -> ImageResult? {
        do {
            let (_, data) = try await imageService.fetch(urlString)
            guard let image = UIImage(data: data) else {
                return ImageResult
                    .withError("Unable to convert data to image")
            }
            return ImageResult.loaded(image)
        } catch {
            // return placeholder
            return ImageResult.withError(error.localizedDescription)
        }
    }
}
