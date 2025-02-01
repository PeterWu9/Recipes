//
//  ImageAssetViewModel.swift
//  Recipes
//
//  Created by Peter Wu on 1/29/25.
//

import Foundation
import ImageLoader
import UIKit

@MainActor
@Observable
final class ImageAssetViewModel {
    private let imageService: any ImageLoaderProtocol<UIImage>
    
    init(imageService: any ImageLoaderProtocol<UIImage>) {
        self.imageService = imageService
    }
    
    func fetchImage(by urlString: String) async -> Result<UIImage, Error> {
        do {
            let (_, image) = try await imageService.fetch(urlString)
            return .success(image)
        } catch {
            // return placeholder
            return .failure(error)
        }
    }
}
