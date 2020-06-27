//
//  ProgressView.swift
//  ContactClassroom
//
//  Created by Jal Irani on 6/25/20.
//  Copyright © 2020 Jal Irani. All rights reserved.
//

import SwiftUI

struct ProgressView: View {
    @State var progressValue: Float = 0.53
    
    var body: some View {
        VStack {
            VStack {
                Text("Contact Card")
                    .font(.system(size: 45, weight: .bold, design: .default))
                    .foregroundColor(Color.black)
                Text("Below is your score for the last 24 hours")
                    .font(.system(size: 10, weight: .semibold, design: .default))
                ProgressBar(progress: self.$progressValue)
                    .frame(width: 175.0, height: 175.0)
                    .padding(40.0)
            }
            VStack {
                HStack {
                    Text("Last 24 hours")
                    .font(.system(size: 17, weight: .black, design: .default))
                    .frame(alignment: .leading)
                    Spacer()
                }
                Spacer()
                    .frame(height: 5)
                HStack {
                    Text("7800 York Rd")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Text("5")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                }
                HStack {
                    Text("Hawkings Hall")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Text("2")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                }
                HStack {
                    Text("Stephens Hall")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Text("7")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                }
                HStack {
                    Text("Union Garage")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Text("2")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                }
                HStack {
                    Text("Burdick Hall")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Text("10")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                }
                HStack {
                    Text("University Union")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Text("8")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                }
                HStack {
                    Text("Freedom Square")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    Spacer()
                    Text("3")
                        .padding(.horizontal)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                }

                HStack {
                    Text("Average")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .frame(alignment: .leading)
                    Spacer()
                    Text("5.3")
                    .padding(.horizontal)
                    .font(.system(size: 15, weight: .bold, design: .default))
                }
            }
            Divider()
            VStack (alignment: .leading) {
                Text("Recommendations")
                .font(.system(size: 17, weight: .black, design: .default))
                .frame(alignment: .leading)
                Text("Based on your campus activity, you should avoid walking through Freedom sqaure to get to Stephens Hall. Using the pathway near Liberal Arts building should accomplish this.")
                    .padding(.horizontal)
                    .font(.system(size: 15, weight: .medium, design: .default))
                .frame(alignment: .leading)
            }
            Spacer()
        }
    }
    
    func incrementProgress() {
        let randomValue = Float([0.012, 0.022, 0.034, 0.016, 0.11].randomElement()!)
        self.progressValue += randomValue
    }
}
struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.green)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
