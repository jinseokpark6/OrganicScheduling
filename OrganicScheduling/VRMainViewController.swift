//
//  VRMainViewController.swift
//  OrganicScheduling
//
//  Created by Jin Seok Park on 1/13/16.
//  Copyright © 2016 jinseokpark. All rights reserved.
//

import UIKit

public final class VRMainViewController: UIViewController {

    public weak var scheduleView: VRScheduleView!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
