// android/app/build.gradle.kts  (APP)

plugins {
    id("com.android.application")
    id("kotlin-android")
    // El plugin de Flutter va después de Android y Kotlin
    id("dev.flutter.flutter-gradle-plugin")

    // 🔹 Aplica Google Services en el módulo app
    id("com.google.gms.google-services")
}

android {
    namespace = "co.carmelitas.emai.emai_app"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "co.carmelitas.emai.emai_app"

        // 🔹 Requerido por Firebase/ML Kit
        minSdk = 23

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Firma de debug para poder correr en release local
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
