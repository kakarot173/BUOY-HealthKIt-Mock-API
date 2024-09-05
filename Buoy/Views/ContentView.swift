//
//  ContentView.swift
//  Buoy
//
//  Created by Animesh Mohanty on 23/08/24.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        TabView {
            StepCountDashboardView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Dashboard")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            
        }
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Work in Progress")
            .navigationTitle("Profile")
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

