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
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var statusSeverityLabel: UILabel!
    @IBOutlet var statusSeverityDescriptionLabel: UILabel!
    
    var selectedRoad: Road? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        scrollView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
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
        titleLabel.text = selectedRoad?.displayName ?? NSLocalizedString("TFL Coding Challenge", comment: "Default view title")
        statusSeverityLabel.text = selectedRoad?.statusSeverity ?? NSLocalizedString("No road selected", comment: "Default subtitle")
        statusSeverityDescriptionLabel.text = selectedRoad?.statusSeverityDescription ?? NSLocalizedString("No road selected", comment: "Default subtitle")
        textField?.text = nil
        
        var infoColour: UIColor?
        
        switch self.selectedRoad?.statusSeverity {
        case "Good":
            infoColour = UIColor.corporateGreen()
        case "Closure":
            infoColour = UIColor.corporateRed()
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

// MARK: Search text and API request
extension ViewController: UITextFieldDelegate {
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        let insets = scrollView.contentInset
        scrollView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, rect.height + 12.0, insets.right)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @IBAction func dismissKeyboard() {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
        
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        
        activityIndicator.startAnimating()
        
        Road.get(id: text, api: APIClientLive()) { (success, roads, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.selectedRoad = roads?.first
                if let error = error {
                    let alert = UIAlertController(title: "Sorry", message: error.statusMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    
}
