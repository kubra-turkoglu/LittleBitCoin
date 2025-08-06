//
//  BitcoinViewController.swift
//  littleBitCoin
//
//  Created by Kubra Bozdogan on 12/11/24.
//

import UIKit
import Foundation

class BitcoinViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding set the ViewController class as the datasource to the currencyPicker object.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        backgroundImage.alpha = 0.3
    }
    
}
//MARK: -CoinManagerDelegate
extension BitcoinViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: -UIPickerView DataSource & Delegate
extension BitcoinViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    //to determine how many columns we want in our picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //how many rows this picker should have using the pickerView:numberOfRowsInComponent: method.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        return coinManager.getCoinPrice(for: selectedCurrency)
    }
    func pickerView(_ pickerView: UIPickerView,
                    attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        
        let title = coinManager.currencyArray[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 20) // istersen boyunu da ayarla
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}

