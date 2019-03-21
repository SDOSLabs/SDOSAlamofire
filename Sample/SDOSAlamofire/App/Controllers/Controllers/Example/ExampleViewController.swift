//
//  ExampleViewController.swift
//  SDOSAlamofire
//
//  Created by Antonio Jesús Pallares on 02/07/2019.
//  Copyright © 2019 SDOS. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    
    static let infoSegueIdentifier = "showInfoSegueIdentifier"

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
        loadActionButton()
    }
    
    private func loadActionButton(loading: Bool = false) {
        let btnItem: UIBarButtonItem
        if loading {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            btnItem = UIBarButtonItem(customView: spinner)
        } else {
            btnItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(makeWSCall(_ :)))
        }
        navigationItem.rightBarButtonItem = btnItem
    }
    
    @objc func makeWSCall(_ sender: Any?) {
        LoggingViewManager.cleanLogView()
        loadActionButton(loading: true)
        WS.makeWSCall(configuration: currentConfiguration) {
            self.loadActionButton()
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

