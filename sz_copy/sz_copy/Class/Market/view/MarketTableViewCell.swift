//
//  MarketTableViewCell.swift
//  Exchange
//
//  Created by rui on 2018/5/3.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
import SDWebImage

class MarketTableViewCell: UITableViewCell {
    @IBOutlet weak var firstVavityName: UILabel!
    @IBOutlet weak var lastVavityName: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var exchangeLastPrice: UILabel!
    @IBOutlet weak var increase: UILabel!
    @IBOutlet weak var hourIncrease: UILabel!
    
    var model: TickModel? {
        didSet {
            self.configer()
        }
    }
    var resetCellIcon:(()->())?
    
    @IBOutlet weak var coinImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        increase.layer.cornerRadius = 3
        increase.layer.masksToBounds = true
        
        let view = UIView(frame: self.bounds)
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.backgroundColor = ColorAsset.Block.Red.color
        self.coinImageView.contentScaleFactor = UIScreen.main.scale
    }

    
//    private func
    private func configer() {
        guard let model = self.model else {
            return
        }
        
        self.firstVavityName.text = model.coinPairFirstName
        self.lastVavityName.text = "/" + (model.coinPairLastName ?? "")
        
        let tradeInfoModel = APPTransactionPair.default.tradeInfoModel(tradeCode: model.coinPairLastName ?? "")
        let price = model.price.decimal.roundStr_down(tradeInfoModel?.priceDigit ?? 8)
        self.lastPrice.text = price
        self.lastPrice.textColor = ColorAsset.Text.Level1.color
        self.hourIncrease.text = "24H \(model.day_volume.km)"
        self.increase.backgroundColor = UIColor.clear
        
        if model.day_open.decimal > 0.decimal {
            self.increase.text = "--"
        }else {
            let tempincrease = (model.price.decimal - model.day_open.decimal) * 100.decimal / model.day_open.decimal
            let increase = tempincrease.roundStr_plain(2, suffixZero: true).decimal
            if increase > 0.decimal {
                self.increase.text = increase.roundStr_plain(2, suffixZero: true)
                self.increase.backgroundColor = ColorAsset.Block.Drop.color
            }else if increase < 0.0.decimal {
                self.increase.text = increase.roundStr_plain(2, suffixZero: true)
                self.increase.backgroundColor = ColorAsset.Block.Drop.color
            }else{
                self.increase.text = "0.00%"
                self.increase.backgroundColor = ColorAsset.Block.Drop.color
            }
        }
        
        self.exchangeLastPrice.text = "≈" + (model.money?.szMoneyFormat ?? "--") + UserInfo.default.currency.uppercased()
        let url = APPTransactionPair.default.allCoinDetailModel?[model.coinPairFirstName ?? ""]?.logoUrl
        self.coinImageView.sd_setImage(with: URL(string: url ?? ""), placeholderImage:ImgAsset.coinDefault.image)
        
    }
  
    
}
