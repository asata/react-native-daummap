module.exports = {
  project: {
    ios: {
        "sharedLibraries": [
            "libxml2",
            "libsqlite3",
            "SystemConfiguration",
            "CoreLocation",
            "OpenGLES",
            "QuartzCore",
            "libc++"
        ]
    },
    android: {}, // grouped into "project"
  },
};