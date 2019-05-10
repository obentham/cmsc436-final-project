//
//  GraphView.swift
//  semesterProjectGroup23
//
//  Created by Oliver Bentham on 4/24/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import Foundation
import UIKit

// the class below is commented out so I could see
// what the home page of the app looks like when it runs

// this class will control the graph in the StockController

@IBDesignable class GraphView: UIView {
	
	private struct Constants {
		static let margin: CGFloat = 20.0
		static let topBorder: CGFloat = 60
		static let bottomBorder: CGFloat = 50
		static let colorAlpha: CGFloat = 0.3
		//static let circleDiameter: CGFloat = 5.0
	}
	
	var baseColor: UIColor = #colorLiteral(red: 0.1605761051, green: 0.1642630696, blue: 0.1891490221, alpha: 1)
	
	// sample data
	var graphPoints: [Float] = [18.35, 16.33, 16.01, 12.55, 21.98, 28.61, 23.03, 21.52, 22.38, 17.92, 21.25, 13.95, 11.5, 28.87, 21.89, 12.87, 27.1, 28.65, 21.8, 22.26, 14.83, 26.05, 20.83, 21.19, 20.11, 29.12, 24.85, 23.37, 20.13, 16.29, 20.63, 16.98, 12.4, 13.58, 10.29, 10.27, 15.61, 19.99, 14.43, 13.67, 19.87, 23.68, 24.47, 22.25, 19.11, 18.95, 13.35, 26.24, 27.18, 18.28]
	
	override func draw(_ rect: CGRect) {
		
		let width = rect.width
		let height = rect.height
		
		baseColor.setFill()
		
		let path = UIBezierPath(rect: rect)
		path.addClip()
		path.fill()
		
		//calculate the x point
		let margin = Constants.margin
		let columnXPoint = { (column:Int) -> CGFloat in
			//Calculate gap between points
			let spacer = (width - margin * 2 - 4) / CGFloat((self.graphPoints.count - 1))
			var x: CGFloat = CGFloat(column) * spacer
			x += margin + 2
			return x
		}
		
		// calculate the y point
		let topBorder: CGFloat = Constants.topBorder
		let bottomBorder: CGFloat = Constants.bottomBorder
		let graphHeight = height - topBorder - bottomBorder
		let maxValue = graphPoints.max()!
		let columnYPoint = { (graphPoint:Int) -> CGFloat in
			var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
			y = graphHeight + topBorder - y // Flip the graph
			return y
		}
		
		// draw the line graph
		UIColor.white.setFill()
		UIColor.white.setStroke()
		
		//set up the points line
		let graphPath = UIBezierPath()
		//go to start of line
		graphPath.move(to: CGPoint(x:columnXPoint(0), y:columnYPoint(Int(graphPoints[0]))))
		
		//add points for each item in the graphPoints array
		//at the correct (x, y) for the point
		for i in 1..<graphPoints.count {
			let nextPoint = CGPoint(x:columnXPoint(i), y:columnYPoint(Int(graphPoints[i])))
			graphPath.addLine(to: nextPoint)
		}
		
		//draw the line on top of the clipped gradient
		graphPath.lineWidth = 2.0
		graphPath.stroke()
		
		//Draw the circles on top of graph stroke
		/*for i in 0..<graphPoints.count {
			var point = CGPoint(x:columnXPoint(i), y:columnYPoint(Int(graphPoints[i])))
			point.x -= Constants.circleDiameter / 2
			point.y -= Constants.circleDiameter / 2
			
			let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
			circle.fill()
		}*/
		
		//TODO: align these lines with some standard partition
		
		//Draw horizontal graph lines on the top of everything
		let linePath = UIBezierPath()
		
		//top line
		linePath.move(to: CGPoint(x:margin, y: topBorder))
		linePath.addLine(to: CGPoint(x: width - margin, y:topBorder))
		
		//center line
		linePath.move(to: CGPoint(x:margin, y: graphHeight/2 + topBorder))
		linePath.addLine(to: CGPoint(x:width - margin, y:graphHeight/2 + topBorder))
		
		//bottom line
		linePath.move(to: CGPoint(x:margin, y:height - bottomBorder))
		linePath.addLine(to: CGPoint(x:width - margin, y:height - bottomBorder))
		let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
		color.setStroke()
		
		linePath.lineWidth = 1.0
		linePath.stroke()
		
		//TODO: add vertical lines
		
		//TODO: add axis labels
		
		//TODO: add toggles for different time increments
	}
}

