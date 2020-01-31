module.exports = {
  dependency: {
    platforms: {
        ios: {
            sharedLibraries: [
                "SystemConfiguration",
                "CoreLocation",
                "OpenGLES",
                "QuartzCore",
                "libc++",
                "libxml2",
                "libsqlite3"
            ]
        },
        android: {},
    }
  },
};