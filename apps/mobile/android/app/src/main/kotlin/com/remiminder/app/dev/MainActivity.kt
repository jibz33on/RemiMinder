package com.remiminder.app.dev

import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val methodChannelName = "mediminder_audio"
    private val eventChannelName = "mediminder_audio_events"
    private var audioManager: AudioManager? = null
    private var focusRequest: AudioFocusRequest? = null

    private val focusChangeListener = AudioManager.OnAudioFocusChangeListener { focusChange ->
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS -> sendEvent("audioFocusLoss")
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT -> sendEvent("audioFocusLossTransient")
            AudioManager.AUDIOFOCUS_GAIN -> sendEvent("audioFocusGain")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startRecordingSession" -> {
                        startRecordingForegroundService()
                        requestAudioFocus()
                        result.success(true)
                    }
                    "stopRecordingSession" -> {
                        stopRecordingForegroundService()
                        abandonAudioFocus()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
    }

    private fun startRecordingForegroundService() {
        val intent = Intent(this, RecordingForegroundService::class.java)
        ContextCompat.startForegroundService(this, intent)
    }

    private fun stopRecordingForegroundService() {
        stopService(Intent(this, RecordingForegroundService::class.java))
    }

    private fun requestAudioFocus() {
        audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val attributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_VOICE_COMMUNICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                .build()
            focusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                .setAudioAttributes(attributes)
                .setOnAudioFocusChangeListener(focusChangeListener)
                .build()
            audioManager?.requestAudioFocus(focusRequest!!)
        } else {
            audioManager?.requestAudioFocus(
                focusChangeListener,
                AudioManager.STREAM_MUSIC,
                AudioManager.AUDIOFOCUS_GAIN_TRANSIENT
            )
        }
    }

    private fun abandonAudioFocus() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            focusRequest?.let { audioManager?.abandonAudioFocusRequest(it) }
        } else {
            audioManager?.abandonAudioFocus(focusChangeListener)
        }
    }

    private fun sendEvent(event: String) {
        eventSink?.success(event)
    }

    companion object {
        private var eventSink: EventChannel.EventSink? = null
    }
}

