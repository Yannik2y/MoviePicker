#!/bin/bash

# App Icon Generator Script
# This script generates all required iOS app icon sizes from a single 1024x1024 image

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first:"
        echo "https://brew.sh/"
        exit 1
    fi
    brew install imagemagick
fi

# Source image path
SOURCE_IMAGE="MoviePicker/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
OUTPUT_DIR="MoviePicker/Assets.xcassets/AppIcon.appiconset"

# Check if source image exists
if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "Source image not found: $SOURCE_IMAGE"
    echo "Please ensure you have a 1024x1024 AppIcon.png file"
    exit 1
fi

echo "Generating iOS app icons from $SOURCE_IMAGE..."

# iPhone icons
convert "$SOURCE_IMAGE" -resize 40x40 "$OUTPUT_DIR/AppIcon-20@2x.png"      # 20x20@2x
convert "$SOURCE_IMAGE" -resize 60x60 "$OUTPUT_DIR/AppIcon-20@3x.png"      # 20x20@3x
convert "$SOURCE_IMAGE" -resize 58x58 "$OUTPUT_DIR/AppIcon-29@2x.png"      # 29x29@2x
convert "$SOURCE_IMAGE" -resize 87x87 "$OUTPUT_DIR/AppIcon-29@3x.png"      # 29x29@3x
convert "$SOURCE_IMAGE" -resize 80x80 "$OUTPUT_DIR/AppIcon-40@2x.png"      # 40x40@2x
convert "$SOURCE_IMAGE" -resize 120x120 "$OUTPUT_DIR/AppIcon-40@3x.png"    # 40x40@3x
convert "$SOURCE_IMAGE" -resize 120x120 "$OUTPUT_DIR/AppIcon-60@2x.png"    # 60x60@2x
convert "$SOURCE_IMAGE" -resize 180x180 "$OUTPUT_DIR/AppIcon-60@3x.png"    # 60x60@3x

# iPad icons
convert "$SOURCE_IMAGE" -resize 20x20 "$OUTPUT_DIR/AppIcon-20@1x.png"      # 20x20@1x
convert "$SOURCE_IMAGE" -resize 40x40 "$OUTPUT_DIR/AppIcon-20@2x.png"      # 20x20@2x (reuse)
convert "$SOURCE_IMAGE" -resize 29x29 "$OUTPUT_DIR/AppIcon-29@1x.png"      # 29x29@1x
convert "$SOURCE_IMAGE" -resize 58x58 "$OUTPUT_DIR/AppIcon-29@2x.png"      # 29x29@2x (reuse)
convert "$SOURCE_IMAGE" -resize 40x40 "$OUTPUT_DIR/AppIcon-40@1x.png"      # 40x40@1x
convert "$SOURCE_IMAGE" -resize 80x80 "$OUTPUT_DIR/AppIcon-40@2x.png"      # 40x40@2x (reuse)
convert "$SOURCE_IMAGE" -resize 152x152 "$OUTPUT_DIR/AppIcon-76@2x.png"   # 76x76@2x
convert "$SOURCE_IMAGE" -resize 167x167 "$OUTPUT_DIR/AppIcon-83.5@2x.png"  # 83.5x83.5@2x

echo "✅ All app icons generated successfully!"
echo "📱 iPhone icons: 8 sizes"
echo "📱 iPad icons: 8 sizes"
echo "📱 App Store icon: 1024x1024 (original)"

# Update Contents.json to reference all generated files
cat > "$OUTPUT_DIR/Contents.json" << 'EOF'
{
  "images" : [
    {
      "filename" : "AppIcon-20@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "AppIcon-20@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    {
      "filename" : "AppIcon-29@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "AppIcon-29@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "29x29"
    },
    {
      "filename" : "AppIcon-40@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "AppIcon-40@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "40x40"
    },
    {
      "filename" : "AppIcon-60@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "60x60"
    },
    {
      "filename" : "AppIcon-60@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "60x60"
    },
    {
      "filename" : "AppIcon-20@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "20x20"
    },
    {
      "filename" : "AppIcon-20@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "AppIcon-29@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "29x29"
    },
    {
      "filename" : "AppIcon-29@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "29x29"
    },
    {
      "filename" : "AppIcon-40@1x.png",
      "idiom" : "ipad",
      "scale" : "1x",
      "size" : "40x40"
    },
    {
      "filename" : "AppIcon-40@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "40x40"
    },
    {
      "filename" : "AppIcon-76@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "76x76"
    },
    {
      "filename" : "AppIcon-83.5@2x.png",
      "idiom" : "ipad",
      "scale" : "2x",
      "size" : "83.5x83.5"
    },
    {
      "filename" : "AppIcon.png",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "✅ Contents.json updated with all icon references"
echo ""
echo "🎯 Next steps:"
echo "1. Clean and rebuild your project in Xcode"
echo "2. The app icon should now appear on the home screen!"
echo ""
echo "📁 Generated files:"
ls -la "$OUTPUT_DIR"/*.png
