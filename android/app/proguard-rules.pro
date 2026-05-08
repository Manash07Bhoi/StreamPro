-keep class com.google.crypto.** { *; }
-keepclassmembers class com.google.crypto.** { *; }
-dontwarn com.google.crypto.**

-keep class com.google.protobuf.** { *; }
-keepclassmembers class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keepclassmembers class com.it_nomads.fluttersecurestorage.** { *; }

-dontwarn javax.annotation.**
-keep class javax.annotation.** { *; }

-dontwarn javax.annotation.concurrent.**
-keep class javax.annotation.concurrent.** { *; }

-dontwarn com.google.errorprone.annotations.**
-keep class com.google.errorprone.annotations.** { *; }

-ignorewarnings
-keepattributes *Annotation*
-keep class * {
    @javax.annotation.Nullable <fields>;
    @javax.annotation.Nullable <methods>;
    @javax.annotation.concurrent.GuardedBy <fields>;
    @javax.annotation.concurrent.GuardedBy <methods>;
}
