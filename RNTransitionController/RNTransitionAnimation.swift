//
//  RNTransitionAnimation.swift
//  RNTransitionController
//
//  Created by Rayhan Janam on 6/27/18.
//  Copyright © 2018 Rayhan Janam. All rights reserved.
//

import Foundation


/// Type of transitions available when a view controller
/// is presented modally
///
/// - coverVertical: Provides default cover transition sliding from the bottom
/// - coverHorizontal: Provides cover transition sliding from the left
/// - fadeIn: Provides a fade-in transition
/// - fadeInWithSubviewZoomIn: Provides a fade-in transition with a zoom-in animation for the subview
/// - slideIn: Provides a slide-in transition
public enum RNTransitionAnimation {
    case coverVertical
    case coverHorizontal
    case fadeIn
    case fadeInWithSubviewZoomIn
    case slideIn
    case slideFromTopToBottom
}
