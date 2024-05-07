//
//  DealQuestionaireCollectionViewCell.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/6/22.
//

import UIKit
protocol DealQuestionDelegate : AnyObject {
    func didTapYesButton(cell: DealQuestionaireCollectionViewCell)
    func didTapNoButton(cell: DealQuestionaireCollectionViewCell)
}
class DealQuestionaireCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var yesRadioButton: UIButton!
    @IBOutlet weak var noRadioButton: UIButton!
    @IBOutlet weak var yesImageView: UIImageView!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    var delegate : DealQuestionDelegate?
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        delegate?.didTapYesButton(cell: self)
    }
    @IBAction func noButtonTapped(_ sender: UIButton) {
        delegate?.didTapNoButton(cell: self)
    }
}

