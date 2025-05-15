# Orbital Watch

A web-based space collision simulation application built with Unity WebGL.

## Project Overview

Orbital Watch is an interactive web application that allows users to visualize simple collisions between satellites and space debris and learn more about the issue of space debris. The application combines a Unity-based collision simulator with a web interface for easy access.

## Live Application

You can access the live application here: [Orbital Watch](https://orbital-watch-web.vercel.app/)

## Getting Started

### Clone and Setup

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/orbital-watch-web.git
   cd orbital-watch-web
   ```
2. Ensure you have the Unity WebGL build files in the `Build` directory (see Development section for build instructions)

## Running Locally with Docker

The project includes a simple `docker-compose.yml` file with a basic Nginx configuration to serve the application locally in a Docker container.

### Prerequisites
- [Docker](https://www.docker.com/products/docker-desktop/) installed on your system
- Unity WebGL build files in the `Build` directory

### Start the Container

```bash
docker-compose up -d
```

#### Access the Application
Open your browser and navigate to:
```
http://localhost:8080
```

#### Stopping the Container

```bash
docker-compose down
```

## Development Environment Setup

### Prerequisites

- Unity Hub with Unity 6000.0.33f1 (or the version specified in your `.config.env`)
- Node.js and npm
- Vercel CLI (`npm i -g vercel`)

### Configuration

Create or update the `.config.env` file with your specific paths:

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

This project is set up for deployment with Vercel, but any static hosting service can be used as an alternative. For Vercel specifically:

1. Install the Vercel CLI: `npm i -g vercel`
2. Log in to Vercel: `vercel login`
3. Initialize Vercel if not done already: `vercel init`
4. Make sure the `.vercel` directory is properly configured with your project settings

## Project Structure

- `index.html` - Landing page with the main entry point to the application
- `unity-app.html` - The Unity WebGL application page that embeds the simulation
- `js/app.js` - JavaScript for loading and configuring the Unity WebGL content, handles canvas setup and Unity instance creation
- `css/style.css` - Stylesheet for the web interface with custom styling for both landing page and simulator
- `Build/` - Contains the Unity WebGL build files (webgl-dist.* files)
- `StreamingAssets/` - Resources loaded at runtime by the Unity application
- `TemplateData/` - Contains Unity WebGL template assets like loading bar styles, logos, and other UI elements
- `build-and-deploy.sh` - Bash script to automate building from Unity and deployment to Vercel
- `docker-compose.yml` - Configuration for running the application locally using Docker and Nginx
- `vercel.json` - Configuration file for Vercel deployment settings (routes, headers, etc.)
- `.config.env` - Environment configuration file with paths to Unity executable and Unity project location

## Unity WebGL Integration

The project uses a Unity WebGL build that's referenced in `app.js`. Important aspects of this integration:

1. The Unity build files must be named with the `webgl-dist` prefix as specified in `app.js`
2. The canvas in `unity-app.html` is configured to display the Unity WebGL content
3. The loading process includes a progress bar that updates as the Unity content loads
4. Responsive design adjustments are made based on device type (mobile vs desktop)

## Deployment Workflow

### .vercel Configuration

The `.vercel` directory contains crucial deployment configuration that must be properly set up:

- `project.json` - Links the project to your Vercel account and project
- Configuration for build settings and environment variables

When first setting up the project, you need to run `vercel link` to create this configuration or ensure it's properly configured if cloning an existing project.

### Build Process Automation

The `build-and-deploy.sh` script provides several features:

- Automated Unity builds using command-line parameters
- Copying only the necessary build files to the web project
- Configurable paths through `.config.env`
- Optional deployment to Vercel production environment

## Development Notes

- The `app.js` file assumes the Unity WebGL build files are named with the `webgl-dist` prefix
- Any changes to the Unity project require a new build and deployment
- For local testing, you can use a simple HTTP server to serve the files

## Troubleshooting

- **Build script fails**: Check `build.log` for Unity build errors
- **Vercel deployment issues**: Ensure `.vercel` directory is properly configured
- **Unity WebGL not loading**: Verify file paths in `app.js` match your actual build filenames
