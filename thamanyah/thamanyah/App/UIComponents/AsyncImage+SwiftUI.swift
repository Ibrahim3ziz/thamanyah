//
//  AsyncImage.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

// MARK: - AsyncImage
struct AsyncImage: View {
    let url: URL?
    var size: CGFloat? = 140
    var cornerRadius: CGFloat = 16
    
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.3))
                    .shimmer()
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .task(id: url) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        image = nil
        guard let url else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloaded = UIImage(data: data) {
                image = downloaded
            }
        } catch {
            if !(error is CancellationError) {
#if DEBUG
                print("⚠️ Failed to load image: \(error.localizedDescription)")
#endif
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 16) {
        AsyncImage(
            url: URL(string: "https://media.npr.org/assets/img/2024/01/11/podcast-politics_2023_update1_sq-be7ef464dd058fe663d9e4cfe836fb9309ad0a4d.jpg"))
    }
    .padding()
    .background(Color.black)
}
