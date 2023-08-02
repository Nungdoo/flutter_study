package com.wavvvy.first_flutter_app

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Base64

class MainActivity: FlutterActivity() {
    // 플러터 프로젝트에서 작성했던 메서드 채널의 키값
    private val CHANNEL = "com.flutter.dev/info"
    private val CHANNEL2 = "com.flutter.dev/encrypto"

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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2)
            .setMethodCallHandler { call, result ->
                if (call.method == "getEncrypto") {
                    // call.arguments : 플러터가 전달한 데이터, 모든 형태의 데이터를 전달받을 수 있도록 Any 객체임
                    val data = call.arguments.toString().toByteArray();
                    val changeText = Base64.encodeToString(data, Base64.DEFAULT)
                    result.success(changeText)
                } else if (call.method == "getDecode") {
                    val changedText = Base64.decode(call.arguments.toString(), Base64.DEFAULT)
                    result.success(String(changedText))
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
