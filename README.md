# Tasko Go

Flutter application for the Tasko product line.

## Android Release Signing

The Android project is prepared to read release signing credentials from `android/key.properties`, which is ignored by Git.

1. Generate an upload keystore:

```bash
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties` based on `android/key.properties.example`.

```properties
storeFile=upload-keystore.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=upload
keyPassword=YOUR_KEY_PASSWORD
```

3. Build the Android App Bundle for Google Play:

```bash
flutter build appbundle
```

4. Upload the generated `.aab` from `build/app/outputs/bundle/release/` to the Google Play Console in the desired testing track.

## Google Play Upload Automation

This repository includes a local automation flow to build the signed Android App Bundle and upload it to Google Play internal testing.

### Prerequisites

1. The app entry must already exist in Google Play Console for the package `br.com.wsilva.tasko.go`.
2. `android/key.properties` and the upload keystore must already be configured.
3. Install fastlane on macOS:

```bash
brew install fastlane
```

4. Create a Google Cloud service account, enable the Google Play Android Developer API, and link that service account in Google Play Console under API Access.
5. In Google Play Console, grant the service account permission to upload releases for this app.

### Local Configuration

1. Copy `.env.play.example` to `.env.play`.
2. Set `FL_SERVICE_ACCOUNT_PATH` to the local path of your Google Play service account JSON.
3. Review `FL_TRACK`, which defaults to `internal`.

Example:

```bash
cp .env.play.example .env.play
```

### Publish Command

Run the local publish script from the repository root:

```bash
./scripts/publish_android_play.sh
```

By default the script:

1. Loads `.env.play` if present.
2. Runs `flutter pub get`.
3. Builds the signed release AAB.
4. Uploads the artifact to the configured Google Play track using fastlane.

To reuse an already built AAB:

```bash
FL_SKIP_BUILD=1 ./scripts/publish_android_play.sh
```

### Scope Limits

The automation uploads the AAB only. It does not:

1. Create the app in Play Console.
2. Configure tester groups.
3. Fill App access, Data safety, content rating, or store listing forms.

## Versioning

Android `versionName` and `versionCode` come from the `version` field in `pubspec.yaml`.
