//
//  RecapView.swift
//  EICChallenge
//
//  Created by Justine Rangel on 11/7/24.
//

import UIKit
import SDWebImage

private extension ActivityChildViewModelProtocol {
    var isCheckEnabled: Bool {
        guard let selectedScreen else { return false }
        return selectedChoices(forScreen: selectedScreen.id).count > 0
    }
    
    var isCorrect: Bool {
        guard let selectedScreen else { return false }
        guard let correctAnswer = selectedScreen.correctAnswer else { return false }
        return selectedChoices(forScreen: selectedScreen.id)[correctAnswer] ?? false
    }
}

class RecapView: UIView {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var mainStack: UIStackView!
    @IBOutlet private weak var recapLabel: UILabel!
    @IBOutlet private weak var fillInLabel: UILabel!
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            let dropInteraction = UIDropInteraction(delegate: self)
            textView.addInteraction(dropInteraction)
            let tap = UITapGestureRecognizer(target: self, action:#selector(textViewTapped(_:)))
            textView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            if let alignedCollectionViewFlowLayout = collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout {
                alignedCollectionViewFlowLayout.horizontalAlignment = .left
                alignedCollectionViewFlowLayout.verticalAlignment = .top
                alignedCollectionViewFlowLayout.minimumLineSpacing = 8.0
                alignedCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
            }
            collectionView.setAutomaticDimension()
            collectionView.registerWithNib(RecapCollectionViewCell.self)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.dragDelegate = self
        }
    }
    @IBOutlet private weak var checkButton: Button!
    @IBOutlet private weak var feedbackSheetView: FeedbackSheetView!{
        didSet {
            feedbackSheetView.onTapped = { [weak self] in
                self?.mainStack.isUserInteractionEnabled = true
                if self?.viewModel.isCorrect ?? false {
                    self?.viewModel.navigateNext(.transitionCurlUp)
                } else {
                    self?.feedbackSheetView.data = Feeback.none
                    self?.feedbackSheetView.reload()
                }
            }
        }
    }
    @IBOutlet private weak var confettiImageView: SDAnimatedImageView! {
        didSet {
            let animatedImage = SDAnimatedImage(named: "confetti.gif")
            confettiImageView.image = animatedImage
            confettiImageView.backgroundColor = .clear
            confettiImageView.isHidden = true
        }
    }
    
    var answerSnapShotImage: UIImage?
    
    let viewModel: ActivityChildViewModelProtocol
    
    init(_ viewModel: ActivityChildViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RecapView")
    }
    
    private func setupUI() {
        loadNib(Self.self)
        addSubview(view)
        view.addSideConstraintsWithContainer()
        let recapAttrString = NSMutableAttributedString(attachment: NSTextAttachment(image: .recap))
        let rattributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.euclid(style: .medium(12)),
            .foregroundColor: UIColor.textRecap,
            .baselineOffset: 4
        ]
        recapAttrString.append(NSAttributedString(string: " RECAP", attributes: rattributes))
        recapLabel.attributedText = recapAttrString
        let fattributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.euclid(style: .medium(18)),
            .foregroundColor: UIColor.textPrimary,
        ]
        fillInLabel.attributedText = NSAttributedString(string: "Fill in the blank", attributes: fattributes)
        
        guard let selectedScreen = viewModel.selectedScreen else { return }
        updateUI(selectedScreen: selectedScreen)
    }
    
    private func updateUI(selectedScreen: Activity.Screen) {
        updateTextView()
        collectionView.reloadData()
        DispatchQueue.main.async {//preload if existing data
            if let indexPath = selectedScreen.answers?.enumerated()
                .filter({ self.viewModel.selectedChoices(forScreen: selectedScreen.id)[$0.element.id] ?? false })
                .map({ IndexPath(row: $0.offset, section: 0)}).first {
                self.collectionView.layoutSubviews()
                if let image = self.collectionView.cellForItem(at: indexPath)?.asImage() {
                    self.answerSnapShotImage = image
                    self.updateTextView()
                }
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            }
        }
        checkButton.isEnabled = viewModel.isCheckEnabled
    }
    
    @objc
    func textViewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedScreen = viewModel.selectedScreen else { return }
        answerSnapShotImage = nil
        updateTextView()
        viewModel.clearChoices(forScreen: selectedScreen.id)
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        checkButton.isEnabled = viewModel.isCheckEnabled
    }
    
    @IBAction func checkTapped(_ sender: Any) {
        mainStack.isUserInteractionEnabled = false
        if viewModel.isCorrect {
            confettiImageView.isHidden = false
            feedbackSheetView.data = .correct(Constants.Activity.feedbackCorrectMessage)
        } else {
            confettiImageView.isHidden = true
            feedbackSheetView.data = .wrong(Constants.Activity.feedbackWrongMessage)
        }
        feedbackSheetView.reload()
    }
    
    private func updateTextView() {
        guard let selectedScreen = viewModel.selectedScreen else { return }
        guard let slices = selectedScreen.body?.components(separatedBy: "%  RECAP  %"), slices.count == 2 else { return }
        let attrText = NSMutableAttributedString(string: slices[0])
        if let answerSnapShotImage {
            attrText.append(NSAttributedString(attachment: NSTextAttachment(image: answerSnapShotImage)))
        } else {
            attrText.append(NSAttributedString(string: "________"))
        }
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 36
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.euclid(style: .regular(22.0)),
            .foregroundColor: UIColor.textPrimary.withAlphaComponent(0.6),
            .paragraphStyle: style
        ]
        attrText.append(NSMutableAttributedString(string: slices[1]))
        attrText.addAttributes(attributes, range: NSRange(location: 0, length: attrText.length))
        textView.attributedText = attrText
        confettiImageView.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource
extension RecapView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedScreen?.answers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RecapCollectionViewCell.self, atIndexPath: indexPath)
        if let selectedScreen = viewModel.selectedScreen, let answer = selectedScreen.answers?[indexPath.row] {
            cell.data = answer
            cell.isSelected = viewModel.selectedChoices(forScreen: selectedScreen.id)[answer.id] ?? false
        } else {
            cell.isSelected = false
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RecapView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let selectedScreen = viewModel.selectedScreen else { return false }
        guard let answerID = selectedScreen.answers?[indexPath.row].id else { return false }
        guard viewModel.selectedChoices(forScreen: selectedScreen.id)[answerID] == nil else { return false } //don't allow selected
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecapCollectionViewCell else { return true }
        answerSnapShotImage = cell.asImage()
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedScreen = viewModel.selectedScreen else { return }
        guard let answer = selectedScreen.answers?[indexPath.row] else { return }
        updateTextView()
        viewModel.selectChoice(answer.id, forScreen: selectedScreen.id)
        checkButton.isEnabled = viewModel.isCheckEnabled
    }
}

// MARK: - UICollectionViewDragDelegate
extension RecapView: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let selectedScreen = viewModel.selectedScreen else { return [] }
        guard let answerID = selectedScreen.answers?[indexPath.row].id else { return [] }
        guard viewModel.selectedChoices(forScreen: selectedScreen.id)[answerID] == nil else { return [] } //don't allow selected
        let itemProvider = NSItemProvider(object: answerID as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: any UIDragSession) {
        guard let indexPath = session.items.first?.localObject as? IndexPath else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecapCollectionViewCell else { return }
        answerSnapShotImage = cell.asImage()
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: any UIDragSession) {
        guard let selectedScreen = viewModel.selectedScreen else { return }
        guard let indexPath = session.items.first?.localObject as? IndexPath else { return }
        guard let answerID = selectedScreen.answers?[indexPath.row].id else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecapCollectionViewCell else { return }
        
        if viewModel.selectedChoices(forScreen: selectedScreen.id)[answerID] == nil {
            cell.isSelected = false
        }
    }
}

// MARK: - UIDropInteractionDelegate
extension RecapView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: any UIDropSession) -> Bool {
        return session.items.count == 1
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: any UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        let operation: UIDropOperation
        if textView.frame.contains(dropLocation) {
            /*
             If you add in-app drag-and-drop support for the .move operation,
             you must write code to coordinate between the drag interaction
             delegate and the drop interaction delegate.
             */
            operation = .move
        } else {
            operation = .cancel
        }
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: any UIDropSession) {
        guard let indexPath = session.items.first?.localObject as? IndexPath else { return }
        guard let selectedScreen = viewModel.selectedScreen else { return }
        guard let answerID = selectedScreen.answers?[indexPath.row].id else { return }
        updateTextView()
        viewModel.selectChoice(answerID, forScreen: selectedScreen.id)
        checkButton.isEnabled = viewModel.isCheckEnabled
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
}
