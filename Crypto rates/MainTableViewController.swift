//
//  MainTableViewController.swift
//  Crypto rates
//
//  Created by Alexander on 08/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}




let MTVCTableViewDataKey = "MTVCData"

class MainTableViewController: UITableViewController {


    var pairs : [CopyingPair] = []
    let keys = [ "USDT_BTC",  "USDT_DASH" , "USDT_LTC"  , "USDT_NXT" , "USDT_STR" , "USDT_XMR" , "USDT_XRP" , "USDT_ETH" , "BTC_XEM" , "BTC_LSK" , "BTC_STEEM" , "BTC_DAO" , "ETH_DAO" , "ETH_LSK"  ]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        unarchivePairs()
        getRates()
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.gray
        refreshControl!.addTarget(self, action: #selector(self.getRates), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getRates() {
        
        let url = URL(string: "https://poloniex.com/public?command=returnTicker")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        request.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data , response , error) -> Void in
            if ((error == nil)) {
                var json : NSDictionary!
                do {
                    json  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                }
                catch _ {
                    
                }
                //print(json)
                if (json != nil) {
                    DatabaseManager.sharedAdapter.deletePairs()
                    self.refreshControl?.endRefreshing()
                for key in self.keys {
                    
                    
                    if let pairArray = json.object(forKey: key) as? NSDictionary {
                    
                        print(pairArray)
                        let arr = key.characters.split{$0 == "_"}.map(String.init)
                        let cryptoStr = arr.last!
                        let lowest = NSNumber(value: Double(pairArray.object(forKey: "lowestAsk") as! String)!)
                        let highest = NSNumber(value: Double(pairArray.object(forKey: "highestBid") as! String)!)
                        let lastPrice = NSNumber(value: Double(pairArray.object(forKey: "last") as! String)!)
                        let percentChange = NSNumber(value: Double(pairArray.object(forKey: "percentChange") as! String)!)
                        let secondCurrency : String!
                        let index = self.keys.index(of: key)
                        if (index < 8) {
                            secondCurrency = "USD"
                        }
                        else if (index > 11){
                            secondCurrency = "ETH"
                        }
                        else {
                            secondCurrency = "BTC"
                        }
                        DatabaseManager.sharedAdapter.addPair(cryptoStr, secondCurrency: secondCurrency, lastPrice: lastPrice, percentChange: percentChange , lowest: lowest, highest: highest)
                    }
                    
                }
                self.unarchivePairs()
                
                
            }
            }
        })
        dataTask.resume()

    }
    
    func keyMatchesKeyPairs(_ key : String) -> Bool {
        var result = false
        for obj in keys {
            if key == obj {
                result = true
                break
            }
        }
        return result
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "extcell", for: indexPath) as! ExtendedCurrencyTableViewCell
        cell.linkPair(pairs[indexPath.row])

        return cell
    }
    
    func unarchivePairs() {
        pairs = []
        let pairsArr = DatabaseManager.sharedAdapter.getPairs()
        for element in pairsArr {
            let pairToAdd = CopyingPair(pair: element!)
            pairs.append(pairToAdd)
        }
        OperationQueue.main.addOperation({
            self.tableView.reloadData()
        })
    }

    
}
