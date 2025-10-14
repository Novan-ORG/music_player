package com.taleb.music_player

import android.content.ContentResolver
import android.content.ContentValues
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "com.taleb.music_player/ringtone_set"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let { MethodChannel(it, CHANNEL) }
            ?.setMethodCallHandler { call, result ->
                if (call.method == "set_ringtone") {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        val changed = setFileAsDefaultRingtone(filePath)
                        result.success(changed)
                    }else {
                        result.success(false)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }


    private fun setFileAsDefaultRingtone(filePath: String) : Boolean {
        val file = File(filePath)
        val resolver: ContentResolver = context.contentResolver

    val values = ContentValues().apply {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
            put(MediaStore.MediaColumns.MIME_TYPE, "audio/mp3")
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_RINGTONES)
            put(MediaStore.Audio.Media.IS_RINGTONE, true)
        } else {
            put(MediaStore.MediaColumns.DATA, file.absolutePath)
            put(MediaStore.MediaColumns.TITLE, "Custom Ringtone")
            put(MediaStore.MediaColumns.MIME_TYPE, "audio/mp3")
            put(MediaStore.Audio.Media.IS_RINGTONE, true)
        }
    }

    val uri: Uri = MediaStore.Audio.Media.getContentUriForPath(file.absolutePath) ?: return false
    val newUri: Uri? = resolver.insert(uri, values)

    if (newUri == null) {
        return false
    }

    // For Android 10 and above, write file content via stream
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        try {
            resolver.openOutputStream(newUri)?.use { outputStream ->
                file.inputStream().use { inputStream ->
                    inputStream.copyTo(outputStream)
                }
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    // Set as default ringtone
    RingtoneManager.setActualDefaultRingtoneUri(context, RingtoneManager.TYPE_RINGTONE, newUri)

    return true
    }
}