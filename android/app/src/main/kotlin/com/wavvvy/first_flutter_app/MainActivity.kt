package com.wavvvy.first_flutter_app

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // 플러터 프로젝트에서 작성했던 메서드 채널의 키값
    private val CHANNEL = "com.flutter.dev/info"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        // 메서드 채널로 들어오는 요청에 응답
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDeviceInfo") {
                    val deviceInfo = getDeviceInfo()
                    result.success(deviceInfo)
                }
        }
    }

    private fun getDeviceInfo() : String {
        val sb = StringBuffer()
        sb.append(Build.DEVICE+"\n")
        sb.append(Build.BRAND+"\n")
        sb.append(Build.MODEL+"\n")
        return sb.toString()
    }
}
