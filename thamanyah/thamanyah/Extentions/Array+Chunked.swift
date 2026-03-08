//
//  Array+Chunked.swift
//  thamanyah
//
//  Created by Ibrahim Abdul Aziz on 07/03/2026.
//

import Foundation

extension Array {
    /// Splits the array into chunks of the given size. The last chunk may be smaller.
    /// - Parameter size: The maximum size of each chunk. Must be greater than 0.
    /// - Returns: An array of chunked arrays.
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var result: [[Element]] = []
        result.reserveCapacity((count + size - 1) / size)
        var i = 0
        while i < count {
            let end = Swift.min(i + size, count)
            result.append(Array(self[i..<end]))
            i = end
        }
        return result
    }
}
