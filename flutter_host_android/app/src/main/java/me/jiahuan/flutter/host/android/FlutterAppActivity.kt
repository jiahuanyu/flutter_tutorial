package me.jiahuan.flutter.host.android

import io.flutter.embedding.android.FlutterActivity

class FlutterAppActivity : FlutterActivity() {

    override fun getCachedEngineId(): String? {
        return "flutter_engine"
    }

    override fun getInitialRoute(): String {
        return "/test_page"
    }
}