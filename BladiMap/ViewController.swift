//
//  ViewController.swift
//  BladiMap
//
//  Created by Abdel Ali on 10/7/20.
//  Copyright © 2020 Abdel Ali. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = self
        view.addSubview(mapView)

        let gridOverlay = GridTileOverlay()
        gridOverlay.canReplaceMapContent = false
        mapView.addOverlay(gridOverlay, level: .aboveLabels)

        let bladiOverlay = BladiTileOverlay()
        bladiOverlay.canReplaceMapContent = true
        mapView.insertOverlay(bladiOverlay, below: gridOverlay)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer(overlay: overlay)
        }

        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
}

class GridTileOverlay : MKTileOverlay {

    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {

        let size = self.tileSize
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)


        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!

        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1)
        context.stroke(rect)

        let text = NSString(format: "X=%d\nY=%d\nZ=%d", path.x, path.y, path.z)
        text.draw(in: rect, withAttributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 12)])

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        result(image!.pngData(), nil)
    }
}


class BladiTileOverlay : MKTileOverlay {

    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        if let cusomTileUrl = Bundle.main.url(forResource: String(path.x), withExtension: "png", subdirectory: "MA/\(path.z)/\(path.y)/") {
            return cusomTileUrl
        }

        return URL(string: "https://mts1.google.com/vt/lyrs=m&hl=en&x=\(path.x)&y=\(path.y)&z=\(path.z)")!
    }
}
