//
//  Font+Extensions.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import SwiftUI
import UIKit

// MARK: - App Typography
public enum Typography: CaseIterable {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case subheadline
    case body
    case callout
    case footnote
    case caption1
    case caption2
    
    var weight: UIFont.Weight {
        switch self {
        case .largeTitle: return .bold
        case .title1: return .semibold
        case .title2: return .semibold
        case .title3: return .semibold
        case .headline: return .semibold
        case .subheadline: return .regular
        case .body: return .regular
        case .callout: return .regular
        case .footnote: return .regular
        case .caption1: return .regular
        case .caption2: return .regular
        }
    }
    
    // Base point sizes
    var pointSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .subheadline:
            return 15
        case .body:
            return 17
        case .callout:
            return 16
        case .footnote:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
        }
    }
    
    var textStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title1:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .body:
            return .body
        case .callout:
            return .callout
        case .footnote:
            return .footnote
        case .caption1:
            return .caption1
        case .caption2:
            return .caption2
        }
    }
}

// MARK: - Custom Font Family
private enum AppFontFamily: String {
    case regular = "IBMPlexSansArabic-Regular"
    case semibold = "IBMPlexSansArabic-SemiBold"
    case bold = "IBMPlexSansArabic-Bold"
}

private func resolveUIFont(for style: Typography) -> UIFont {
    let metrics = UIFontMetrics(forTextStyle: style.textStyle)
    
    let base: UIFont
    switch style.weight {
    case .bold:
        if !AppFontFamily.bold.rawValue.isEmpty, let f = UIFont(name: AppFontFamily.bold.rawValue, size: style.pointSize) {
            base = f
        } else {
            base = .systemFont(ofSize: style.pointSize, weight: .bold)
        }
    case .semibold:
        if !AppFontFamily.semibold.rawValue.isEmpty, let f = UIFont(name: AppFontFamily.semibold.rawValue, size: style.pointSize) {
            base = f
        } else {
            base = .systemFont(ofSize: style.pointSize, weight: .semibold)
        }
    default:
        if !AppFontFamily.regular.rawValue.isEmpty, let f = UIFont(name: AppFontFamily.regular.rawValue, size: style.pointSize) {
            base = f
        } else {
            base = .systemFont(ofSize: style.pointSize, weight: .regular)
        }
    }
    
    return metrics.scaledFont(for: base, compatibleWith: UITraitCollection(preferredContentSizeCategory: .unspecified))
}

// MARK: - UIKit Convenience
public extension UIFont {
    static func app(_ style: Typography) -> UIFont {
        resolveUIFont(for: style)
    }
}

// MARK: - SwiftUI Convenience
public extension Font {
    static func app(_ style: Typography) -> Font {
        Font(UIFont.app(style))
    }
}

public struct TypographyModifier: ViewModifier {
    let style: Typography
    
    public func body(content: Content) -> some View {
        content
            .font(.app(style))
            .environment(\.dynamicTypeSize, .large)
    }
}

public extension View {
    func typography(_ style: Typography) -> some View {
        self.modifier(TypographyModifier(style: style))
    }
}

// MARK: - Previews
#Preview("Typography Preview") {
    VStack(alignment: .leading, spacing: 8) {
        Text("Large Title").typography(.largeTitle)
        Text("Title 1").typography(.title1)
        Text("Title 2").typography(.title2)
        Text("Title 3").typography(.title3)
        Text("Headline").typography(.headline)
        Text("Subheadline").typography(.subheadline)
        Text("Body").typography(.body)
        Text("Callout").typography(.callout)
        Text("Footnote").typography(.footnote)
        Text("Caption 1").typography(.caption1)
        Text("Caption 2").typography(.caption2)
    }
    .padding()
}
