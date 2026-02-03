import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private let methodChannelName = "mediminder_audio"
  private let eventChannelName = "mediminder_audio_events"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let methodChannel = FlutterMethodChannel(
        name: methodChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      methodChannel.setMethodCallHandler { [weak self] call, result in
        switch call.method {
        case "startRecordingSession":
          self?.startRecordingSession(result: result)
        case "stopRecordingSession":
          self?.stopRecordingSession(result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      let eventChannel = FlutterEventChannel(
        name: eventChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      eventChannel.setStreamHandler(self)
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleInterruption),
      name: AVAudioSession.interruptionNotification,
      object: nil
    )
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startRecordingSession(result: FlutterResult) {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.record, mode: .spokenAudio, options: [.duckOthers])
      try session.setActive(true)
      result(true)
    } catch {
      result(FlutterError(code: "AUDIO_SESSION_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func stopRecordingSession(result: FlutterResult) {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setActive(false, options: [.notifyOthersOnDeactivation])
      result(true)
    } catch {
      result(FlutterError(code: "AUDIO_SESSION_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  @objc private func handleInterruption(notification: Notification) {
    guard let info = notification.userInfo,
          let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
      return
    }

    switch type {
    case .began:
      eventSink?("interruptionBegan")
    case .ended:
      eventSink?("interruptionEnded")
    @unknown default:
      break
    }
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
