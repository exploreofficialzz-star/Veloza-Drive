#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Veloza Drive — Local Setup Script
# Run once after cloning to set up your environment.
# By ChAs · ChAs Tech Group
# ─────────────────────────────────────────────────────────────

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${CYAN}🏎️  Veloza Drive — Setup${NC}"
echo "=================================="
echo ""

# 1. Flutter pub get
echo -e "${YELLOW}📦 Installing Flutter dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# 2. Keystore generation
echo -e "${YELLOW}🔐 Generating Android keystore...${NC}"
if [ -f "android/keystore.jks" ]; then
  echo -e "${GREEN}✅ Keystore already exists — skipping${NC}"
else
  keytool -genkey -v \
    -keystore android/keystore.jks \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias veloza_drive \
    -dname "CN=ChAs Tech Group, OU=Mobile, O=ChAsTechGroup, L=Unknown, S=Unknown, C=US" \
    -storepass velozadrive2025 \
    -keypass velozadrive2025
  echo -e "${GREEN}✅ Keystore generated at android/keystore.jks${NC}"
fi
echo ""

# 3. Create key.properties
echo -e "${YELLOW}📝 Creating android/key.properties...${NC}"
if [ -f "android/key.properties" ]; then
  echo -e "${GREEN}✅ key.properties already exists — skipping${NC}"
else
  cat > android/key.properties << EOF
storeFile=keystore.jks
storePassword=velozadrive2025
keyAlias=veloza_drive
keyPassword=velozadrive2025
EOF
  echo -e "${GREEN}✅ key.properties created${NC}"
fi
echo ""

# 4. Encode keystore for GitHub Actions
echo -e "${YELLOW}📋 Encoding keystore for GitHub Actions...${NC}"
if command -v base64 &> /dev/null; then
  B64=$(base64 -w 0 android/keystore.jks 2>/dev/null || base64 android/keystore.jks)
  echo ""
  echo -e "${CYAN}Add these secrets to your GitHub repository:${NC}"
  echo -e "  Settings → Secrets and variables → Actions → New repository secret"
  echo ""
  echo -e "  ${YELLOW}KEYSTORE_BASE64${NC}  →  (see below)"
  echo -e "  ${YELLOW}KEYSTORE_PASSWORD${NC} → velozadrive2025"
  echo -e "  ${YELLOW}KEY_ALIAS${NC}         → veloza_drive"
  echo -e "  ${YELLOW}KEY_PASSWORD${NC}      → velozadrive2025"
  echo ""
  echo "KEYSTORE_BASE64 value:"
  echo "─────────────────────────"
  echo "$B64"
  echo "─────────────────────────"
fi
echo ""

# 5. Git init
echo -e "${YELLOW}🗂️  Initializing Git repository...${NC}"
if [ -d ".git" ]; then
  echo -e "${GREEN}✅ Git already initialized${NC}"
else
  git init
  git add .
  git commit -m "🏎️ Initial commit — Veloza Drive by ChAs Tech Group"
  echo -e "${GREEN}✅ Git initialized with initial commit${NC}"
fi
echo ""

# 6. Create placeholder audio files
echo -e "${YELLOW}🎵 Creating placeholder audio files...${NC}"
AUDIO_FILES=(
  "engine_idle.mp3"
  "engine_rev.mp3"
  "nitro_boost.mp3"
  "crash.mp3"
  "win.mp3"
  "lose.mp3"
  "countdown_beep.mp3"
  "race_start.mp3"
  "menu_music.mp3"
  "race_music.mp3"
  "btn_tap.mp3"
)
for f in "${AUDIO_FILES[@]}"; do
  if [ ! -f "assets/audio/$f" ]; then
    touch "assets/audio/$f"
    echo "  Created placeholder: assets/audio/$f"
  fi
done
echo -e "${GREEN}✅ Audio placeholders created — replace with real .mp3 files!${NC}"
echo ""

echo -e "${GREEN}🏁 Setup complete! You're ready to race.${NC}"
echo ""
echo -e "  Run debug:    ${CYAN}flutter run${NC}"
echo -e "  Build APK:    ${CYAN}flutter build apk --debug${NC}"
echo -e "  Release APK:  ${CYAN}flutter build apk --release${NC}"
echo ""
echo -e "${YELLOW}  ⚠️  Remember to replace placeholder audio files in assets/audio/${NC}"
echo -e "${YELLOW}  ⚠️  Replace AdMob test IDs with real IDs before release!${NC}"
echo ""
