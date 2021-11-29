import SwiftUI

struct SimulationOdds: View {
  
  private let simulations: [Simulation]
  private var atLeastOdds: [Float] {
    simulations.atLeastOdds
  }
  
  init(simulations: [Simulation]) {
    self.simulations = simulations
  }
  
  var body: some View {
    VStack {
      Text("At least X wounds:")
      ForEach(Array(zip(atLeastOdds.indices, atLeastOdds)), id: \.0) { index, percent in
        Text("\(index + 1): \(percent, specifier: "%.1f")%")
      }
    }
  }
}

struct SimulationPopup_Previews: PreviewProvider {
  static var previews: some View {
    SimulationOdds(simulations: [])
  }
}
