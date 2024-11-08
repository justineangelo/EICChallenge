//
//  ViewController.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/5/24.
//

import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var contentView: UIView!
    
    private var currentView: UIView?
    
    private let viewModel = ActivityViewModel(activityAPI: NetworkManager.shared)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        Task { await viewModel.initialize()}
    }
}

extension ActivityViewController: ActivityView {
    func reload(_ animation: UIView.AnimationOptions?) {
        let aView: UIView
        switch viewModel.selectedScreen?.type {
        case .multipleChoice:
            aView = ChoiceView(viewModel)
        case .recap:
            aView = RecapView(viewModel)
        case .unknown:
            aView = EmptyView(viewModel)
            print("type: ", viewModel.selectedScreen?.type ?? "")
        case .none:
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.startAnimating()
            aView = activityIndicator
        }
        contentView.addSubview(aView)
        aView.addSideConstraintsWithContainer()
        if let currentView, let animation {
            UIView.transition(from: currentView, to: aView, duration: 0.5, options: animation) {[weak self] _ in
                self?.currentView = aView
            }
        } else {
            currentView = aView
        }
        progressView.progress = viewModel.currentProgress
    }
    
    func showEnd() {
        let alert = UIAlertController(title: "END", message: "No more screens", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Restart", comment: "Default action"), style: .default, handler: { _ in
            Task { await self.viewModel.initialize() }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go to index 0", comment: "Default action"), style: .default, handler: { _ in
            self.viewModel.navigateToIndex(0)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go back", comment: "Default action"), style: .default, handler: { _ in
            self.viewModel.navigateBack(.transitionCurlDown)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

