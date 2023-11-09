import Flutter
import UIKit

public class SazzHealthPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sazz_health", binaryMessenger: registrar.messenger())
    let instance = SazzHealthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "requestAuthorization":
      HealthManager.requestAuthorization { data, error in
        if error == nil {
          result(true)
        } else {
          result(false)
        }
      }
    case "readNumberOfFallen":
      if call.arguments != nil {
        let args = call.arguments as! Dictionary<String, String>
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let fromDate = dateFormatter.date(from: args["fromDate"]!) ?? Date()
        let toDate = dateFormatter.date(from: args["toDate"]!) ?? Date()
        HealthManager.readNumberOfFallen(startDate: fromDate, endDate: toDate) { json, error in
          if error == nil {
            result(json)
          } else {
            result("[]")
          }
        }
      } else {
        result("[]")
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
