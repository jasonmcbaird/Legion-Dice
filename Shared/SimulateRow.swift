//
//  CalculateRow.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import SwiftUI

struct SimulateRow: View {
  private let expectedSimulationCount = 5000
  
  @EnvironmentObject var configuration: Configuration
  @State var simulations: [Simulation] = []
  var completedSimulations: Float {
    Float(simulations.count) / Float(expectedSimulationCount)
  }
  @State var simulationInProgress = true
  
  var averageDamage: Float {
    guard !simulations.isEmpty else { return 0 }
    return Float(simulations.map { $0.wounds }.reduce(0, +)) / Float(simulations.count)
  }
  
  var body: some View {
    HStack {
      VStack {
        Button("Simulate") {
          simulations = []
          simulationInProgress = true
          DispatchQueue(label: "Simulate").async {
            for _ in 0..<expectedSimulationCount {
              simulations.append(Simulation(configuration: configuration))
            }
            simulationInProgress = false
          }
        }.foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(15)
        ProgressView(value: completedSimulations)
          .progressViewStyle(LinearProgressViewStyle())
          .cornerRadius(5)
          .opacity(simulationInProgress ? 1 : 0)
      }
      Spacer()
      Text("Average Wounds: \(averageDamage, specifier: "%.3f")")
    }.padding()
  }
}

struct SimulateRow_Previews: PreviewProvider {
  static var previews: some View {
    SimulateRow()
      .environmentObject(Configuration())
  }
}
