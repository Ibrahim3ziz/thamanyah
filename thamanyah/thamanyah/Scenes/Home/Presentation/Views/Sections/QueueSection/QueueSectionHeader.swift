//
//  QueueSectionHeader.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

// MARK: - Custom Header for Queue Section
struct QueueSectionHeader: View {
    let title: String
    let itemCount: Int
    let totalDuration: Int
    var onSeeAll: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .typography(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(itemCount) episodes -> \(totalDuration)")
                    .typography(.caption1)
                    .foregroundColor(.black)
                    .onTapGesture { onSeeAll?() }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    QueueSectionHeader(
        title: "Queue Section Header",
        itemCount: 234,
        totalDuration: 43566
    )
}
