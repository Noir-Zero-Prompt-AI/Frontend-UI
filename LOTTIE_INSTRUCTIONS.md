# ADD LOTTIE TO GRAIN

## Step 1: Add Package in Xcode

1. Open Xcode
2. Open: `/Users/rouler4wd/Desktop/Grain/GrainAI/GrainAI.xcodeproj`
3. Go to: **File → Add Package Dependencies...**
4. Enter URL: `https://github.com/airbnb/lottie-spm.git`
5. Click **"Add Package"**
6. Select **"Lottie"** checkbox
7. Click **"Add Package"**

## Step 2: Build with xcodebuild

```bash
cd /Users/rouler4wd/Desktop/Grain
xcodebuild -project GrainAI/GrainAI.xcodeproj -scheme GrainAI -configuration Debug build -derivedDataPath ./build
```

## Step 3: Launch

```bash
open ./build/Build/Products/Debug/GrainAI.app
```

## You Should See

✅ Animated noir eye (from noireye.lottie)
✅ Looping animation
✅ Still draggable
✅ Still clickable

## If Lottie Fails

Will show purple "G" fallback icon (same as before)

