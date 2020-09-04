package me.jiahuan.flutter.host.android

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        id_open_flutter_button.setOnClickListener {
            startActivity(
                FlutterActivity.withCachedEngine("flutter_engine").build(this)
            )
        }
    }
}