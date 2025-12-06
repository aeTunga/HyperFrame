# 🚀 HyperFrame Quick Start Guide

Welcome to HyperFrame! This guide will get you up and running in under 5 minutes.

---

## ⚡️ Installation (3 Commands)

```bash
# 1. Navigate to the project
cd /Users/admin/Code/HyperFrame

# 2. Get dependencies (if not already done)
flutter pub get

# 3. Run on macOS
flutter run -d macos
```

That's it! HyperFrame is now running with an iPhone 13 Pro Max simulation.

---

## 🎯 What You Should See

When the app launches, you'll see:

1. **Top Toolbar** - DevicePreview controls with device selector
2. **Hero Section** - "HyperFrame" branding with feature chips
3. **Counter Section** - Interactive counter showing "Running in HyperFrame Simulator"
4. **Device Info Card** - Real-time device information
5. **Responsive Grid** - 2/3/4 column grid adapting to device width
6. **Theme Toggle** - Sun/Moon icon in the app bar

---

## 🎨 Quick Actions

### Switch Devices

**Option 1: Use Toolbar (Easiest)**
- Click the device icon in the top DevicePreview toolbar
- Select from iPhone, iPad, Android devices

**Option 2: Edit Code**
Open `lib/main.dart` around line 38:

```dart
// Change this line:
defaultDevice: Devices.ios.iPhone13ProMax,

// To one of these:
defaultDevice: Devices.android.pixel6,           // Pixel 6
defaultDevice: Devices.ios.iPad12InchGen4,       // iPad
defaultDevice: Devices.android.samsungGalaxyS20, // Galaxy S20
```

Save the file and press `r` for hot reload!

### Toggle Theme

- Click the sun/moon icon in the app bar
- Watch the theme switch instantly!

### Test Hot Reload

1. Click the floating "TEST HOT RELOAD" button
2. Counter increments
3. Change something in the code
4. Press `r` in terminal
5. See instant updates!

### Test Responsive Layout

- Switch between iPhone (2 columns) and iPad (3-4 columns)
- Watch the grid adapt instantly!

---

## 🔥 Hot Tips

### Keyboard Shortcuts

While the app is running in terminal:

- `r` - Hot reload (instant)
- `R` - Hot restart (full restart)
- `h` - Show help
- `q` - Quit

### Best Practices

1. **Always run on desktop** in debug mode for DevicePreview
2. **Use hot reload** (`r`) instead of restarting for faster iteration
3. **Switch devices** in the toolbar to test different layouts quickly
4. **Test themes** by toggling dark/light mode frequently

---

## 📱 Switching to Real Devices

To test on actual iOS/Android devices or emulators:

```bash
# List available devices
flutter devices

# Run on iPhone simulator
flutter run -d "iPhone 17 Pro Max"

# Run on Android emulator
flutter run -d emulator-5554

# Run in release mode (no DevicePreview)
flutter run -d macos --release
```

**Note:** DevicePreview only runs in **debug mode on desktop**. Real devices run the standard app.

---

## 🐛 Common Issues

### DevicePreview Not Showing?

**Problem:** App runs but no device frame appears

**Solution:**
1. Ensure you're running on macOS (or Windows/Linux)
2. Verify you're in debug mode: `flutter run -d macos --debug`
3. Check `lib/main.dart` - `enableSimulator` should be `true`

### Hot Reload Not Working?

**Problem:** Changes don't appear after pressing `r`

**Solution:**
1. Try hot restart with `R` instead
2. Check for syntax errors in terminal
3. If all else fails, stop and restart: `flutter run -d macos`

### Fonts Not Loading?

**Problem:** Text appears in default font, not Google Fonts

**Solution:**
```bash
flutter clean
flutter pub get
flutter run -d macos
```

---

## 🎓 Next Steps

Now that you're running, try:

1. **Modify the UI** - Change colors in `lib/theme/app_theme.dart`
2. **Add a screen** - Create new screens in `lib/screens/`
3. **Test layouts** - Add responsive widgets in `lib/widgets/`
4. **Build features** - Implement your app logic!

---

## 📚 Learn More

- **Full Documentation:** See `README.md`
- **Contributing:** See `CONTRIBUTING.md`
- **Architecture:** Check code comments in `lib/main.dart`

---

## 🎉 Success!

You're now running HyperFrame with 10x faster development speed!

**Enjoy building amazing apps without burning your CPU!** 🔋⚡️

---

**Questions?** Open an issue at: https://github.com/yourusername/hyperframe/issues
