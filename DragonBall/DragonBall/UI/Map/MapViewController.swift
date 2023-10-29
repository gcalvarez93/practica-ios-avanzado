//
//  MapViewController.swift
//  DragonBall
//
//  Created by Gabriel Castro on 29/10/23.
//

import UIKit
import MapKit

// MARK: - Delegate -
protocol MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)? { get set }
    
    func handleViewDidLoad()
    func navigateToHeroDetail(of id: String)
    func heroDetailViewModel(hero: Hero) -> HeroDetailViewControllerDelegate
}

// MARK: - View State -
enum MapViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
    case navigateToHeroDetail(hero: Hero)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var loadingView: UIView!
    
    var viewModel: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        self.initView()
        self.setObservers()
        self.viewModel?.handleViewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MAP_TO_HERO_DETAIL" {
            guard let hero = sender as? Hero,
                  let heroDetailViewController = segue.destination as? HeroDetailViewController,
                  let detailViewModel = viewModel?.heroDetailViewModel(hero: hero) else {
                return
            }
            
            heroDetailViewController.viewModel = detailViewModel
        }
    }
    
    
    @IBAction func didTappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Functions -
    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading
                        break
                    case .update(hero: let hero, locations: let locations):
                        self?.updateViews(hero: hero, heroLocations: locations)
                        break
                    case .navigateToHeroDetail(hero: let hero):
                        self?.performSegue(withIdentifier: "MAP_TO_HERO_DETAIL", sender: hero)
                        break
                }
            }
        }
    }
    
    private func initView() {
        mapView.delegate = self
    }
    
    private func updateViews(hero: Hero?, heroLocations: HeroLocations) {
        heroLocations.forEach { heroLocation in
            mapView.addAnnotation(
                MapAnnotation(
                    title: hero?.name,
                    info: hero?.id,
                    coordinate: .init(
                        latitude: Double(heroLocation.latitude ?? "") ?? 0.0,
                        longitude: Double(heroLocation.longitude ?? "") ?? 0.0
                    )
                )
            )
        }
    }
}

// MARK: - Extensions -
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let pin = annotation as? MapAnnotation else {
            return
        }
        self.viewModel?.navigateToHeroDetail(of: pin.info ?? "")
    }
    
}
