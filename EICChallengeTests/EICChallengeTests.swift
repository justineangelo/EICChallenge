//
//  EICChallengeTests.swift
//  EICChallengeTests
//
//  Created by Justine Rangel on 11/5/24.
//

import XCTest
@testable import EICChallenge


final class mockAPI: ActivityService {
    var hasError: Bool = false
    
    func getInitialActivity() async throws -> ActivityResponse {
        if hasError {
            throw APIError.unknownError
        }
        return ActivityResponse(
            id: "test",
            state: "unknow",
            stateChangedAt: nil,
            title: "test",
            description: "description", 
            duration: " 3min",
            activity: Activity(screens: [
                Activity.Screen(
                    id: "screen1",
                    type: .multipleChoice,
                    question: "",
                    multipleChoicesAllowed: true, choices: [
                        Activity.Screen.Item(
                            id: "screen1_1",
                            text: "screen1_1",
                            emoji: "👉")],
                    eyebrow: nil, 
                    body: nil,
                    answers: nil,
                    correctAnswer: nil)]))
    }
    
    
}


final class EICChallengeTests: XCTestCase {
    func testAPI() async {
        let api = mockAPI()
        
        
        do {
            let _ = try await api.getInitialActivity()
        } catch {
            XCTFail("no error")
        }
        
        api.hasError = true
        do {
            let _ = try await api.getInitialActivity()
            XCTFail("should throw")
        } catch {
            
        }
    }
    
    @MainActor
    func testViewModel() {
        let api = mockAPI()
        let viewModel = ActivityViewModel(activityAPI: api)
        let screen1ID = "screen_1"
         
        XCTAssert(viewModel.selectedChoices(forScreen: screen1ID).isEmpty)
        
        viewModel.toggleChoice("toggle_1_1", forScreen: screen1ID) //toggle if no object set true, else remove
        XCTAssert(!viewModel.selectedChoices(forScreen: screen1ID).isEmpty)
        
        viewModel.toggleChoice("toggle_1_1", forScreen: screen1ID)
        XCTAssert(viewModel.selectedChoices(forScreen: screen1ID).isEmpty)
        
        viewModel.toggleChoice("toggle_1_1", forScreen: screen1ID)
        viewModel.toggleChoice("toggle_1_2", forScreen: screen1ID)
        viewModel.toggleChoice("toggle_1_3", forScreen: screen1ID)
        XCTAssert(viewModel.selectedChoices(forScreen: screen1ID).count == 3)
        
        viewModel.toggleChoice("toggle_1_2", forScreen: screen1ID)
        XCTAssert(viewModel.selectedChoices(forScreen: screen1ID).count == 2)
        
        viewModel.toggleChoice("toggle_1_3", forScreen: screen1ID)
        XCTAssert(viewModel.selectedChoices(forScreen: screen1ID).count == 1)
        
        let screen2ID = "screen_2"
        viewModel.selectChoice("select_1_1", forScreen: screen2ID) //select overwrites selection, guaranteed one selection
        viewModel.selectChoice("select_1_1", forScreen: screen2ID)
        XCTAssert(viewModel.selectedChoices(forScreen: screen2ID).count == 1)
        
        viewModel.clearChoices(forScreen: screen2ID) //clear selections
        XCTAssert(viewModel.selectedChoices(forScreen: screen2ID).isEmpty)
    }
}
