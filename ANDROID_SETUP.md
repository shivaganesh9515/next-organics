# Android Development Setup Guide

## Quick Reference

Run the app on your Android phone with hot reload for rapid development.

---

## Prerequisites

### 1. Install Java JDK 17

**Check if Java is installed:**

```powershell
java -version
```

**If not installed, install via winget:**

```powershell
winget install Microsoft.OpenJDK.17
```

**Location:** `C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot`

---

### 2. Enable USB Debugging on Your Android Phone

1. **Open Settings** on your phone
2. Go to **About Phone**
3. Tap **Build Number** 7 times (enables Developer Mode)
4. Go back to **Settings** → **Developer Options**
5. Enable **USB Debugging**
6. Enable **Install via USB** (if available)

---

## Running the App

### Step 1: Connect Your Phone

1. Connect your Android phone to your computer via USB cable
2. On your phone, **allow USB debugging** when prompted
3. Select **File Transfer** or **MTP** mode

### Step 2: Verify Device is Connected

```powershell
flutter devices
```

**Expected output:**

```
A142 (mobile) • 000693442000181 • android-arm64 • Android 16 (API 36)
```

### Step 3: Set Java Environment (Required Every Time)

**Open PowerShell and run:**

```powershell
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
```

> **Note:** You need to run this in every new terminal session, OR set it permanently in System Environment Variables.

### Step 4: Run the App

```powershell
cd C:\Users\gunny\developing\Nextgenorganics-main\next-flutter
flutter run -d A142
```

Or run on any connected Android device:

```powershell
flutter run -d <device-id>
```

**First build takes 5-10 minutes.** Subsequent builds are faster.

---

## Hot Reload & Development

Once the app is running, you can make changes and see them instantly:

| Command | Action                            |
| ------- | --------------------------------- |
| **r**   | Hot reload (updates UI instantly) |
| **R**   | Hot restart (full app restart)    |
| **q**   | Quit/stop the app                 |
| **h**   | Show all commands                 |

### Typical Workflow

1. **Make code changes** in your editor
2. **Press 'r'** in the terminal
3. **See changes instantly** on your phone
4. Repeat!

---

## Setting JAVA_HOME Permanently (Optional)

To avoid setting JAVA_HOME every time:

### Option 1: Via PowerShell (Current User)

```powershell
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot", "User")
```

Then **close and reopen PowerShell**.

### Option 2: Via System Settings (Recommended)

1. Open **System Properties** → **Environment Variables**
2. Under **User variables**, click **New**
3. Variable name: `JAVA_HOME`
4. Variable value: `C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot`
5. Click **OK**
6. Edit **Path** variable
7. Add: `%JAVA_HOME%\bin`
8. Click **OK** and restart terminal

---

## Troubleshooting

### "JAVA_HOME is not set" Error

**Solution:**

```powershell
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
```

### "device not found" Error

**Possible causes:**

- Phone disconnected
- USB debugging not enabled
- Wrong USB mode (use File Transfer/MTP)
- ADB not recognizing device

**Solution:**

1. Disconnect and reconnect phone
2. Revoke USB debugging authorizations on phone
3. Reconnect and allow debugging again
4. Run: `flutter devices` to verify

### Build Fails

**Clean and rebuild:**

```powershell
flutter clean
flutter pub get
flutter run -d A142
```

### App Crashes on Launch

**Check logs:**

```powershell
flutter logs
```

---

## Running on Specific Device

**List all devices:**

```powershell
flutter devices
```

**Run on specific device:**

```powershell
flutter run -d <device-id>
```

**Examples:**

- Android: `flutter run -d A142`
- Windows: `flutter run -d windows`
- Chrome: `flutter run -d chrome`

---

## Build APK (No Cable Needed)

If you want to install the app on your phone **without keeping it connected:**

### Debug APK (for testing)

```powershell
flutter build apk --debug
```

### Release APK (optimized)

```powershell
flutter build apk --release
```

**Output location:**

```
build/app/outputs/flutter-apk/app-release.apk
```

**Install on phone:**

1. Copy APK to your phone
2. Open file and install
3. Enable "Install from unknown sources" if prompted

---

## Performance Tips

### Speed up builds:

```powershell
flutter run -d A142 --fast-start
```

### Profile mode (for performance testing):

```powershell
flutter run -d A142 --profile
```

### Release mode (production build):

```powershell
flutter run -d A142 --release
```

---

## Quick Command Reference

```powershell
# Check devices
flutter devices

# Run on Android
flutter run -d A142

# Hot reload (during development)
r

# Hot restart
R

# Quit
q

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build APK
flutter build apk --release

# Check Flutter setup
flutter doctor -v
```

---

## Summary

**Every time you want to develop:**

1. Connect phone via USB
2. Open PowerShell
3. Set JAVA_HOME (if not permanent):
   ```powershell
   $env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.17.10-hotspot"
   $env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
   ```
4. Run the app:
   ```powershell
   flutter run -d A142
   ```
5. Make changes and press **'r'** for instant updates!

Happy coding! 🚀
