# Keep Flutter and plugin classes used through reflection.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
# flutter_local_notifications uses Gson
-keep class com.dexterous.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.android.play.core.**
