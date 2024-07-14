//
//  TimerLights.swift
//  F1 Start Timer
//
//  Created by Fardin Kamal on 12/7/24.
//

import SwiftUI

struct TimerLights: View {
    @EnvironmentObject var sharedProperties: SharedProperties

    var body: some View {
        ZStack{
            // Put the stick on background
            Rectangle()
                .fill(Color.black)
                .frame(width: 500, height: 20)
            // Squared light boxes
            HStack{
                ForEach(1..<6) {_ in
                    ZStack{
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        VStack{
                            // Circular lights
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 70)
                                .padding(14)
                                .labelsHidden()
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 70)
                                .padding(14)
                                .labelsHidden()
                            Circle()
                                .fill(sharedProperties.countdownLightColor)
                                .frame(width: 70)
                                .padding(14)
                                .labelsHidden()
                            Circle()
                                .fill(sharedProperties.countdownLightColor)
                                .frame(width: 70)
                                .padding(14)
                                .labelsHidden()
                            
                        }
                    }
                    .padding(10)    // Padding between light bars
                }
            }
        }
    }
}


#Preview {
    TimerLights()
}
