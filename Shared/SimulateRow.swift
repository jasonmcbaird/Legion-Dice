import SwiftUI

struct SimulateRow: View {
  private let expectedSimulationCount = 10000 // TODO: Make this configurable
  
  @EnvironmentObject var configuration: Configuration
  @State var simulations: [Simulation] = []
  var completedSimulations: Float {
    Float(simulations.count) / Float(expectedSimulationCount)
  }
  @State var simulationInProgress = false
  
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
        }.disabled(simulationInProgress)
        .foregroundColor(.white)
        .padding()
        .background(simulationInProgress ? Color.gray : Color.blue)
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
