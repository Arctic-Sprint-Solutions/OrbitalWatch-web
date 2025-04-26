#!/bin/bash

# Absolute path to Unity executable
UNITY_PATH="/Applications/Unity/Hub/Editor/6000.0.33f1/Unity.app/Contents/MacOS/Unity"

# Path to Unity project from the current directory
UNITY_PROJECT_PATH="../../Unity-Projects/Collision-Simulator"

# Full path to current Vercel project folder
VERCEL_SITE_PATH="$(pwd)"

echo "🔨 Building Unity WebGL project..."
"$UNITY_PATH" -batchmode -nographics -quit \
  -projectPath "$UNITY_PROJECT_PATH" \
  -executeMethod WebGLBuilder.BuildProject \
  -logFile build.log

if [ $? -ne 0 ]; then
  echo "❌ Unity build failed. Check build.log"
  exit 1
fi

echo "✅ Unity build complete."

# Copy the WebGL build from the Unity project to the Vercel folder
echo "📦 Copying WebGL build (Build folder only) to Vercel project folder..."
rsync -av --delete "$UNITY_PROJECT_PATH/webgl-dist/Build/" "$VERCEL_SITE_PATH/Build/"

if [ $? -ne 0 ]; then
  echo "❌ Failed to copy WebGL build to Vercel folder"
  exit 1
fi

echo "✅ WebGL build copied successfully to $VERCEL_SITE_PATH"

echo "🚀 Deploying to Vercel..."
vercel --prod