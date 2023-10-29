//
//  HeroesViewController.swift
//  DragonBall
//
//  Created by Gabriel Castro on 18/10/23.
//

import UIKit

// MARK: - View Protocol -
protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    
    func heroesCount() -> Int
    func onViewAppear()
    func heroBy(index: Int) -> Hero?
    func logOut()
    func heroDetailViewModel(index: Int) -> HeroDetailViewControllerDelegate
    func loginViewModel() -> LoginViewControllerDelegate
    func mapViewModel() -> MapViewControllerDelegate
}

// MARK: - View State -
enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
    case logout
    case network
}

// MARK: - Class -
class HeroesViewController: UIViewController {
    // MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!

    // MARK: - Public Properties -
    var viewModel: HeroesViewControllerDelegate?

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        initViews()
        setObservers()
        viewModel?.onViewAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HEROES_TO_HERO_DETAIL" {
           guard let index = sender as? Int,
              let heroDetailViewController = segue.destination as? HeroDetailViewController,
              let detailViewModel = viewModel?.heroDetailViewModel(index: index) else {
            return
        }

        heroDetailViewController.viewModel = detailViewModel
    }
    
        if segue.identifier == "HEROES_TO_MAP" {
            guard let mapViewController = segue.destination as? MapViewController,
                  let mapViewModel = viewModel?.mapViewModel() else {
                return
        }
        
        mapViewController.viewModel = mapViewModel
    }
    
        if segue.identifier == "HEROES_TO_LOGIN" {
            guard let loginViewController = segue.destination as? LoginViewController,
              let loginViewModel = viewModel?.loginViewModel() else {
            return
        }

        loginViewController.viewModel = loginViewModel
    }
}
    
    // MARK: - Actions -
    
    @IBAction func didTapMapButton(_ sender: Any) {
        performSegue(withIdentifier: "HEROES_TO_MAP", sender: nil)
    }
    
    @IBAction func didTapLogOutButton(_ sender: Any) {
        performSegue(withIdentifier: "HEROES_TO_LOGIN", sender: nil)
    }
    
    
    

    // MARK: - Private functions -
    private func initViews() {
        tableView.register(
            UINib(nibName: HeroCellView.identifier, bundle: nil),
            forCellReuseIdentifier: HeroCellView.identifier
        )

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setObservers() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    case .loading(let isLoading):
                        self?.loadingView.isHidden = !isLoading

                    case .updateData:
                        self?.tableView.reloadData()
                case .logout:
                    self?.navigationController?.popViewController(animated: true)
                    break
                case .network:
                    self?.navigationController?.popViewController(animated: true)
                    break
                }
            }
        }
    }
}

extension HeroesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount() ?? 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        HeroCellView.estimatedHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroCellView.identifier,
                                                       for: indexPath) as? HeroCellView else {
            return UITableViewCell()
        }

        if let hero = viewModel?.heroBy(index: indexPath.row) {
            cell.updateView(
                name: hero.name,
                photo: hero.photo,
                description: hero.description
            )
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HEROES_TO_HERO_DETAIL",
                     sender: indexPath.row)
    }
}
