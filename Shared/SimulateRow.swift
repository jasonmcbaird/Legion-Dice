//
//  CalculateRow.swift
//  Legion Dice
//
//  Created by Jason Baird on 3/25/21.
//

import SwiftUI

struct SimulateRow: View {
  @EnvironmentObject var configuration: Configuration
  @State var simulations: [Simulation] = []
  var averageDamage: Float {
    guard !simulations.isEmpty else { return 0 }
    return Float(simulations.map { $0.wounds }.reduce(0, +)) / Float(simulations.count)
  }
  
  var body: some View {
    HStack {
      Button("Simulate") {
        simulations = Array(repeating: (), count: 10000).map { Simulation(configuration: configuration) }
      }.foregroundColor(.white)
      .padding()
      .background(Color.blue)
      .cornerRadius(15)
      Text("Average damage: \(averageDamage, specifier: "%.3f")")
    }.padding()
  }
}

struct SimulateRow_Previews: PreviewProvider {
  static var previews: some View {
    SimulateRow()
      .environmentObject(Configuration())
  }
}
