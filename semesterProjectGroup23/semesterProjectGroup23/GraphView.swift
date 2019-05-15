//
//  GraphView.swift
//  semesterProjectGroup23
//
//  Created by Oliver Bentham on 4/24/19.
//  Copyright © 2019 Oliver Bentham. All rights reserved.
//

import Foundation
import UIKit

// this class will control the graph in the StockController

class GraphView: UIView {

	var graphPoints: [Float] = []
	var mode: viewMode = .year
	
	func updateData(data: [Float], viewMode: viewMode) {

        print (viewMode)
        graphPoints = data
		mode = viewMode
	}
	
	private struct Constants {
		static let margin: CGFloat = 20.0
		static let topBorder: CGFloat = 60
		static let bottomBorder: CGFloat = 50
		static let colorAlpha: CGFloat = 0.3
		//static let circleDiameter: CGFloat = 5.0
	}
	
	var baseColor: UIColor = #colorLiteral(red: 0.1605761051, green: 0.1642630696, blue: 0.1891490221, alpha: 1)
	
	override func draw(_ rect: CGRect) {
		
		if graphPoints.count > 0 {
			
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
			
			//add axis labels
			
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.alignment = .left
			
			let attributes: [NSAttributedString.Key : Any] = [
				.paragraphStyle: paragraphStyle,
				.font: UIFont.systemFont(ofSize: 12.0),
				.foregroundColor: UIColor.white
			]
			
			var modeText = getAxisText(mode: mode)
			
			let labelGap = (width - 2 * margin) / CGFloat(modeText.count)
			
			for i in 0..<modeText.count {
				let attributedString = NSAttributedString(string: modeText[i], attributes: attributes)
				let stringRect = CGRect(x: margin + (CGFloat(i) * labelGap), y: height - bottomBorder + 5, width: width - 2 * margin, height: bottomBorder)
				attributedString.draw(in: stringRect)
			}
		}
	}
}

func getAxisText(mode: viewMode) -> [String] {
	var modeText = [String]()
	var revModeText = [String]()
	
	let dateFormatter = DateFormatter()
	
	var currDate = Date()
	let calendar = Calendar.current
	
	if mode == .day {
		dateFormatter.dateFormat = "ha"
		
		revModeText.append(dateFormatter.string(from: currDate).lowercased())
		for _ in 0..<3 {
			currDate = calendar.date(byAdding: .hour, value: -6, to: currDate)!
			revModeText.append(dateFormatter.string(from: currDate).lowercased())
		}
	} else if mode == .week {
		dateFormatter.dateFormat = "EEE"
		
		revModeText.append(dateFormatter.string(from: currDate).lowercased())
		for _ in 0..<6 {
			currDate = calendar.date(byAdding: .day, value: -1, to: currDate)!
			revModeText.append(dateFormatter.string(from: currDate).lowercased())
		}
	} else if mode == .month {
		dateFormatter.dateFormat = "M/d"
		
		revModeText.append(dateFormatter.string(from: currDate))
		for _ in 0..<3 {
			currDate = calendar.date(byAdding: .day, value: -7, to: currDate)!
			revModeText.append(dateFormatter.string(from: currDate))
		}
	} else if mode == .year {
		dateFormatter.dateFormat = "MMM"
		
		// begin with month prior to current month
		var newDate = calendar.date(byAdding: .month, value: -1, to: currDate)!
		
		revModeText.append(dateFormatter.string(from: newDate).lowercased())
		for _ in 0..<5 {
			newDate = calendar.date(byAdding: .month, value: -2, to: newDate)!
			revModeText.append(dateFormatter.string(from: newDate).lowercased())
		}
	}
	
	
	for arrayIndex in stride(from: revModeText.count - 1, through: 0, by: -1) {
		modeText.append(revModeText[arrayIndex])
	}
	
	return modeText
}
