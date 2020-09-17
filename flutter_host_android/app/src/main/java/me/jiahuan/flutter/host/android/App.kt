package me.jiahuan.flutter.host.android

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class App : Application() {


    override fun onCreate() {
        super.onCreate()
        val flutterEngine = FlutterEngine(this)

        flutterEngine.navigationChannel.setInitialRoute("/test_page")

        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        FlutterEngineCache
            .getInstance()
            .put("flutter_engine", flutterEngine)
    }
}