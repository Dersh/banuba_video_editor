package com.levl.banuba.banuba_video_editor_example.banuba.di

import android.content.Context
import android.net.Uri
import androidx.core.net.toUri
import com.levl.banuba.banuba_video_editor_example.banuba.export.IntegrationAppExportParamsProvider
import com.banuba.sdk.cameraui.data.CameraTimerStateProvider
import com.banuba.sdk.export.data.ExportFlowManager
import com.banuba.sdk.export.data.ExportParamsProvider
import com.banuba.sdk.export.data.ForegroundExportFlowManager
import com.banuba.sdk.ve.effects.WatermarkProvider
import com.banuba.sdk.ve.flow.FlowEditorModule
import com.banuba.sdk.veui.domain.CoverProvider
import org.koin.core.definition.BeanDefinition
import org.koin.core.qualifier.named

/**
 * All dependencies mentioned in this module will override default
 * implementations provided from SDK.
 * Some dependencies has no default implementations. It means that
 * these classes fully depends on your requirements
 */
class VideoEditorKoinModule : FlowEditorModule() {

    val exportFlowManager: BeanDefinition<ExportFlowManager> = single(override = true) {
        ForegroundExportFlowManager(
            exportDataProvider = get(),
            sessionParamsProvider = get(),
            exportSessionHelper = get(),
            exportDir = get(named("exportDir")),
            shouldClearSessionOnFinish = true,
            publishManager = get(),
            errorParser = get(),
            mediaFileNameHelper = get()
        )
    }

    /**
     * Provides params for export
     * */
    val exportParamsProvider: BeanDefinition<ExportParamsProvider> =
        factory(override = true) {
            IntegrationAppExportParamsProvider(
                exportDir = get(named("exportDir")),
                sizeProvider = get(),
                watermarkBuilder = get()
            )
        }

    /**
     * Provides path for exported files
     * */
    val exportDir: BeanDefinition<Uri> = single(named("exportDir"), override = true) {
        get<Context>().getExternalFilesDir("")
            ?.toUri()
            ?.buildUpon()
            ?.appendPath("export")
            ?.build() ?: throw NullPointerException("exportDir should't be null!")
    }


    override val coverProvider: BeanDefinition<CoverProvider> = single(override = true) {
        CoverProvider.EXTENDED
    }
}