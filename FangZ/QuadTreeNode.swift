//
//  QuadTreeNode.swift
//  AnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit

open class QuadTreeNode {

	static let NodeCapacity = 8
    
    let boundingBox: BoundingBox
	private(set) var annotations: [MKAnnotation] = []

    private(set) var northEast: QuadTreeNode?
    private(set) var northWest: QuadTreeNode?
    private(set) var southEast: QuadTreeNode?
    private(set) var southWest: QuadTreeNode?
    
    // MARK: - Initializers

    init(boundingBox box: BoundingBox) {
		boundingBox = box
    }
    
    // MARK: - Instance functions

	func canAppendAnnotation() -> Bool {
		return annotations.count < QuadTreeNode.NodeCapacity
	}

	func append(annotation: MKAnnotation) -> Bool {
		if canAppendAnnotation() {
			annotations.append(annotation)
			return true
		}
		return false
	}
    
    func isLeaf() -> Bool {
        return (northEast == nil) ? true : false
    }

	func siblings() -> (northEast: QuadTreeNode, northWest: QuadTreeNode, southEast: QuadTreeNode, southWest: QuadTreeNode)? {
		if let northEast = northEast,
		let northWest = northWest,
		let southEast = southEast,
		let southWest = southWest {
			return (northEast, northWest, southEast, southWest)
		} else {
			return nil
		}
	}
    
    func createSiblings() -> (northEast: QuadTreeNode, northWest: QuadTreeNode, southEast: QuadTreeNode, southWest: QuadTreeNode) {
		let box = boundingBox
		northEast = QuadTreeNode(boundingBox: BoundingBox(x0: box.xMid, y0: box.y0, xf: box.xf, yf: box.yMid))
        northWest = QuadTreeNode(boundingBox: BoundingBox(x0: box.x0, y0: box.y0, xf: box.xMid, yf: box.yMid))
        southEast = QuadTreeNode(boundingBox: BoundingBox(x0: box.xMid, y0: box.yMid, xf: box.xf, yf: box.yf))
        southWest = QuadTreeNode(boundingBox: BoundingBox(x0: box.x0, y0: box.yMid, xf: box.xMid, yf: box.yf))

		return (northEast!, northWest!, southEast!, southWest!)
    }
    
}
