# 67 Clicker - Cookie Clicker Style Edition

A Cookie Clicker-inspired two-finger tap game with special image rewards!

## 🎯 New Features

### Cookie Clicker Layout
- **Left Panel**: Stats and score display (Cookie Clicker style)
- **Right Panel**: Big circular clicker button (looks like a cookie!)
- **Brown/tan color scheme** matching Cookie Clicker aesthetics
- **Chocolate chip spots** on the clicker button

### Special 67 Image Feature
When your score reaches any number ending in **67** (67, 167, 267, 367, etc.), a random special image will pop up with a celebratory animation!

## 📸 Adding Your Special Images

### For the HTML Version:

1. **Prepare your images:**
   - Name them: `special1.jpg`, `special2.jpg`, `special3.jpg`, etc.
   - Supported formats: JPG, PNG, GIF, WEBP
   - Recommended size: 500x500px or similar square format

2. **Place images in the same folder as the HTML file**

3. **Update the image list in the HTML file:**
   ```javascript
   // Find this line in the <script> section (around line 438):
   const specialImages = [
       'special1.jpg',
       'special2.jpg',
       'special3.jpg',
       'special4.jpg',
       'special5.jpg'
       // Add more images here!
   ];
   ```

4. **Add or remove images as needed** - the game will randomly pick one when you hit a 67 number!

### For the iOS Version:

1. **Open your Xcode project**

2. **Add images to Assets.xcassets:**
   - Click on `Assets.xcassets` in the Project Navigator
   - Click the `+` button at the bottom
   - Select "Image Set"
   - Name them: `special1`, `special2`, `special3`, etc.
   - Drag your images into the 1x, 2x, and 3x slots

3. **Update the image list in GameManager.swift:**
   ```swift
   // Find this around line 14:
   private let specialImages = [
       "special1",
       "special2", 
       "special3",
       "special4",
       "special5"
       // Add more image names here (without file extensions)
   ]
   ```

4. **Build and run!**

## 🎮 How to Play

1. Tap the big circular button with **TWO fingers simultaneously**
2. Each successful two-finger tap = +1 point
3. Watch your score in the left panel
4. When you hit numbers ending in 67, enjoy the special image popup!
5. Track your stats: Total Taps, Skibidi Rate, Best Streak, Special 67s Hit

## 🎨 Visual Features

### Cookie Clicker Aesthetics:
- Dark brown patterned background
- Golden yellow text and accents
- Cookie-like circular clicker with chocolate chips
- Stats panels with brown borders
- Floating "+1" numbers on successful taps

### Special 67 Animation:
- Image spins in with rotation
- Golden border and glow effect
- Scales up then disappears after 2 seconds
- Plays special haptic feedback (iOS) or sound (web - optional)

## 📊 Statistics Tracked

- **67 pairs tapped**: Your main score
- **Total Taps**: How many times you've tapped (successful or not)
- **Skibidi Rate**: Your success percentage
- **Best Streak**: Highest consecutive successful taps
- **Special 67s Hit**: How many times you've hit a 67 number (NEW!)

## 🎯 Tips for Special Images

**Good image choices:**
- Memes or funny images
- Cartoon characters
- Celebration GIFs (for web)
- Awards/trophies
- Your own photos!
- Gaming characters

**Image guidelines:**
- Keep files under 1MB for fast loading
- Use square aspect ratios (1:1)
- Bright, colorful images work best
- High contrast images are easier to see

## 🔧 Customization

### Change the special number:
Look for `score.toString().endsWith('67')` (HTML) or `String(score).hasSuffix("67")` (iOS) and change "67" to any number you want!

### Add more or fewer images:
Just update the `specialImages` array in both versions.

### Change colors:
- HTML: Search for hex colors like `#FFD700` (gold) and `#8B4513` (brown)
- iOS: Change `Color(hex: "FFD700")` values throughout

## 🎵 Optional: Add Sound Effects

### For HTML:
1. Add a sound file (e.g., `special-sound.mp3`) to your folder
2. Uncomment these lines in the HTML:
   ```javascript
   function playSpecialSound() {
       const audio = new Audio('special-sound.mp3');
       audio.play().catch(() => {});
   }
   ```

### For iOS:
1. Add sound file to your project
2. Use AVAudioPlayer in the GameManager

## 📱 Mobile Responsive

The HTML version automatically switches to a mobile-friendly layout:
- On desktop/tablet: Side-by-side panels
- On mobile: Stacked panels (stats on top, clicker below)

## 🚀 Deployment

Same as before:
- HTML: Host on any web server, GitHub Pages, Netlify, etc.
- iOS: Follow the original README for App Store deployment

## 🎉 Version History

- **2.0**: Cookie Clicker style redesign + Special 67 image feature
- **1.0**: Original colorful design

---

**Enjoy your Cookie Clicker-style 67 Clicker!** 🍪✌️

Don't forget to add your special images to see the magic happen at 67, 167, 267, etc!
