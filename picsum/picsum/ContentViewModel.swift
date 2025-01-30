//
//  ContentViewModel.swift
//  picsum
//
//  Created by Adrian Lage Gil on 30/1/25.
//

import SwiftUI


struct Photo: Codable, Identifiable {
    let id: String
    let author: String
    let url: String
    let width: Int
    let height: Int
    let download_url: String
}

class ContentViewwModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    
    private let limit = 10
    
    func fetchPhotos() async {
        
        isLoading = true
        errorMessage = nil
        
        let apiURL = "https://picsum.photos/v2/list?page=\(currentPage)&limit=\(limit)"
        guard let url = URL(string: apiURL) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let newPhotos = try JSONDecoder().decode([Photo].self, from: data)
            
            DispatchQueue.main.async { [self] in
                photos.append(contentsOf: newPhotos)
                currentPage += 1
                isLoading = false
            }
        } catch {
            DispatchQueue.main.async { [self] in
                errorMessage = "Error: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}
