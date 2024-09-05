//
//  StepCountDisplay.swift
//  Buoy
//
//  Created by Animesh Mohanty on 28/08/24.
//

import SwiftUI

struct StepCountDisplay: View {
    @Binding var selectedRange: DateRange
    @ObservedObject var viewModel: StepCountViewModel
    
    @State private var dataReady: [DateRange: Bool] = [:]  // Keep track of readiness per segment
    @State private var selectedStepCount: StepCount?
    var body: some View {
        VStack(alignment: .leading) {
            Text("Steps")
                .font(.headline)
                .padding(.top, 20)
            
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding(.top, 20)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 20)
            } else if dataReady[selectedRange] == true {
                if viewModel.stepCounts.isEmpty {
                    Text("No data available for this range")
                        .padding(.top, 20)
                } else {
                    Text("\(viewModel.totalSteps) steps")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                    
                    Text("Range: \(selectedRange.displayText)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    StepCountChartView(stepCounts: viewModel.stepCounts, selectedStepCount: $selectedStepCount)
                        .frame(height: 200)
                        .padding(.top, 20)
                    Spacer(minLength: 10)
                    List(viewModel.stepCounts) { stepCount in
                        StepCountTile(stepCount: stepCount, isSelected: stepCount == selectedStepCount)
                            .listRowSeparator(.hidden) // Hides the divider lines
                            .frame(maxWidth: .infinity) // Ensure the tile is centered
                            .padding(.vertical, -5)
                            .onTapGesture {
                                selectedStepCount = stepCount
                            }
                        // Adjust vertical padding as needed
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .padding()
        .onAppear {
            fetchData()
        }
        .onChange(of: selectedRange) { _ in
            fetchData()
        }
    }
    
    private func fetchData() {
        dataReady[selectedRange] = false  // Reset readiness for the selected segment
        viewModel.fetchStepCounts(for: selectedRange) { item in
            // Mark the data as ready only for the selected segment
            dataReady[selectedRange] = true
            print("test items:\(item)")
        }
    }
}

//#Preview {
//    StepCountDisplay()
//}
