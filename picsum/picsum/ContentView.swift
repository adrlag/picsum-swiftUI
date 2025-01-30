//
//  ContentView.swift
//  picsum
//
//  Created by Adrian Lage Gil on 29/1/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = ContentViewwModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(viewModel.photos) { photo in
                        NavigationLink(destination: PhotoDetailView(photo: photo)) {
                            PhotoItem(photo: photo)
                        }
                        .buttonStyle(PlainButtonStyle())
                            .onAppear {
                                if viewModel.currentPage < 11 {
                                    if photo.id == viewModel.photos.last?.id {
                                        Task {
                                            await viewModel.fetchPhotos()
                                        }
                                    }
                                }
                            }
                    }
                }
            }
            .navigationTitle("Galería")
            .task {
                await viewModel.fetchPhotos()
            }
        }
    }
}

struct PhotoItem: View {
    let photo: Photo
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: photo.download_url)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width/2, height: .random(in: 100...200))
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(height: 200)
            }
            
            Text(photo.author)
                .font(.caption)
                .foregroundColor(.black)
                .padding(.bottom, 5)
        }
    }
}



struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: photo.download_url)) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .frame(height: CGFloat(photo.height))
            }
            Text("\(photo.width) x \(photo.height)")
                .font(.caption)
                .foregroundColor(.gray)
            Text(photo.author)
                .font(.title2)
                .foregroundColor(.black)
                .padding()
            Spacer()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    ContentView()
}
