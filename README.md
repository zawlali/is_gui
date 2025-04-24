# Scholar Jim

A scholarship management application that uses AI models to evaluate and recommend scholarships based on country-specific data.

## Prerequisites

1. Install Visual Studio Code
   - Download and install from [VS Code Official Site](https://code.visualstudio.com/)

2. Install Flutter VS Code Extensions
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for and install:
     - "Flutter" by Dart Code
     - "Dart" by Dart Code

3. Install Flutter SDK
   - When prompted by VS Code, click "Install" to get the Flutter SDK
   - Alternatively, follow the [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)

4. Install Python 3.12
   - Open Microsoft Store
   - Search for "Python 3.12"
   - Click "Get" or "Install"
   - This method ensures proper PATH variable configuration

## Setup Instructions

1. Clone the repository
```bash
git clone https://github.com/zawlali/is_gui.git
cd is_gui
```

2. Create Python Virtual Environment
```bash
# Navigate to project root
cd lib/services

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
.\venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate
```

3. Install Python Dependencies
```bash
pip install flask tensorflow scikit-fuzzy numpy scipy networkx
```

4. Start the AI Models Server
```bash
# Ensure you're in lib/services directory with activated venv
python web_server.py
```
The server will start at http://localhost:5000

5. Run the Flutter Application
   - Open the project in VS Code
   - Select Chrome as your device (View > Command Palette > Flutter: Select Device)
   - Press F5 or click Run > Start Debugging
   - The app will launch in Chrome at http://localhost:54321 (port may vary)