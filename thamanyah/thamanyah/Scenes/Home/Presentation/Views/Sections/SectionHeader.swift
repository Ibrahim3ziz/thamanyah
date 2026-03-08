//
//  SectionHeader.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                Text(title)
                    .typography(.headline)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Button(action: { onTap?() }) {
                Image(systemName: SystemIcons.chevronRight)
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SectionHeader(title: "Sction Header")
}
