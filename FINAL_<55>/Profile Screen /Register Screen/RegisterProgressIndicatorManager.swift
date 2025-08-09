//
//  RegisterProgressIndicatorManager.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/21/24.
//

import Foundation

extension SignUpViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
