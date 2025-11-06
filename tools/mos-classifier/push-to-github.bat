@echo off
echo ========================================
echo Push MOS Classifier to GitHub
echo ========================================
echo.
echo Repository: https://github.com/luuamanda2-source/Test
echo Username: luuamanda2-source
echo.
echo ========================================
echo.

REM Check if Git is installed
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed!
    echo.
    echo Please install Git from: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo [OK] Git is installed
echo.

REM Initialize Git if needed
if not exist ".git" (
    echo Initializing Git repository...
    git init
    echo.
)

REM Add all files
echo Adding files to Git...
git add .
echo.

REM Create commit
echo Creating commit...
set /p commit_message="Enter commit message (or press Enter for default): "
if "%commit_message%"=="" set commit_message=Add MOS Cases Classifier standalone application

git commit -m "%commit_message%"
echo.

REM Check if remote exists
git remote -v | findstr "origin" >nul 2>&1
if %errorlevel% neq 0 (
    echo Adding remote repository...
    git remote add origin https://github.com/luuamanda2-source/Test.git
) else (
    echo Remote repository already configured
    echo Updating remote URL...
    git remote set-url origin https://github.com/luuamanda2-source/Test.git
)
echo.

REM Set branch to main
echo Setting branch to main...
git branch -M main
echo.

REM Push to GitHub
echo ========================================
echo Pushing to GitHub...
echo ========================================
echo.
echo You may be prompted for GitHub credentials.
echo If asked for password, use a Personal Access Token.
echo.

git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo [SUCCESS] Pushed to GitHub!
    echo ========================================
    echo.
    echo Repository: https://github.com/luuamanda2-source/Test
    echo.
    echo Next steps:
    echo 1. Go to: https://github.com/luuamanda2-source/Test
    echo 2. Verify files are uploaded
    echo 3. Enable GitHub Pages in Settings
    echo 4. Access live app at:
    echo    https://luuamanda2-source.github.io/Test/MOS-Classifier-Standalone.html
    echo.
) else (
    echo.
    echo ========================================
    echo [ERROR] Push failed!
    echo ========================================
    echo.
    echo Common solutions:
    echo 1. Check your internet connection
    echo 2. Verify GitHub credentials
    echo 3. Use Personal Access Token instead of password
    echo 4. Check repository permissions
    echo.
    echo For help, see: DEPLOY_TO_GITHUB.md
    echo.
)

echo.
pause

