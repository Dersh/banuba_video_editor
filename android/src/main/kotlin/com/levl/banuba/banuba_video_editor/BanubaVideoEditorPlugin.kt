package com.levl.banuba.banuba_video_editor

import android.app.Activity
import android.app.Activity.RESULT_CANCELED
import android.app.Activity.RESULT_OK
import android.content.Intent

import androidx.annotation.NonNull
import com.banuba.sdk.ve.data.EXTRA_EXPORTED_SUCCESS
import com.banuba.sdk.ve.data.ExportResult
import com.banuba.sdk.ve.flow.VideoCreationActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry


/** BanubaVideoEditorPlugin */
class BanubaVideoEditorPlugin : FlutterPlugin, BanubaVideoEditorPluginApi.BanubaVideoEditorApi,
    ActivityAware, PluginRegistry.ActivityResultListener {
    private var activity: Activity? = null
    private var pendingResult: BanubaVideoEditorPluginApi.Result<BanubaVideoEditorPluginApi.VideoEditResult>? =
        null

    companion object {
        private const val VIDEO_EDITOR_REQUEST_CODE = 34535
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        BanubaVideoEditorPluginApi.BanubaVideoEditorApi.setup(
            flutterPluginBinding.binaryMessenger,
            this
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        BanubaVideoEditorPluginApi.BanubaVideoEditorApi.setup(binding.binaryMessenger, null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun startEditorFromCamera(result: BanubaVideoEditorPluginApi.Result<BanubaVideoEditorPluginApi.VideoEditResult>?) {
        if (pendingResult != null) {
            result?.error(Exception("Video editor is already active."))
            return
        }
        pendingResult = result
        activity?.let {
            it.startActivityForResult(
                VideoCreationActivity.startFromCamera(
                    context = it
                ), VIDEO_EDITOR_REQUEST_CODE
            )
        } ?: run {
            finishWithError(NoActivityException())
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?): Boolean {
        if (pendingResult == null) {
            return false
        }
        if (resultCode == RESULT_OK && requestCode == VIDEO_EDITOR_REQUEST_CODE) {
            val exportedVideoResult =
                intent?.getParcelableExtra(EXTRA_EXPORTED_SUCCESS) as? ExportResult.Success
            if(exportedVideoResult == null || exportedVideoResult.videoList.isEmpty()) {
                finishWithError(Exception("Empty result or video list"))
                return true
            }
            val video = exportedVideoResult.videoList.first()

            finishWithSuccess(video.sourceUri.path, exportedVideoResult.preview.path)
            return true
        } else if (resultCode == RESULT_CANCELED && requestCode == VIDEO_EDITOR_REQUEST_CODE) {
            finishWithSuccess(null,null)
            return true
        } else if (requestCode == VIDEO_EDITOR_REQUEST_CODE) {
            finishWithError(Exception("Unknown activity error."));
        }
        return false
    }

    private fun finishWithError(error: Throwable) {
        pendingResult?.error(error)
        clearPendingResult()
    }

    private fun finishWithSuccess(videoPath: String?, coverPath: String?) {
        val result = BanubaVideoEditorPluginApi.VideoEditResult()
        result.filePath = videoPath
        result.coverPath = coverPath
        pendingResult?.success(result)
        clearPendingResult()
    }

    private fun clearPendingResult() {
        pendingResult = null
    }
}


class NoActivityException : Exception("video_editor requires a foreground activity")