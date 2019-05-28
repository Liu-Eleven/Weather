#include "utils.h"



#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

/// \brief Utils::checkAndroidStoragePermissions
/// \return true if storage permissions granted by user.
/// false if denied.
///
///
///
///
bool Utils::checkAndroidStoragePermissions() {
#ifdef Q_OS_ANDROID
    const auto permissionsRequest = QStringList(
          { QString("android.permission.READ_EXTERNAL_STORAGE"),
            QString("android.permission.WRITE_EXTERNAL_STORAGE") });
    if (   (QtAndroid::checkPermission(permissionsRequest[0])
             == QtAndroid::PermissionResult::Denied)
        || (QtAndroid::checkPermission(permissionsRequest[1]))
             == QtAndroid::PermissionResult::Denied) {
        auto permissionResults
             = QtAndroid::requestPermissionsSync(permissionsRequest);
        if (   (permissionResults[permissionsRequest[0]]
                 == QtAndroid::PermissionResult::Denied)
            || (permissionResults[permissionsRequest[1]]
                 == QtAndroid::PermissionResult::Denied))
            return (false);
    }
#endif /* Q_OS_ANDROID */
    return (true);
}
