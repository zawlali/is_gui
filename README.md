# Scholar Jim

A scholarship management application that uses AI models to evaluate and recommend scholarships based on country-specific data.

## Overview

After cloning this repository, you have **two options**:

1. **Run the pre-compiled version** - Quick setup, no Flutter required
2. **Modify and rebuild the application** - Requires Flutter SDK setup

Choose the option that best fits your needs.

## Option 1: Using the Pre-compiled Version

This repository comes with a pre-compiled web application. To run it:

1. Install Python 3.12 (if not already installed)
   - Open Microsoft Store
   - Search for "Python 3.12"
   - Click "Get" or "Install"

2. Clone the repository
```bash
git clone https://github.com/zawlali/is_gui.git
cd is_gui
```

3. Set up the web server
```bash
# Navigate to services directory
cd lib/services

# Create and activate virtual environment
python -m venv venv
.\venv\Scripts\activate  # On Windows
# OR
source venv/bin/activate  # On macOS/Linux

# Install dependencies
pip install flask tensorflow scikit-fuzzy numpy scipy networkx

# Start the AI server
python web_server.py
```

4. In a new terminal, launch the web application
```bash
# Navigate to the pre-compiled web build
cd build/web

# Start a Python web server
python -m http.server 8000
```

5. Open your browser and visit http://localhost:8000

## Option 2: Modifying and Rebuilding the Application

If you need to make changes to the application:

1. Install Prerequisites
   - Visual Studio Code from [VS Code Official Site](https://code.visualstudio.com/)
   - Flutter VS Code Extensions:
     - "Flutter" by Dart Code
     - "Dart" by Dart Code
   - Flutter SDK (will be prompted during VS Code setup)

2. Clone the repository (if not already done)
```bash
git clone https://github.com/zawlali/is_gui.git
cd is_gui
```

3. Set up the AI server (same as Option 1)

4. Run in development mode
```bash
# From project root
flutter run -d chrome
```