//
//  ChartView.swift
//  Temperature
//
//  Created by Toksaitov Dmitrii Alexandrovich on 6/27/17.
//  Copyright © 2017 AUCA. All rights reserved.
//

import UIKit

@IBDesignable
class ChartView: UIView {

    @IBInspectable var fillColor = UIColor(red:0.0, green:0.48, blue:1.0, alpha:1.0)
    @IBInspectable var scaleFromHeight = 0.9

    var dataPoints = [Double]() {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard dataPoints.count > 0 else {
            return
        }

        let width  = bounds.width
        let height = bounds.height

        let shift = width / CGFloat(dataPoints.count - 1)
        var position = width

        let scale = CGFloat(scaleFromHeight) * height

        let path = UIBezierPath()
        path.move(to: CGPoint(x: width, y: height))

        dataPoints.forEach { point in
            path.addLine(to: CGPoint(x: position, y: height - CGFloat(point) * scale))
            position -= shift
        }

        path.addLine(to: CGPoint(x: 0.0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.close()

        fillColor.setFill()
        path.fill()
    }

}
