package com.taleb.music_player

import android.content.ContentResolver
import android.content.ContentValues
import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import android.webkit.MimeTypeMap
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity : AudioServiceActivity() {
    private val channelName = "com.taleb.music_player/ringtone_set"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, channelName).setMethodCallHandler { call, result ->
                when (call.method) {
                    "set_ringtone" -> {
                        val filePath = call.argument<String>("filePath")
                        result.success(
                            if (filePath.isNullOrBlank()) {
                                false
                            } else {
                                setFileAsDefaultRingtone(filePath)
                            }
                        )
                    }
                    "can_write_settings" -> result.success(canWriteSettings())
                    "open_write_settings" -> result.success(openWriteSettingsPage())
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun canWriteSettings(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.M || Settings.System.canWrite(this)
    }

    private fun openWriteSettingsPage(): Boolean {
        if (canWriteSettings()) {
            return true
        }

        return try {
            startActivity(
                Intent(
                    Settings.ACTION_MANAGE_WRITE_SETTINGS,
                    Uri.parse("package:$packageName")
                ).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
            )
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun setFileAsDefaultRingtone(filePath: String): Boolean {
        if (!canWriteSettings()) {
            return false
        }

        val file = File(filePath)
        if (!file.exists() || !file.canRead()) {
            return false
        }

        return runCatching {
            val resolver = applicationContext.contentResolver
            val ringtoneUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                insertRingtoneForAndroidQAndAbove(resolver, file)
            } else {
                insertRingtoneForLegacyAndroid(resolver, file)
            } ?: return false

            RingtoneManager.setActualDefaultRingtoneUri(
                applicationContext,
                RingtoneManager.TYPE_RINGTONE,
                ringtoneUri
            )
            true
        }.getOrElse {
            it.printStackTrace()
            false
        }
    }

    private fun insertRingtoneForLegacyAndroid(
        resolver: ContentResolver,
        file: File
    ): Uri? {
        val contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI

        resolver.delete(
            contentUri,
            "${MediaStore.MediaColumns.DATA}=?",
            arrayOf(file.absolutePath)
        )

        val values = baseAudioValues(file).apply {
            put(MediaStore.MediaColumns.DATA, file.absolutePath)
        }

        return resolver.insert(contentUri, values)
    }

    private fun insertRingtoneForAndroidQAndAbove(
        resolver: ContentResolver,
        file: File
    ): Uri? {
        val relativePath = "${Environment.DIRECTORY_RINGTONES}/"
        val collection = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI

        resolver.delete(
            collection,
            "${MediaStore.MediaColumns.DISPLAY_NAME}=? AND " +
                "${MediaStore.MediaColumns.RELATIVE_PATH}=?",
            arrayOf(file.name, relativePath)
        )

        val values = baseAudioValues(file).apply {
            put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }

        val newUri = resolver.insert(collection, values) ?: return null

        return try {
            resolver.openOutputStream(newUri)?.use { outputStream ->
                file.inputStream().use { inputStream ->
                    inputStream.copyTo(outputStream)
                }
            } ?: run {
                resolver.delete(newUri, null, null)
                return null
            }

            val publishValues = ContentValues().apply {
                put(MediaStore.MediaColumns.IS_PENDING, 0)
            }
            resolver.update(newUri, publishValues, null, null)
            newUri
        } catch (_: IOException) {
            resolver.delete(newUri, null, null)
            null
        }
    }

    private fun baseAudioValues(file: File): ContentValues {
        return ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
            put(MediaStore.MediaColumns.TITLE, file.nameWithoutExtension)
            put(MediaStore.MediaColumns.SIZE, file.length())
            put(MediaStore.MediaColumns.MIME_TYPE, resolveMimeType(file))
            put(MediaStore.Audio.Media.IS_RINGTONE, true)
            put(MediaStore.Audio.Media.IS_NOTIFICATION, false)
            put(MediaStore.Audio.Media.IS_ALARM, false)
            put(MediaStore.Audio.Media.IS_MUSIC, true)
        }
    }

    private fun resolveMimeType(file: File): String {
        val extension = file.extension.lowercase()
        if (extension.isEmpty()) {
            return "audio/*"
        }

        return MimeTypeMap.getSingleton()
            .getMimeTypeFromExtension(extension)
            ?: "audio/*"
    }
}
