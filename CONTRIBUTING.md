# Contributing to Egg Gender Prediction System

First off, thank you for considering contributing to the Egg Gender Prediction System! It's people like you that make this project such a great tool for the poultry farming community.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)
- [Testing](#testing)
- [Documentation](#documentation)
- [Community](#community)

---

## 📜 Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behavior includes:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behavior includes:**
- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information without permission
- Other conduct which could reasonably be considered inappropriate

---

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates.

**When submitting a bug report, include:**
- **Clear title** - Use a descriptive title for the issue
- **Description** - Detailed steps to reproduce the problem
- **Expected behavior** - What you expected to happen
- **Actual behavior** - What actually happened
- **Screenshots** - If applicable
- **Environment details**:
  - OS (Windows/Mac/Linux/Raspberry Pi OS)
  - Python version
  - Flutter version (for app issues)
  - Device model (for app issues)
  - Browser (if relevant)

**Example:**
```
Title: Camera detection fails on Raspberry Pi with USB webcam

Description:
When running server.py on Raspberry Pi 4B with a Logitech C270 webcam,
the camera is not detected and /api/status returns camera_available: false

Steps to reproduce:
1. Connect Logitech C270 to Raspberry Pi USB port
2. Run python find_camera.py (shows camera at index 0)
3. Start server with python server.py
4. Call /api/status endpoint

Expected: camera_available should be true
Actual: camera_available is false

Environment:
- Raspberry Pi 4B (4GB RAM)
- Raspberry Pi OS Bullseye
- Python 3.9.2
- OpenCV 4.8.0.76
- Logitech C270 webcam
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues.

**When suggesting an enhancement, include:**
- **Clear title** - Use a descriptive title
- **Detailed description** - Explain why this enhancement would be useful
- **Use cases** - Provide examples of how it would be used
- **Implementation ideas** - If you have any suggestions
- **Alternatives** - Other solutions you've considered

### Your First Code Contribution

Unsure where to begin? Look for issues labeled:
- `good first issue` - Good for newcomers
- `help wanted` - Need assistance
- `documentation` - Documentation improvements
- `enhancement` - New features

### Pull Requests

1. Fork the repo and create your branch from `main`
2. Make your changes
3. Test your changes thoroughly
4. Update documentation if needed
5. Submit a pull request

---

## 💻 Development Setup

### Backend (Python)

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/egg-gender-prediction.git
   cd egg-gender-prediction/APP/egg_detection_server
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run tests** (if available)
   ```bash
   pytest
   ```

5. **Start development server**
   ```bash
   python server.py
   ```

### Frontend (Flutter)

1. **Navigate to Flutter app**
   ```bash
   cd APP/App/egg_detection_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run app**
   ```bash
   flutter run
   ```

4. **Run tests**
   ```bash
   flutter test
   ```

---

## 🔄 Pull Request Process

1. **Update documentation** - Ensure README.md and other docs reflect your changes

2. **Follow style guidelines** - Use consistent coding style (see below)

3. **Add tests** - For new features, add appropriate tests

4. **Update CHANGELOG** - Add your changes to CHANGELOG.md (if exists)

5. **One feature per PR** - Keep pull requests focused on a single feature/fix

6. **Descriptive commits** - Use clear commit messages:
   ```
   ✅ Good: "Add camera calibration feature for manual adjustment"
   ❌ Bad: "Update detection.py"
   ```

7. **Link issues** - Reference related issues in PR description
   ```
   Fixes #123
   Related to #456
   ```

8. **Wait for review** - Maintainer will review and provide feedback

9. **Address feedback** - Make requested changes

10. **Merge** - Once approved, PR will be merged

---

## 🎨 Style Guidelines

### Python Code Style

Follow [PEP 8](https://pep8.org/) guidelines:

```python
# Good
def calculate_esi(width, height):
    """
    Calculate Egg Shape Index.
    
    Args:
        width (float): Egg width in cm
        height (float): Egg height in cm
    
    Returns:
        float: ESI value
    """
    return (width / height) * 100


# Bad
def calc(w,h):
    return w/h*100
```

**Additional Python guidelines:**
- Use 4 spaces for indentation (no tabs)
- Maximum line length: 88 characters (Black formatter)
- Use type hints where applicable
- Add docstrings to all functions and classes
- Use meaningful variable names
- Add comments for complex logic

**Recommended tools:**
```bash
# Format code
black *.py

# Check style
flake8 *.py

# Type checking
mypy *.py
```

### Dart/Flutter Code Style

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

```dart
// Good
class EggDetectionService {
  /// Starts the detection process
  Future<DetectionResult> startDetection() async {
    try {
      final response = await http.post(Uri.parse(apiUrl));
      return DetectionResult.fromJson(response.body);
    } catch (e) {
      throw DetectionException('Failed to start detection: $e');
    }
  }
}

// Bad
class service {
  start() async {
    var x = await http.post(Uri.parse(url));
    return x;
  }
}
```

**Additional Dart guidelines:**
- Use 2 spaces for indentation
- Use trailing commas for better formatting
- Prefer const constructors
- Use meaningful names (no abbreviations)
- Add documentation comments (///)
- Use async/await over .then()

**Format code:**
```bash
dart format .
flutter analyze
```

### Commit Message Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(detection): add manual camera calibration
fix(api): handle timeout errors in detection endpoint
docs(readme): update installation instructions for Windows
refactor(ml): optimize feature engineering pipeline
test(detection): add unit tests for ESI calculation
```

---

## 🧪 Testing

### Python Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=. --cov-report=html

# Run specific test file
pytest tests/test_detection.py

# Run specific test
pytest tests/test_detection.py::test_esi_calculation
```

### Flutter Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Manual Testing Checklist

Before submitting PR, test:

**Backend:**
- [ ] Server starts without errors
- [ ] All API endpoints respond correctly
- [ ] Camera detection works
- [ ] ML predictions are accurate
- [ ] History saves correctly

**Frontend:**
- [ ] App builds without errors
- [ ] Login/registration works
- [ ] Detection screen functions properly
- [ ] Manual input calculates correctly
- [ ] History displays and filters properly
- [ ] UI is responsive on different screen sizes

**Integration:**
- [ ] App connects to server
- [ ] Real-time detection works end-to-end
- [ ] Results display correctly
- [ ] History syncs properly

---

## 📚 Documentation

### Code Documentation

**Python:**
```python
def detect_egg(frame, background_type='light'):
    """
    Detect egg in frame and calculate measurements.
    
    This function processes a camera frame to identify egg contours,
    calculate dimensions, and determine the Egg Shape Index (ESI).
    
    Args:
        frame (numpy.ndarray): Input image frame from camera
        background_type (str): Background type - 'light' or 'dark'
    
    Returns:
        dict: Dictionary containing:
            - width (float): Egg width in cm
            - height (float): Egg height in cm
            - esi (float): Calculated ESI value
            - detected (bool): Whether egg was detected
    
    Raises:
        ValueError: If frame is invalid
        RuntimeError: If detection fails
    
    Example:
        >>> result = detect_egg(camera_frame)
        >>> print(f"ESI: {result['esi']}")
    """
    # Implementation
```

**Dart:**
```dart
/// Service for communicating with egg detection backend API.
///
/// This service handles all HTTP requests to the Flask server,
/// including detection requests, result polling, and history management.
///
/// Example:
/// ```dart
/// final service = ApiService();
/// final result = await service.startDetection();
/// ```
class ApiService {
  /// Starts the automated egg detection process.
  ///
  /// Returns a [Future] that completes with detection status.
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> startDetection() async {
    // Implementation
  }
}
```

### README Updates

When adding features, update:
- Main [README.md](README.md)
- Component READMEs (Flutter app, Python server)
- API documentation (if endpoints changed)
- Installation instructions (if setup changed)

---

## 🌟 Recognition

Contributors will be recognized in:
- README.md contributors section
- CONTRIBUTORS.md file (if created)
- GitHub contributors page
- Release notes for significant contributions

---

## 🤔 Questions?

- **General questions:** Open a Discussion
- **Bug reports:** Create an Issue
- **Feature requests:** Create an Issue
- **Pull requests:** Follow the PR process above

---

## 📞 Contact

- **Project Maintainer:** [Your Name]
- **Email:** your.email@example.com
- **GitHub:** [@yourusername](https://github.com/yourusername)

---

<div align="center">

**Thank you for contributing! 🎉**

Every contribution, no matter how small, makes a difference.

</div>
