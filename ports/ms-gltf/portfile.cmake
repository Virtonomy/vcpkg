if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Virtonomy/glTF-SDK
    REF eacf331a5ae6eb615f5a8ff55472d94242b719c9 # 20-03-2022
    SHA512 34823a9f01dd9320fe1c18ddd464bd612a010fdfab5cefae723739f8295d4f6d36a9c8b13c9011e0a42cec9f4dfd528b322d23ac521913e5475c39435e829fdc
    HEAD_REF master
    PATCHES
        fix-install.patch
        fix-apple-filesystem.patch
)

# note: Test/Sample executables won't be installed
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        test    ENABLE_UNIT_TESTS
        samples ENABLE_SAMPLES
)

# note: Platform-native buildsystem will be more helpful to launch/debug the tests/samples.
# note: The PDB file path is making Ninja fails to install.
#       For Windows, we rely on /MP. The other platforms should be able to build with PREFER_NINJA.
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    WINDOWS_USE_MSBUILD
    OPTIONS
        ${FEATURE_OPTIONS}
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
