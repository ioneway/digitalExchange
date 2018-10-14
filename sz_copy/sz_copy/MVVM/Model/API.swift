//
//
//  Created by 王伟 on 2018/9/2.
//  Copyright © 2017年 JianweiWang. All rights reserved.
//

import Foundation
import Moya

enum API {
    case AllTradeInfo               //根据币种查询币对列表
    case AllCoinOtcDetail           //法币支持的币种
    case AllCoinDetail              //币币支持的币种
    case Banner                     //首页轮播图
    case AnnouncementList           //获取首页公告
    case TodayDividendTotal      //获取今日分配收益
    case YesterdayDividendTotal  //获取昨日分配收益
    case ExchangeTotal           //获取挖矿汇总信息
}

extension API: TargetType {
    
    var baseURL: URL {
        return URL(string: ServerFactory.default.server(identifier: .app).baseurl)!
    }
    
    var path: String {
        switch self {
        case .AllTradeInfo:
            return "/tradeInfo/allTradeInfo"
        case .AllCoinOtcDetail:
            return "/coin/otc/all/detail"
        case .AllCoinDetail:
            return "/coin/all/detail"
        case .Banner:
            return "/v1/banner/"
        case .AnnouncementList:
            return "/v1/announcement/list"
        case .TodayDividendTotal:
            return "/v1/dividend_total/get_today_dividend_total"
        case .YesterdayDividendTotal:
            return "/v1/dividend_total/get_yesterday_dividend_total"
        case .ExchangeTotal:
            return "/v1/sz_total/get_exchage_total"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Moya.Data {
        switch self {
        case .AllTradeInfo, .AllCoinOtcDetail, .AllCoinDetail, .Banner, .AnnouncementList, .TodayDividendTotal, .YesterdayDividendTotal, .ExchangeTotal:
            
            return "".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json",
                "x-user-env-info": "ios" + App.UUID,
                "Authorization": "Bearer \(UserInfo.default.token ?? "")",
                "User-Agent": App.Agent];
    }
}


private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

let SZProvider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
