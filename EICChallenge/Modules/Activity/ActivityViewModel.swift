//
//  ActivityViewModel.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/5/24.
//

import Foundation
import UIKit

//can also use closures/callback
@MainActor
protocol ActivityView: AnyObject {
    func reload(_ animation: UIView.AnimationOptions?)
    func showEnd()
    func showError(_ error: String)
}

@MainActor
protocol ActivityNavigation: AnyObject {
    func navigateToIndex(_ index: Int)
    func navigateNext(_ animation: UIView.AnimationOptions?)
    func navigateBack(_ animation: UIView.AnimationOptions?)
}

@MainActor
protocol ActivityChildViewModelProtocol: AnyObject, ActivityNavigation {
    var selectedScreen: Activity.Screen? { get }
    
    func toggleChoice(_ choiceID: String, forScreen id: String) //mutiple selection
    func selectChoice(_ choiceID: String, forScreen id: String) //single selection
    func clearChoices(forScreen id: String) //remove all choices
    func selectedChoices(forScreen id: String) -> [String: Bool]
}

protocol ActivityViewModelProtocol: ActivityNavigation, ActivityChildViewModelProtocol {
    var currentProgress: Float { get }
    func initialize() async
}

final class ActivityViewModel: ActivityViewModelProtocol {
    private var screens: [Activity.Screen] = []
    private var screenIndex = -1
    private lazy var screenChoices = [String: [String: Bool]]()
    
    var currentProgress: Float {
        guard !screens.isEmpty else { return 0.0 }
        return Float(screenIndex + 1)/Float(screens.count)
    }
    
    var selectedScreen: Activity.Screen? {
        screens.isEmpty ? nil: screens[screenIndex]
    }
    
    weak var view: ActivityView? {
        didSet {
            view?.reload(nil)
        }
    }
    
    private let activityAPI: ActivityService
    
    
    init(activityAPI: ActivityService = NetworkManager.shared) {
        self.activityAPI = activityAPI
    }
    
    func initialize() async {
        screenChoices = [:]
        do {
            screens = try await activityAPI.getInitialActivity().activity.screens
//            screenIndex = 3
            screenIndex = 0
        } catch {
            view?.showError(error.localizedDescription)
        }
        view?.reload(.transitionCrossDissolve)
    }
    
    func toggleChoice(_ choiceID: String, forScreen id: String) {
        var storedChoices = screenChoices[id] ?? [:]
        if storedChoices[choiceID] != nil {
            storedChoices.removeValue(forKey: choiceID)
        } else {
            storedChoices[choiceID] = true
        }
        screenChoices[id] = storedChoices
    }
    
    func selectChoice(_ choiceID: String, forScreen id: String) {
        screenChoices[id] = [choiceID: true]
    }
    
    func clearChoices(forScreen id: String) {
        screenChoices[id] = [:]
    }
    
    func selectedChoices(forScreen id: String) -> [String: Bool] {
        return screenChoices[id] ?? [:]
    }
    
    func navigateToIndex(_ index: Int) {
        guard index < screens.count else { return }
        screenIndex = index
        view?.reload(.transitionCrossDissolve)
    }
    
    func navigateNext(_ animation: UIView.AnimationOptions?) {
        guard screens.count > (screenIndex+1) else {
            print("navigateNext() end")
            view?.showEnd()
            return
        }
        screenIndex += 1
        print("navigateNext() screenIndex: ", screenIndex)
        view?.reload(.transitionCurlUp)
    }
    
    func navigateBack(_ animation: UIView.AnimationOptions?) {
        guard screens.count > 0 && screenIndex > 0 else {
            print("navigateBack() end")
            return
        }
        screenIndex -= 1
        print("navigateBack() screenIndex: ", screenIndex)
        view?.reload(.transitionCurlDown)
    }
}
