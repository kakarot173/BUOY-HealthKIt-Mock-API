//
//  StepCountTile.swift
//  Buoy
//
//  Created by Animesh Mohanty on 28/08/24.
//

import SwiftUI

struct StepCountTile: View {
    var stepCount: StepCount
    var isSelected: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Text("Steps: \(stepCount.count)")
                .font(.headline)
            Text("Time: \(ISO8601DateFormatterHelper.shared.formattedTime(from: stepCount.startDate ?? Date()))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.3) : Color(.systemGray6))
        .cornerRadius(8)
        .frame(maxWidth: 800)
    }
    
}

