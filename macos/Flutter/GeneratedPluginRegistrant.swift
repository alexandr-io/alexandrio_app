//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import file_chooser
import package_info
import path_provider_macos
import wakelock_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileChooserPlugin.register(with: registry.registrar(forPlugin: "FileChooserPlugin"))
  FLTPackageInfoPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  WakelockMacosPlugin.register(with: registry.registrar(forPlugin: "WakelockMacosPlugin"))
}
