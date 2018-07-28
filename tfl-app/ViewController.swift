//
//  ViewController.swift
//  tfl-app
//
//  Created by Julian Jans on 26/07/2018.
//  Copyright © 2018 Julian Jans. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // Initializer for the APIClient, uses the mock API for testing environments.
    // In a larger project this would be shared across the app, and not coupled to a view controller like this.
    lazy var apiClient: APIClient = {
        if ProcessInfo.processInfo.arguments.contains("APIClientMock") {
            return APIClientMock()
        } else {
            return APIClientLive()
        }
    }()
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var statusSeverityLabel: UILabel!
    @IBOutlet var statusSeverityDescriptionLabel: UILabel!
    
    var selectedRoad: Road? {
        didSet {
            configureView()
        }
    }
    
    var roads = [Road]() {
        didSet {
            picker.reloadAllComponents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        scrollView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(self, selector: #selector(self.getData), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { (_) in
            self.setMap(bounds: self.selectedRoad?.bounds, animated: true)
        }
    }
    
}

// MARK: Info view and map configuration
extension ViewController {
    
    func configureView() {
        
        setMap(bounds: selectedRoad?.bounds, animated: true)
        statusSeverityLabel.text = selectedRoad?.statusSeverity ?? NSLocalizedString("No road selected", comment: "Default subtitle")
        statusSeverityDescriptionLabel.text = selectedRoad?.statusSeverityDescription ?? NSLocalizedString("No road selected", comment: "Default subtitle")
        
        var infoColour: UIColor?
        
        // Potential values taken from: https://api.tfl.gov.uk/Road/Meta/Severities
        switch self.selectedRoad?.statusSeverity {
        case "Good", "No Issues", "Minimal", "No Exeptional Delays":
            infoColour = UIColor.corporateGreen()
        case "Closure", "Severe", "Serious":
            infoColour = UIColor.corporateRed()
        case "Moderate":
            infoColour = UIColor.corporateYellow()
        default:
            infoColour = UIColor.corporateBlue()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.infoView.backgroundColor = infoColour
            self.view.backgroundColor = infoColour
        }
    }
    
    func setMap(bounds: (nw: CLLocationCoordinate2D, se: CLLocationCoordinate2D)?, animated: Bool) {
        // If no specific bounds are provided use bounds of London
        let p1 = MKMapPointForCoordinate(bounds?.nw ?? CLLocationCoordinate2D(latitude: 51.75, longitude: -0.65));
        let p2 = MKMapPointForCoordinate(bounds?.se ?? CLLocationCoordinate2D(latitude: 51.25, longitude: 0.45 ));
        let mapRect = MKMapRectMake(fmin(p1.x,p2.x), fmin(p1.y,p2.y), fabs(p1.x-p2.x), fabs(p1.y-p2.y))
        mapView.setVisibleMapRect(mapRect, animated: animated)
    }
    
}

// MARK: UIPickerView
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roads.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let name = roads[row].displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRoad = roads[row]
    }

}

// MARK: Fetching data
extension ViewController {
    
    @objc func getData() {
        picker.isUserInteractionEnabled = false
        Road.get(id: nil, api: apiClient) { (roads, error) in
            DispatchQueue.main.async {
                self.picker.isUserInteractionEnabled = true
                self.roads = roads ?? [Road]()
                self.selectedRoad = roads?.filter({$0.id == self.selectedRoad?.id}).first ?? roads?.first
                if let error = error {
                    let alert = UIAlertController(title: NSLocalizedString("Sorry", comment: "Warning message"), message: error.statusMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Warning acceptance"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}
