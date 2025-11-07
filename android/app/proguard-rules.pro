# ProGuard/R8 rules for Flutter + common AndroidX/Firebase plugins
# Keep Flutter embedding and plugins
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Kotlin metadata and annotations
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

# Firebase/Play Services (commonly used in Flutter projects)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Gson/serialization (safe keep for models with SerializedName)
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Avoid warnings from javax annotations sometimes present in libs
-dontwarn javax.annotation.**

# Keep classes referenced from Android manifest (providers, services, receivers)
-keep class ** extends android.app.Service { *; }
-keep class ** extends android.content.BroadcastReceiver { *; }
-keep class ** extends android.content.ContentProvider { *; }
-keep class ** extends android.app.Activity { *; }

# Keep resource identifiers when shrinking resources
-keepclassmembers class **.R$* { *; }


# Flutter Play Store SplitCompat Fix
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**
