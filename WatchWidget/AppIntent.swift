//
//  AppIntent.swift
//  WatchWidget
//
//  Created by Julia Grill on 14.06.24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("SwiftExperiencer")
}
