plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileSdk = 36

    namespace = "com.example.dalil"
//    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {

        // دي الطريقة المضمونة لنسختك عشان ميعملش Unresolved reference
        jvmTarget = "17"
    }

    defaultConfig {
        multiDexEnabled = true

        applicationId = "com.example.dalil"

        // غيرنا دي لـ 21 عشان الـ QR Scanner و Google ML Kit
//        minSdk = flutter.minSdkVersion
//          minSdk = flutter.minSdkVersion
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.window:window:1.0.0")
    implementation("androidx.window:window-java:1.0.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // التأكد من وجود الأقواس وعلامات التنصيص المزدوجة
    implementation("com.google.mlkit:barcode-scanning:17.2.0")
}
