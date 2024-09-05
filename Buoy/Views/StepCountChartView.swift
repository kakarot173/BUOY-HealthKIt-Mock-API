//
//  StepCountChartView.swift
//  Buoy
//
//  Created by Animesh Mohanty on 28/08/24.
//

import SwiftUI
import Charts

struct StepCountChartView: View {
    var stepCounts: [StepCount]
    @State private var selectedPoint: StepCount?
    @Binding var selectedStepCount: StepCount?
    var body: some View {
        Chart {
            ForEach(stepCounts) { stepCount in
                LineMark(
                    x: .value("Time", stepCount.startDate ?? Date(), unit: .minute),
                    y: .value("Steps", stepCount.count)
                )
                .symbol(Circle())
                .symbolSize(selectedStepCount == stepCount ? 200 : 60)
                .foregroundStyle(.blue)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(formattedTime(forXAxis: date))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(Color.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let location = value.location
                                if let date: Date = proxy.value(atX: location.x),
                                   let stepCount = findClosestDataPoint(to: date, location: location, in: proxy, geo: geo) {
                                    selectedPoint = stepCount
                                } else {
                                    selectedPoint = nil
                                }
                            }
                    )
            }
        }
        .overlay {
            if let selected = selectedPoint {
                let date = selected.startDate ?? Date()
                let count = selected.count
                
                VStack {
                    Text("Time: \(ISO8601DateFormatterHelper.shared.formattedTime(from: date))").font(.caption)
                    Text("Steps: \(count)")
                }
                .padding(8)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .transition(.scale)
                .offset(x: 0, y: -100) // Adjust position relative to the selected dot
            }
        }
        .onChange(of: selectedStepCount) { _ in
                    selectedPoint = nil // Clear the tooltip when a tile is selected
                }
    }
    
    private func findClosestDataPoint(to date: Date, location: CGPoint, in proxy: ChartProxy, geo: GeometryProxy) -> StepCount? {
        let tolerance: CGFloat = 20 // Adjust the sensitivity as needed
        
        return stepCounts.first(where: { stepCount in
            if let xPos = proxy.position(forX: stepCount.startDate ?? Date()), let yPos = proxy.position(forY: stepCount.count) {
                let point = CGPoint(x: xPos, y: yPos)
                return abs(location.x - point.x) < tolerance && abs(location.y - point.y) < tolerance
            }
            return false
        })
    }
    
    
    private func formattedTime(forXAxis date: Date) -> String {
        let formatter = ISO8601DateFormatterHelper.shared.configuredDateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}


