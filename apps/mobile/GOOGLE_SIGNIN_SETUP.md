# Google Sign-In Setup Guide for MediMinder

## Current Status

✅ **iOS Configuration**: Basic setup complete
⚠️ **Android Configuration**: Needs OAuth client setup
📝 **Additional Steps Required**: See below

## What Was Fixed

### iOS (Info.plist)
- ✅ Added `GIDClientID` to `ios/Runner/Info.plist`
- ✅ Updated `CFBundleURLSchemes` with reversed client ID
- ✅ Updated `google_signin_service.dart` to include `serverClientId`

### Current Configuration
- **Web Client ID**: `421545279021-r44bjf3i1i9r9ou95qirvfk1jj1vrff9.apps.googleusercontent.com`
- **iOS URL Scheme**: `com.googleusercontent.apps.421545279021-r44bjf3i1i9r9ou95qirvfk1jj1vrff9`

## Required: Complete Google Cloud Console Setup

### For iOS (Additional Steps)

1. **Create iOS OAuth Client** (if not already done):
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Navigate to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth 2.0 Client ID"
   - Select "iOS" as application type
   - Enter Bundle ID: `com.remiminder.app`
   - Download the configuration

2. **Add GoogleService-Info.plist** (Recommended):
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add it to `ios/Runner/GoogleService-Info.plist`
   - In Xcode, add it to the Runner target (right-click Runner folder → Add Files)

3. **Verify Info.plist** (Already Done):
   ```xml
   <key>GIDClientID</key>
   <string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
   <key>CFBundleURLSchemes</key>
   <array>
       <string>com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID</string>
   </array>
   ```

### For Android

1. **Update OAuth Client in Firebase Console**:
   - Go to Firebase Console → Project Settings
   - Select your Android app
   - Add SHA-1 fingerprint for debug and release builds:
     ```bash
     # Debug keystore SHA-1
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     
     # Release keystore SHA-1 (when ready for production)
     keytool -list -v -keystore YOUR_RELEASE_KEYSTORE -alias YOUR_ALIAS
     ```
   - Copy the SHA-1 fingerprint
   - In Firebase Console, add the SHA-1 to your Android app

2. **Download Updated google-services.json**:
   - After adding SHA-1, download the new `google-services.json`
   - Replace `android/app/src/google-services.json` with the new file
   - The new file should have OAuth client entries (currently empty)

3. **Verify Android Configuration**:
   - Ensure `android/app/build.gradle.kts` has the correct package name
   - Current package: `com.remiminder.app` ✅

## Testing Google Sign-In

### iOS Testing
```bash
cd apps/mobile
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter run
```

### Android Testing
```bash
cd apps/mobile
flutter clean
flutter pub get
flutter run
```

### Common Issues and Solutions

#### iOS: "No active configuration" Error
**Solution**: Ensure `GIDClientID` is set in `Info.plist` ✅ (Fixed)

#### iOS: "Error 400: redirect_uri_mismatch"
**Solution**: 
- Verify URL scheme matches reversed client ID
- Check that iOS OAuth client exists in Google Cloud Console

#### Android: Google Sign-In button appears but nothing happens
**Solution**:
- Ensure SHA-1 fingerprint is added to Firebase Console
- Download and replace `google-services.json` with updated version

#### Both Platforms: "Google sign in was cancelled"
**Solution**: User clicked cancel - this is normal behavior

#### Supabase Integration Issues
**Solution**: Ensure you have:
- Google provider enabled in Supabase Dashboard → Authentication → Providers
- Correct redirect URLs configured in Supabase
- Valid `serverClientId` in `google_signin_service.dart` ✅ (Fixed)

## Environment Variables (Optional Enhancement)

For better security, move client IDs to environment variables:

1. Create `.env` file in `apps/mobile/`:
   ```env
   GOOGLE_WEB_CLIENT_ID=421545279021-r44bjf3i1i9r9ou95qirvfk1jj1vrff9.apps.googleusercontent.com
   GOOGLE_IOS_CLIENT_ID=YOUR_IOS_CLIENT_ID.apps.googleusercontent.com
   ```

2. Update `lib/core/config/environment.dart`:
   ```dart
   static String get googleWebClientId =>
       _isLoaded ? (dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '') : '';
   static String get googleIosClientId =>
       _isLoaded ? (dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '') : '';
   ```

3. Update `google_signin_service.dart`:
   ```dart
   serverClientId: Environment.googleWebClientId.isNotEmpty 
       ? Environment.googleWebClientId 
       : _webClientId,
   ```

## Verification Checklist

- [ ] iOS OAuth client created in Google Cloud Console
- [ ] Android SHA-1 fingerprint added to Firebase Console
- [ ] `google-services.json` updated with OAuth client (Android)
- [ ] `GoogleService-Info.plist` added to iOS project (optional but recommended)
- [ ] Google provider enabled in Supabase Dashboard
- [ ] Tested sign-in on iOS device/simulator
- [ ] Tested sign-in on Android device/emulator

## Next Steps

1. **Immediate**: Try running the app on iOS - the current fix should resolve the crash
2. **Short-term**: Set up proper iOS OAuth client in Google Cloud Console
3. **Before Android Testing**: Add SHA-1 and update `google-services.json`
4. **Production**: Move client IDs to environment variables

## Support Resources

- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)

---

**Last Updated**: December 26, 2025
**Status**: iOS configuration fixed, ready for testing

