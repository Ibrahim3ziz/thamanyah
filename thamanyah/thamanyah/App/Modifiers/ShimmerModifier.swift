//
//  ShimmerModifier.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

// MARK: - Shimmer Modifier
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        stops: [
                            .init(color: .clear,                          location: 0),
                            .init(color: .white.opacity(0.45),            location: 0.4),
                            .init(color: .white.opacity(0.45),            location: 0.6),
                            .init(color: .clear,                          location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 2.5)
                    .offset(x: phase * geo.size.width * 2.5)
                    .blendMode(.plusLighter)
                }
                    .clipped()
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.4)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
