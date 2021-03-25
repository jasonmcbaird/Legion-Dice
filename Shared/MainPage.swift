//
//  ContentView.swift
//  Shared
//
//  Created by Jason Baird on 3/25/21.
//

import SwiftUI

struct MainPage: View {
  
  @StateObject var configuration = Configuration()
  
  let simulations = [Simulation]()
  let averageDamage: Float = 0
  
  var body: some View {
    VStack {
      VStack {
        Text("Offense").bold()
        OptionRow(option: $configuration.redOffenseOption)
        OptionRow(option: $configuration.blackOffenseOption)
        OptionRow(option: $configuration.whiteOffenseOption)
        OptionRow(option: $configuration.offensiveSurgeOption)
        OptionRow(option: $configuration.offensiveSurgeTokensOption)
      }
      VStack {
        Text("Defense").bold()
        OptionRow(option: $configuration.coverOption)
        OptionRow(option: $configuration.saveOption)
        OptionRow(option: $configuration.defensiveSurgeOption)
        OptionRow(option: $configuration.defensiveSurgeTokensOption)
      }
      Spacer()
      SimulateRow()
        .environmentObject(configuration)
    }
  }
}

struct MainPage_Previews: PreviewProvider {
  static var previews: some View {
    MainPage()
  }
}
