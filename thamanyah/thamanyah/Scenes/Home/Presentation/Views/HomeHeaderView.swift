//
//  HomeHeaderView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 09/03/2026.
//

import SwiftUI

struct HomeHeaderView: View {
    
    let onProfileTap: () -> Void
    let onSearchTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Avatar
            Button(action: onProfileTap) {
                Circle()
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: SystemIcons.profile)
                            .foregroundStyle(.white)
                            .typography(.title3)
                    }
            }
            
            // Hello Text with Star
            HStack(spacing: 8) {
                Text("Hello")
                    .typography(.title1)
                    .foregroundStyle(.primary)
                
                Image(systemName: SystemIcons.star)
                    .foregroundStyle(.yellow)
                    .typography(.title3)
            }
            
            Spacer()
            
            // Search Button
            Button(action: onSearchTap) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: SystemIcons.search)
                            .foregroundStyle(.black)
                            .typography(.title3)
                    }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(uiColor: .systemBackground))
    }
}

// MARK: - Preview
#Preview {
    HomeHeaderView(
        onProfileTap: {},
        onSearchTap: {}
    )
}
