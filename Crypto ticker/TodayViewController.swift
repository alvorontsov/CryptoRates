//
//  TodayViewController.swift
//  Crypto ticker
//
//  Created by Alexander on 13/06/16.
//  Copyright © 2016 Alexander Vorontsov. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    var pairs : [CopyingPair] = []
    let keys = [ "USDT_BTC",  "USDT_DASH" , "USDT_LTC"  , "USDT_NXT" , "USDT_STR" , "USDT_XMR" , "USDT_XRP" , "USDT_ETH" , "BTC_XEM" , "BTC_LSK" , "BTC_STEEM", "BTC_DAO" , "ETH_DAO" , "ETH_LSK"  ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        unarchivePairs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        getRates()
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 50, 10, 10)
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
        
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.bounds.size.width * 40/400
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wcell", forIndexPath: indexPath) as! CurrencyPairTableViewCell
        cell.linkPair(pairs[indexPath.row])
        if (indexPath.row == pairs.count - 1) {
            updatePreferredContentSize()
        }
        return cell
    }
    
    func getRates() {
        
        let url = NSURL(string: "https://poloniex.com/public?command=returnTicker")!
        let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        request.HTTPMethod = "GET"
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data , response , error) -> Void in
            if ((error == nil)) {
                var json : NSDictionary!
                do {
                    json  = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                }
                catch _ {
                    
                }
                //print(json)
                if (json != nil) {
                    DatabaseManager.sharedAdapter.deletePairs()
                    for key in self.keys {
                        
                        
                        if let pairArray = json.objectForKey(key) as? NSDictionary {
                            
                            print(pairArray)
                            let arr = key.characters.split{$0 == "_"}.map(String.init)
                            let cryptoStr = arr.last!
                            let lowest = Double(pairArray.objectForKey("lowestAsk") as! String)!
                            let highest = Double(pairArray.objectForKey("highestBid") as! String)!
                            let lastPrice = Double(pairArray.objectForKey("last") as! String)!
                            let percentChange = Double(pairArray.objectForKey("percentChange") as! String)!
                            let secondCurrency : String!
                            let index = self.keys.indexOf(key)
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
    
    func keyMatchesKeyPairs(key : String) -> Bool {
        var result = false
        for obj in keys {
            if key == obj {
                result = true
                break
            }
        }
        return result
    }
    
    func unarchivePairs() {
        pairs = []
        let pairsArr = DatabaseManager.sharedAdapter.getPairs()
        for element in pairsArr {
            let pairToAdd = CopyingPair(pair: element)
            pairs.append(pairToAdd)
        }
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
        })
    }
    
    func updatePreferredContentSize() {
        preferredContentSize = tableView.contentSize
    }

    
    

    
    
    
}
