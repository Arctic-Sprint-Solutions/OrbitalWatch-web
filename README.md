# Orbital Watch

A web-based space collision simulation application built with Unity WebGL.

## Project Overview

Orbital Watch is an interactive web application that allows users to visualize simple collisions between satellites and space debris and learn more about the issue of space debris. The application combines a Unity-based collision simulator with a web interface for easy access.

## Setup Instructions

### Prerequisites

- Unity Hub with Unity 6000.0.33f1 (or the version specified in your `.config.env`)
- Node.js and npm
- Vercel CLI (`npm i -g vercel`)

### Configuration

1. Clone the repository
2. Create or update the `.config.env` file with your specific paths:

```
UNITY_PATH='[Path to your Unity executable]'
UNITY_PROJECT_PATH='[Path to your Unity project]'
```

Example:
```
UNITY_PATH='/Applications/Unity/Hub/Editor/6000.0.33f1/Unity.app/Contents/MacOS/Unity'
UNITY_PROJECT_PATH='../../Unity-Projects/Collision-Simulator'
```

### Unity WebGL Build Setup

The WebGL build from Unity should export files with the following naming convention:
- `webgl-dist.loader.js`
- `webgl-dist.data.unityweb`
- `webgl-dist.framework.js.unityweb`
- `webgl-dist.wasm.unityweb`

These files should be placed in a `Build` directory at the root of this project.

## Building and Deployment

### Using the build-and-deploy.sh script

This project includes a script that handles both building from Unity and deploying to Vercel.

```bash
# Run a complete build and deploy
./build-and-deploy.sh

# Build only (skip Vercel deployment)
./build-and-deploy.sh --no-deploy

# Deploy only (skip Unity build process)
./build-and-deploy.sh --deploy-only

# Use a custom config file
./build-and-deploy.sh --config ./my-custom-config.env
```

### Manual Build Process

1. Open your Unity project
2. Build for WebGL platform
3. Copy the contents of the WebGL build's `Build` folder to the `Build` folder in this project
4. Deploy to Vercel using `vercel --prod`

## Vercel Configuration

For successful deployment to Vercel:

1. Install the Vercel CLI: `npm i -g vercel`
2. Log in to Vercel: `vercel login`
3. Initialize Vercel if not done already: `vercel init`
4. Make sure the `.vercel` directory is properly configured with your project settings

## Project Structure

- `index.html` - Landing page
- `unity-app.html` - The Unity WebGL application page
- `js/app.js` - JavaScript for loading and configuring the Unity WebGL content
- `css/style.css` - Stylesheet for the web interface
- `Build/` - Contains the Unity WebGL build files
- `build-and-deploy.sh` - Script to automate building and deployment

## Development Notes

- The `app.js` file assumes the Unity WebGL build files are named with the `webgl-dist` prefix
- Any changes to the Unity project require a new build and deployment
- For local testing, you can use a simple HTTP server to serve the files

## Troubleshooting

- **Build script fails**: Check `build.log` for Unity build errors
- **Vercel deployment issues**: Ensure `.vercel` directory is properly configured
- **Unity WebGL not loading**: Verify file paths in `app.js` match your actual build filenames
