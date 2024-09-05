//
//  StepCountDashboardView.swift
//  Buoy
//
//  Created by Animesh Mohanty on 28/08/24.
//

import SwiftUI

struct StepCountDashboardView: View {
    @State private var selectedRange = DateRange.query1
    @StateObject private var viewModel = StepCountViewModel()  // Using @StateObject to ensure single instance
    
    var body: some View {
        VStack {
            Text("Step Count Dashboard")
                .font(.title)
                .padding(.top)
            
            Picker("Date Range", selection: $selectedRange) {
                ForEach(DateRange.allCases, id: \.self) { range in
                    Text(range.displayText).tag(range)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Pass the viewModel to the StepCountDisplayView
            StepCountDisplay(selectedRange: $selectedRange, viewModel: viewModel)
            
            Spacer()
        }
        
    }
    
}


#Preview {
    StepCountDashboardView()
}
