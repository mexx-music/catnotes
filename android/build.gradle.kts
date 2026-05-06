allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Suppress javac option deprecation warnings coming from third-party modules
// and ensure Kotlin compilation targets Java 11.
subprojects {
    // For any JavaCompile task (also in plugins inside .pub-cache) add the
    // compiler arg to silence the -Xlint:options deprecation warning.
    tasks.withType(org.gradle.api.tasks.compile.JavaCompile::class.java).configureEach {
        // add the suggested flag to suppress warnings about deprecated source/target options
        options.compilerArgs.add("-Xlint:-options")
        // keep encoding consistent
        options.encoding = "UTF-8"
    }

    // If Kotlin is applied, make sure Kotlin compiles to Java 11 bytecode
    plugins.withId("kotlin") {
        tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class.java).configureEach {
            kotlinOptions.jvmTarget = JavaVersion.VERSION_11.toString()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
