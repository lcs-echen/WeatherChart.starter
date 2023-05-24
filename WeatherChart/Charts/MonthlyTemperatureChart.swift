/// Copyright (c) 2022 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import Charts

struct MonthlyTemperatureChart: View {
  var measurements: [DayInfo]

  func measurementsByMonth(_ month: Int) -> [DayInfo] {
    return self.measurements.filter {
      Calendar.current.component(.month, from: $0.date) == month + 1
    }
  }

  var body: some View {
    NavigationView {
      monthlyAvgTemperatureView
    }
    .navigationTitle("Monthly Temperature")
  }

  var monthlyAvgTemperatureView: some View {
    List(0..<12) { month in
      let destination = WeeklyTemperatureChart(measurements: measurements, month: month)
      NavigationLink(destination: destination) {
        VStack {
          Chart(measurementsByMonth(month)) { dayInfo in
            LineMark(
              x: .value("Day", dayInfo.date),
              y: .value("Temperature", dayInfo.temp(type: .avg))
            )
            .foregroundStyle(.orange)
            .interpolationMethod(.catmullRom)
          }
          .chartForegroundStyleScale([
            TemperatureTypes.avg.rawValue: .orange
          ])
          .chartXAxisLabel("Weeks", alignment: .center)
          .chartYAxisLabel("ºF")
          .chartXAxis {
            AxisMarks(values: .automatic(minimumStride: 7)) { _ in
              AxisGridLine()
              AxisTick()
              AxisValueLabel(
                format: .dateTime.week(.weekOfMonth)
              )
            }
          }
          .chartYAxis {
            AxisMarks( preset: .extended, position: .leading)
          }

          Text(Calendar.current.monthSymbols[month])
        }
        .frame(height: 150)
      }
    }
    .listStyle(.plain)
  }
}

struct MonthlyTemperatureChart_Previews: PreviewProvider {
  static var previews: some View {
    // swiftlint:disable force_unwrapping
    MonthlyTemperatureChart(
      measurements: WeatherInformation()!.stations[2].measurements)
  }
}

