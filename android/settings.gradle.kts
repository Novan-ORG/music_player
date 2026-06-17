pluginManagement {
    val flutterSdkPath = run {
        val projectFvmSdk = file("../.fvm/flutter_sdk")
        if (projectFvmSdk.exists()) {
            projectFvmSdk.canonicalPath
        } else {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) {
                "flutter.sdk not set in local.properties and .fvm/flutter_sdk not found"
            }
            flutterSdkPath
        }
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        exclusiveContent {
            forRepository {
                maven(url = uri(file(".gradle/local-google-m2")))
            }
            filter {
                includeGroupByRegex("com\\.android(\\..+)?")
                includeGroupByRegex("androidx(\\..+)?")
                includeGroup("com.google.testing.platform")
            }
        }
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    resolutionStrategy {
        eachPlugin {
            when (requested.id.id) {
                "com.android.application" -> {
                    useModule("com.android.tools.build:gradle:${requested.version}")
                }
                "org.jetbrains.kotlin.android" -> {
                    useModule("org.jetbrains.kotlin:kotlin-gradle-plugin:${requested.version}")
                }
            }
        }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.3.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.10" apply false
    id("org.gradle.toolchains.foojay-resolver-convention") version "0.8.0"
}

include(":app")
