buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Класс-путь для плагина Google Services
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Если вам нужно задать собственные директории сборки, оставьте этот код:
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Объявляем плагины, которые могут использоваться в подпроектах.
// Обратите внимание, что плагин Google Services не применяется здесь (он будет применён в модуле app).
plugins {
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") apply false
    id("com.google.gms.google-services") version "4.3.15" apply false
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
