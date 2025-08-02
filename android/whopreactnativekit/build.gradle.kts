@file:Suppress("UNCHECKED_CAST")
import groovy.json.JsonOutput
import groovy.json.JsonSlurper

val publishingVersion = System.getenv("PUBLISHING_VERSION") ?: "0.0.1"

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
    id("com.facebook.react")
    id("com.callstack.react.brownfield")
    `maven-publish`
}

android {
    namespace = "com.whoprnkit.whopreactnativekit"
    compileSdk = 35

    defaultConfig {
        minSdk = 24

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        consumerProguardFiles("consumer-rules.pro")

        buildConfigField("boolean", "IS_NEW_ARCHITECTURE_ENABLED", "true")
        buildConfigField("boolean", "IS_HERMES_ENABLED", "true")
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            isJniDebuggable = true
            ndk.debugSymbolLevel = "FULL"
        }
        debug {
            isJniDebuggable = true
            ndk.debugSymbolLevel = "FULL"

            packaging {
                jniLibs {
                    keepDebugSymbols += listOf("**/*.so")
                }
            }
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }

    publishing {
        multipleVariants {
            // Publish both build-types
            includeBuildTypeValues("debug", "release")

            // Attach a -sources.jar next to each AAR
            withSourcesJar()
        }
    }
}

react {
    autolinkLibrariesWithApp()
}

dependencies {

    implementation("androidx.appcompat:appcompat:1.7.0")
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test:runner:1.6.2")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")

    api("com.facebook.react:react-android:0.80.0")
    api("com.facebook.react:hermes-android:0.80.0")
}

publishing {
    publications {
        create<MavenPublication>("mavenAar") {
            groupId = "com.whoprnkit"
            artifactId = "whopreactnativekit"
            version = publishingVersion
            afterEvaluate {
                from(components["default"])
            }

            pom {
                withXml {
                    /**
                     * As a result of `from(components.getByName("default")` all of the project
                     * dependencies are added to `pom.xml` file. We do not need the react-native
                     * third party dependencies to be a part of it as we embed those dependencies.
                     */
                    val dependenciesNode = (asNode().get("dependencies") as groovy.util.NodeList).first() as groovy.util.Node
                    dependenciesNode.children()
                        .filterIsInstance<groovy.util.Node>()
                        .filter { (it.get("groupId") as groovy.util.NodeList).text() == rootProject.name }
                        .forEach { dependenciesNode.remove(it) }
                }
            }
        }
    }

    repositories {
        mavenLocal() // Publishes to the local Maven repository (~/.m2/repository by default)
    }
}

val moduleBuildDir: Directory = layout.buildDirectory.get()

/**
 * As a result of `from(components.getByName("default")` all of the project
 * dependencies are added to `module.json` file. We do not need the react-native
 * third party dependencies to be a part of it as we embed those dependencies.
 */
tasks.register("removeDependenciesFromModuleFile") {
    doLast {
        file("$moduleBuildDir/publications/mavenAar/module.json").run {
            val json = inputStream().use { JsonSlurper().parse(it) as Map<String, Any> }
            (json["variants"] as? List<MutableMap<String, Any>>)?.forEach { variant ->
                (variant["dependencies"] as? MutableList<Map<String, Any>>)?.removeAll { it["group"] == rootProject.name }
            }
            writer().use { it.write(JsonOutput.prettyPrint(JsonOutput.toJson(json))) }
        }
    }
}

tasks.named("generateMetadataFileForMavenAarPublication") {
    finalizedBy("removeDependenciesFromModuleFile")
}

// Fix task dependencies to avoid Gradle validation errors
gradle.projectsEvaluated {
    tasks.named("releaseSourcesJar") {
        dependsOn("copyAutolinkingSources")
        dependsOn("generateCodegenArtifactsFromSchema")
    }
}
gradle.projectsEvaluated {
    tasks.named("debugSourcesJar") {
        dependsOn("copyAutolinkingSources")
        dependsOn("generateCodegenArtifactsFromSchema")
    }
}
