//
//  AnnotationClusterView.swift
//  AppPrototype
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit

class AnnotationClusterView : MKAnnotationView {

	private var configuration: AnnotationViewConfiguration

	let countLabel: UILabel = {
		let label = UILabel()
		label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		label.textAlignment = .center
		label.backgroundColor = UIColor.clear
		label.textColor = UIColor.white
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 2
		label.numberOfLines = 1
		label.baselineAdjustment = .alignCenters
		return label
	}()

	override var annotation: MKAnnotation? {
		didSet {
			updateClusterSize()
		}
	}

	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		self.configuration = AnnotationViewConfiguration.default()
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		self.setupView()
	}

    required public init?(coder aDecoder: NSCoder) {
		self.configuration = AnnotationViewConfiguration.default()
        super.init(coder: aDecoder)
		self.setupView()
    }
    
    private func setupView() {
		backgroundColor = UIColor.clear
		layer.borderColor = UIColor.white.cgColor
		addSubview(countLabel)
    }

	private func updateClusterSize() {
		if let cluster = annotation as? AnnotationCluster {

            var count: Int = 0
            for annotation in cluster.annotations {
                if let fbAnnotation = annotation as? Annotation {
                    count += fbAnnotation.numberOfElement
                }
            }
            
			let template = configuration.templateForCount(count: count)

			switch template.displayMode {
			case .Image(let imageName):
				image = UIImage(named: imageName)
				break
			case .SolidColor(let sideLength, let color):
				backgroundColor	= color
				frame = CGRect(origin: frame.origin, size: CGSize(width: sideLength, height: sideLength))
				break
			}

			layer.borderWidth = template.borderWidth
			countLabel.font = template.font
			countLabel.text = "\(count)"

			setNeedsLayout()
		}
	}

    override public func layoutSubviews() {
		super.layoutSubviews()
		countLabel.frame = bounds
		layer.cornerRadius = image == nil ? bounds.size.width / 2 : 0
    }
}
