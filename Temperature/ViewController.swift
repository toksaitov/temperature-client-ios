//
//  ViewController.swift
//  Temperature
//
//  Created by Toksaitov Dmitrii Alexandrovich on 6/26/17.
//  Copyright © 2017 AUCA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var chartView: ChartView!

    weak var timer: Timer?;

    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
    }

    deinit {
        stopTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.loadData()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
    }

    private func loadData() {
        let url = URL(string: "http://temperature.auca.space/measurements?limit=100")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                NSLog(error.debugDescription)
                return
            }
            guard let data = data else {
                NSLog("Failed to get any data")
                return
            }

            let text = String(data: data, encoding: String.Encoding.utf8)!
            let lines = text.components(separatedBy: "\n")

            guard lines.count > 0 else {
                NSLog("Nothing to show")
                return
            }

            let components = lines.first!.components(separatedBy: ",")
            guard components.count > 2 else {
                NSLog("The data has invalid format")
                return
            }

            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(components[1]) °C"
                self.humidityLabel.text = "humidity at \(components[2])%"
            }

            var points = [Double]()

            lines.forEach { line in
                guard !line.isEmpty else {
                    return
                }

                let components = line.components(separatedBy: ",")
                guard components.count > 2 else {
                    NSLog("The data has invalid format")
                    return
                }
                guard let temperature = Double(components[2]) else {
                    NSLog("Failed to parse the temperature data")
                    return
                }

                points.append(temperature)
            }

            guard points.count > 0 else {
                NSLog("No data points to process")
                return
            }

            let minimum = 0.0
            let maximum = 20.0
            let difference = maximum - minimum

            points = points.map { point -> Double in
                return difference == 0.0 ? 0.0 : (point - minimum) / difference
            }

            DispatchQueue.main.async {
                self.chartView.dataPoints = points
            }
        }.resume()
    }

}

