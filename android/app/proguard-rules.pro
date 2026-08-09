############################################
# ML Kit Barcode Scanning
############################################

# Keep ML Kit barcode scanning classes
-keep class com.google.mlkit.** { *; }

# Keep internal ML Kit barcode classes
-keep class com.google.android.gms.internal.mlkit_vision_barcode.** { *; }

# Keep ML Kit common classes
-keep class com.google.mlkit.common.** { *; }

# Keep barcode model classes
-keep class com.google.mlkit.vision.barcode.** { *; }


############################################
# Google Play Services
############################################

-keep class com.google.android.gms.internal.** { *; }

-keep class com.google.android.gms.common.** { *; }


############################################
# Native methods
############################################

-keepclasseswithmembernames class * {
    native <methods>;
}


############################################
# Runtime annotations
############################################

-keepattributes *Annotation*

-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations


############################################
# Parcelable
############################################

-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}


############################################
# Serializable
############################################

-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
}


############################################
# JNI
############################################

-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}


############################################
# Keep enum values
############################################

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}