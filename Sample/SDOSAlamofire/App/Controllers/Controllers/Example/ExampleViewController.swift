//
//  ExampleViewController.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 02/07/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import UIKit

enum ButtonType {
    case jsonapi, play
}

class ExampleViewController: UIViewController {
    
    static let infoSegueIdentifier = "showInfoSegueIdentifier"
    var jsonapiButton: UIBarButtonItem?
    var playButton: UIBarButtonItem?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    lazy var currentConfiguration: WSConfiguration = ExampleSection.initialConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStyle()
    }
    
    private func loadStyle() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(back(_ :)))
        jsonapiButton = UIBarButtonItem(customView: getButtonForJSONAPI())
        playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(makeWSCall(_ :)))
        navigationItem.rightBarButtonItems = ([playButton, jsonapiButton] as! [UIBarButtonItem])
    }
    
    private func getButtonForJSONAPI() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("JSON:API", for: .normal)
        button.addTarget(self, action: #selector(makeJSONAPIWSCall(_ :)), for: .touchUpInside)
        return button
    }
    
    private func loadActionButton(loading: Bool = false, btnType: ButtonType) {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        
        var index: Int = 0
        var barItem: UIBarButtonItem
        
        switch btnType {
        case .jsonapi:
            index = (navigationItem.rightBarButtonItems?.firstIndex(of: jsonapiButton!))!
            if loading {
                jsonapiButton = UIBarButtonItem(customView: spinner)
            } else {
                jsonapiButton = UIBarButtonItem(customView: getButtonForJSONAPI())
            }
            barItem = jsonapiButton!
        case .play:
            index = (navigationItem.rightBarButtonItems?.firstIndex(of: playButton!))!
            if loading {
                playButton = UIBarButtonItem(customView: spinner)
            } else {
                playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(makeWSCall(_ :)))
            }
            barItem = playButton!
        }
        
        navigationItem.rightBarButtonItems![index] = barItem
    }
    
    @objc func makeWSCall(_ sender: Any?) {
        LoggingViewManager.cleanLogView()
        loadActionButton(loading: true, btnType: .play)
        WS.makeWSCall(configuration: currentConfiguration) {
            self.loadActionButton(btnType: .play)
            LoggingViewManager.presentLoggingView(in: self)
        }
    }
    
    @objc func makeJSONAPIWSCall(_ sender: Any?) {
        LoggingViewManager.cleanLogView()
        loadActionButton(loading: true, btnType: .jsonapi)
        JSONAPI.makeWSCall {
            self.loadActionButton(btnType: .jsonapi)
            LoggingViewManager.presentLoggingView(in: self)
        }
    }
    
    @objc func back(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    private func didReceiveTextToShow() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let infoModel = sender as? InfoModel,
            let infoVC = segue.destination as? InfoViewController
            else { return }
        infoVC.model = infoModel
    }
}

extension ExampleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentConfiguration.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentConfiguration[section].numberOfRows
    }
    
    
    static let cellIdentifier = "cellIdentifier"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = type(of: self).cellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = currentConfiguration[indexPath.section].text(for: indexPath.row)
        cell.accessoryType = .detailButton
        return cell
    }
    
}

extension ExampleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentConfiguration[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentConfiguration[indexPath.section].changeAt(index: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: type(of: self).infoSegueIdentifier, sender: currentConfiguration[indexPath.section].infoModel(atIndex: indexPath.row))
    }
    
}

