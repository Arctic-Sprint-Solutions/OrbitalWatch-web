#!/bin/bash

# Function to display usage info
show_usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --no-deploy    Build only, skip Vercel deployment"
  echo "  --deploy-only  Skip build process, just deploy to Vercel"
  echo "  --config       Path to config file (default: ./.config.env)"
  echo "  --help         Display this help message"
}

# Default values
DEPLOY=true
BUILD=true
CONFIG_FILE="./.config.env"
VERCEL_SITE_PATH="$(pwd)"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-deploy)
      DEPLOY=false
      shift
      ;;
    --deploy-only)
      BUILD=false
      shift
      ;;
    --config)
      CONFIG_FILE="$2"
      shift 2
      ;;
    --help)
      show_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_usage
      exit 1
      ;;
  esac
done

# Load configuration from file
if [ -f "$CONFIG_FILE" ]; then
  echo "📝 Loading configuration from $CONFIG_FILE"
  source "$CONFIG_FILE"
else
  echo "⚠️ Config file not found: $CONFIG_FILE"
  echo "Please create a config file or specify one with --config"
  exit 1
fi

# Only validate Unity paths if we're going to build
if [ "$BUILD" = true ] && ([ -z "$UNITY_PATH" ] || [ -z "$UNITY_PROJECT_PATH" ]); then
  echo "❌ Missing required configuration values in $CONFIG_FILE"
  echo "Please define UNITY_PATH and UNITY_PROJECT_PATH"
  exit 1
fi

# Build process
if [ "$BUILD" = true ]; then
  echo "🔨 Building Unity WebGL project..."
  echo "Using Unity at: $UNITY_PATH"
  echo "Unity project path: $UNITY_PROJECT_PATH"
  echo "Vercel site path: $VERCEL_SITE_PATH"

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
  echo "📦 Copying WebGL build (Build folder and StreamingAssets) to Vercel project folder..."
  rsync -av --delete "$UNITY_PROJECT_PATH/webgl-dist/Build/" "$VERCEL_SITE_PATH/Build/"

  # Copy StreamingAssets folder separately
  rsync -av --delete "$UNITY_PROJECT_PATH/webgl-dist/StreamingAssets/" "$VERCEL_SITE_PATH/StreamingAssets/"

  if [ $? -ne 0 ]; then
    echo "❌ Failed to copy WebGL build to Vercel folder"
    exit 1
  fi

  echo "✅ WebGL build copied successfully to $VERCEL_SITE_PATH"
else
  echo "ℹ️ Skipping build process (--deploy-only option used)"
  
  # Check if Build folder exists
  if [ ! -d "$VERCEL_SITE_PATH/Build" ]; then
    echo "❌ Build folder not found at $VERCEL_SITE_PATH/Build"
    echo "Please build the project first or remove the --deploy-only option"
    exit 1
  fi
fi

# Deploy to Vercel if not skipped
if [ "$DEPLOY" = true ]; then
  echo "🚀 Deploying to Vercel..."
  vercel --prod
  
  if [ $? -ne 0 ]; then
    echo "❌ Vercel deployment failed"
    exit 1
  fi
  
  echo "✅ Vercel deployment complete"
else
  echo "ℹ️ Skipping Vercel deployment (--no-deploy option used)"
fi