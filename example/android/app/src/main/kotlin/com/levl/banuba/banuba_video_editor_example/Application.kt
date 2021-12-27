package com.levl.banuba.banuba_video_editor_example

import com.levl.banuba.banuba_video_editor_example.banuba.di.VideoEditorKoinModule
import com.banuba.sdk.arcloud.di.ArCloudKoinModule
import com.banuba.sdk.effectplayer.adapter.BanubaEffectPlayerKoinModule
import com.banuba.sdk.export.di.VeExportKoinModule
import com.banuba.sdk.gallery.di.GalleryKoinModule
import com.banuba.sdk.token.storage.di.TokenStorageKoinModule
import com.banuba.sdk.ve.di.VeSdkKoinModule
import io.flutter.app.FlutterApplication
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class Application : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        startKoin {
            androidContext(this@Application)

            modules(
                VeSdkKoinModule().module,
                VeExportKoinModule().module,
                ArCloudKoinModule().module,
                TokenStorageKoinModule().module,
                VideoEditorKoinModule().module,
                BanubaEffectPlayerKoinModule().module,
                GalleryKoinModule().module
            )
        }
    }
}