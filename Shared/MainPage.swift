import SwiftUI

struct MainPage: View {
  
  @StateObject var configuration = Configuration()
  
  let simulations = [Simulation]()
  let averageDamage: Float = 0
  
  var body: some View {
    VStack { // TODO: Nicer UI
      VStack { // TODO: Better deliniation of offense vs defense
        Text("Offense").bold() // TODO: Tighter use of space. Collapsible sections?
        OptionRow(option: $configuration.redOffenseOption)
        OptionRow(option: $configuration.blackOffenseOption)
        OptionRow(option: $configuration.whiteOffenseOption)
        OptionRow(option: $configuration.offensiveSurgeOption)
        OptionRow(option: $configuration.offensiveSurgeTokensOption)
        OptionRow(option: $configuration.criticalOption)
        OptionRow(option: $configuration.pierceOption)
        OptionRow(option: $configuration.preciseOption)
        OptionRow(option: $configuration.aimsOption)
      }.padding()
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.red, lineWidth: 3)
      )
      .padding(.horizontal)
      VStack {
        Text("Defense").bold()
        OptionRow(option: $configuration.coverOption)
        OptionRow(option: $configuration.dodgesOption)
        OptionRow(option: $configuration.saveOption)
        OptionRow(option: $configuration.defensiveSurgeOption)
        OptionRow(option: $configuration.defensiveSurgeTokensOption)
        OptionRow(option: $configuration.armorOption)
        OptionRow(option: $configuration.imperviousOption)
        OptionRow(option: $configuration.dangerSenseOption)
      }.padding()
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.blue, lineWidth: 3)
      )
      .padding(.horizontal)
      Spacer()
      SimulateRow()
        .environmentObject(configuration)
    } // TODO: Frequently used offensive kits (clone Z6 w/surges, rebel DLT, shore T-21, etc.)
    // TODO: Frequently used defensive kits (B1, B2, rebel, imp, clone)
  }
}

struct MainPage_Previews: PreviewProvider {
  static var previews: some View {
    MainPage()
  }
}
