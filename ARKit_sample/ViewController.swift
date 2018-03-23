//
//  ViewController.swift
//  ARKit_sample
//
//  Created by USER on 2018/03/23.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!

    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "ARKit sample"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Table View 表示
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ページ移動
        let sample = menu[(indexPath as NSIndexPath).row]

        navigationController?.pushViewController(sample.getController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //何行分 作成するか？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = menu.count
        
        return rowCount
    }
    
    //各行の内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")

        let sample = menu[(indexPath as NSIndexPath).row]
        
        cell.textLabel!.text = sample.title
        cell.textLabel!.textColor = UIColor.blue
        cell.textLabel!.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel!.textAlignment = NSTextAlignment.left
        
//        cell.detailTextLabel!.text = "ラベルテキスト"
//        cell.detailTextLabel!.textColor = UIColor.yellow
//        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
//        cell.detailTextLabel!.textAlignment = NSTextAlignment.right

        return cell
    }
    
    //RowHeightを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0;//Choose your custom row height
    }
    
}

