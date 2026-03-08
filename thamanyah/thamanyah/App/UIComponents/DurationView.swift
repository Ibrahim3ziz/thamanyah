//
//  DurationView.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

struct DurationView: View {
    let duration: Int
    
    private var formattedDuration: String {
        let clamped = max(duration, 0)
        return Formatters.briefHM.string(from: TimeInterval(clamped)) ?? "0m"
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: SystemIcons.play)
                .typography(.caption2)
            
            Text(formattedDuration)
                .typography(.caption1)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(white: 0.17))
        .clipShape(Capsule())
    }
}

#Preview {
    DurationView(duration: 5403)
}
