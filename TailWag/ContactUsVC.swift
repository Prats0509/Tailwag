//
//  contactUsVC.swift
//  TailWag
//


import UIKit
import MapKit

class ContactUsVC: UIViewController, MKMapViewDelegate {
    @IBAction func mainMenuTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToMainMenuPagefromContact", sender: self)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

                
                mapView.delegate = self

                
                let locations = [
                    ["title": "Sunnyvale Center", "latitude": 37.3688, "longitude": -122.0363],
                    ["title": "Cupertino Center", "latitude": 37.3229, "longitude": -122.0322],
                    ["title": "Santa Clara Center", "latitude": 37.3541, "longitude": -121.9552]
                ]

                
                for location in locations {
                    let annotation = MKPointAnnotation()
                    annotation.title = location["title"] as? String
                    if let latitude = location["latitude"] as? CLLocationDegrees,
                       let longitude = location["longitude"] as? CLLocationDegrees {
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    }
                    mapView.addAnnotation(annotation)
                }

                
                if let firstLocation = locations.first,
                   let latitude = firstLocation["latitude"] as? CLLocationDegrees,
                   let longitude = firstLocation["longitude"] as? CLLocationDegrees {
                    let region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                    mapView.setRegion(region, animated: true)
                }
            }

            
            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                let identifier = "CenterPin"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true

                    
                    annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                } else {
                    annotationView?.annotation = annotation
                }

                return annotationView
            }

            func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                if let annotationTitle = view.annotation?.title {
                    print("Tapped on annotation: \(annotationTitle ?? "No Title")")
                }
            }

    
}

