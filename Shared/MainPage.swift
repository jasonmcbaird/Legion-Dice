import SwiftUI

struct MainPage: View {
  
  @StateObject var configuration = Configuration()
  
  @Environment(\.colorScheme) var colorScheme
  let simulations = [Simulation]()
  let averageDamage: Float = 0
  
  var body: some View {
    ScrollView {
      VStack {
        VStack {
          HStack {
            Spacer()
            Spacer()
            Text("Offense")
              .bold()
              .foregroundColor(Color.DarkCompatible.offBlack(colorScheme: colorScheme))
            Spacer()
            Button("Clear") {
              configuration.resetOffense()
            }
          }
          HStack {
            VStack {
              OptionRow(option: $configuration.redOffenseOption, emphasized: true)
              OptionRow(option: $configuration.blackOffenseOption, emphasized: true)
              OptionRow(option: $configuration.whiteOffenseOption, emphasized: true)
              OptionRow(option: $configuration.offensiveSurgeOption, emphasized: true)
              OptionRow(option: $configuration.offensiveSurgeTokensOption, emphasized: false)
              OptionRow(option: $configuration.criticalOption, emphasized: false)
            }
            VStack {
//              Button("Loadouts") { // TODO: Add loadouts
//
//              }
              OptionRow(option: $configuration.aimsOption, emphasized: false)
              OptionRow(option: $configuration.pierceOption, emphasized: false)
              OptionRow(option: $configuration.preciseOption, emphasized: false)
              OptionRow(option: $configuration.impactOption, emphasized: false)
              OptionRow(option: $configuration.ramOption, emphasized: false)
            }
          }
        }.padding(10)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.red, lineWidth: 3)
        )
        .padding(.horizontal, 8)
        VStack {
          HStack {
            Spacer()
            Spacer()
            Text("Defense")
              .bold()
              .foregroundColor(Color.DarkCompatible.offBlack(colorScheme: colorScheme))
            Spacer()
            Button("Clear") {
              configuration.resetDefense()
            }
          }
          HStack {
            VStack {
              OptionRow(option: $configuration.coverOption, emphasized: true)
              OptionRow(option: $configuration.saveOption, emphasized: true)
              OptionRow(option: $configuration.defensiveSurgeOption, emphasized: true)
              OptionRow(option: $configuration.defensiveSurgeTokensOption, emphasized: false)
              OptionRow(option: $configuration.dodgesOption, emphasized: false)
            }
            VStack {
//              Button("Loadouts") {
//
//              }
              OptionRow(option: $configuration.fullArmorOption, emphasized: false)
              OptionRow(option: $configuration.armorXOption, emphasized: false)
              OptionRow(option: $configuration.imperviousOption, emphasized: false)
              OptionRow(option: $configuration.dangerSenseOption, emphasized: false)
              OptionRow(option: $configuration.uncannyLuckOption, emphasized: false)
            }
          }
        }.padding(10)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.blue, lineWidth: 3)
        )
        .padding(.horizontal, 8)
        Spacer()
        SimulateRow()
          .environmentObject(configuration)
        Link(destination: URL(string: "https://www.5280legion.com/")!) {
          Image("5280")
        }
      } // TODO: Frequently used offensive kits (clone Z6 w/surges, rebel DLT, shore T-21, etc.)
      // TODO: Frequently used defensive kits (B1, B2, rebel, imp, clone)
    }
  }
}

struct MainPage_Previews: PreviewProvider {
  static var previews: some View {
    MainPage()
  }
}
