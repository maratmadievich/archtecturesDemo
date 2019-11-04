//
//  PlayingState.swift
//  iOSArchitecturesDemo
//
//  Created by Mac on 03.11.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

enum PlayingState {
    case stop
    case pause(progress: Int)
    case isPlaying(progress: Int)
    case completed
}
