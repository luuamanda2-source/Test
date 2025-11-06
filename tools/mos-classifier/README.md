# 🎯 MOS Cases Classifier

**Standalone HTML Application for Automated MOS Case Classification**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![No Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen.svg)](https://github.com)
[![Works Offline](https://img.shields.io/badge/works-offline-blue.svg)](https://github.com)

A completely standalone web application that classifies MOS (Manager on Site) cases into 11 predefined categories based on issue descriptions. **No server, no installation, no dependencies required!**

---

## ✨ Key Features

- 🌐 **100% Browser-Based** - Runs entirely in your browser, no server needed
- 📦 **Zero Dependencies** - Single HTML file, no installation required
- 🔒 **Privacy First** - All processing happens locally, data never leaves your computer
- 🚀 **Instant Start** - Just double-click the HTML file and go
- 📤 **Drag & Drop** - Easy CSV file upload with validation
- 🎯 **Smart Classification** - 11 predefined issue categories with keyword-based logic
- 📊 **Visual Dashboard** - Statistics and preview of classified cases
- 📥 **CSV Export** - Download classified results with timestamp
- 🎨 **Modern UI** - Clean, responsive interface with smooth animations
- 🌍 **Works Offline** - No internet connection required

---

## 🚀 Quick Start

### Option 1: Download and Run (Easiest)

1. **Download** `MOS-Classifier-Standalone.html`
2. **Double-click** the file to open in your browser
3. **Upload** your CSV file (drag & drop or browse)
4. **Click** "Classify Cases"
5. **Download** the classified results

**That's it!** No installation, no setup, no configuration.

### Option 2: Use Online (GitHub Pages)

Visit: `https://luuamanda2-source.github.io/Test/MOS-Classifier-Standalone.html`

*(After you deploy to GitHub Pages - see DEPLOY_TO_GITHUB.md)*

---

## 📋 How It Works

1. **Upload CSV** - File must contain "Any Other Comments" column
2. **Classification** - JavaScript analyzes each comment using keyword patterns
3. **Results** - View statistics and preview of classified cases
4. **Download** - Export classified CSV with new classification column

### Classification Categories (11 Types)

1. **Label/Document Failure** - Printing/label issues
2. **API/Platform Blockers** - System/API problems
3. **System Feature Failure** - Core features not working
4. **Status Conflict (Shipped/OOS)** - Marked shipped but out of stock
5. **Mismatched Status/Stuck** - Status inconsistencies
6. **Missing/Incorrect Data** - Data quality issues
7. **Ineligible Cancellation/Change** - Cannot cancel/change requests
8. **Replacement/Logistics Error** - Shipping/replacement problems
9. **Financial/Claim/Refund** - Money-related issues
10. **Policy & Guidance Gap** - Policy questions/clarifications
11. **Unclassified** - Cases that don't match any category

## Classification Types

The system classifies MOS cases into the following categories:

1. **Label/Document Failure** - Issues with printing labels, BOLs, or documents
2. **API/Platform Blockers** - System issues affecting bulk operations or data exchange
3. **System Feature Failure** - Core actions failing due to errors or system freeze
4. **Status Conflict (Shipped/OOS)** - PO marked as shipped but product is OOS
5. **Mismatched Status/Stuck** - Inconsistent statuses across platforms
6. **Missing/Incorrect Data** - Tracking, carrier, or date update issues
7. **Ineligible Cancellation/Change** - Requests rejected due to business rules
8. **Replacement/Logistics Error** - Issues with replacement POs or split shipments
9. **Financial/Claim/Refund** - Refund, compensation, or claim requests
10. **Policy & Guidance Gap** - Questions about metrics, terms, or lack of SOP
11. **Unclassified** - Cases that don't match any category

## 📖 Documentation

- **[STANDALONE_README.md](STANDALONE_README.md)** - Complete user guide
- **[QUICK_START_STANDALONE.md](QUICK_START_STANDALONE.md)** - Quick start guide
- **[CLASSIFICATION_FIX_REPORT.md](CLASSIFICATION_FIX_REPORT.md)** - Technical details on classification logic
- **[TEST_CLASSIFICATION_FIX.md](TEST_CLASSIFICATION_FIX.md)** - Testing guide

---

## 💻 System Requirements

- **Browser**: Chrome 60+, Firefox 60+, Safari 12+, Edge 79+
- **Operating System**: Windows, macOS, Linux (any OS with a modern browser)
- **Internet**: Not required (works completely offline)
- **Installation**: None
- **Permissions**: None

---

## 📊 CSV File Format

### Input Format
```csv
Ticket ID,Ticket URL,SOP Followed,Steps Taken,Any Other Comments
AOPS-1234567,https://...,N/A,N/A,The supplier informed us that the item is out of stock
```

**Required Column:** `Any Other Comments` (this is what gets classified)

### Output Format
Same as input + new column:
```
Escalation - Sub Reason (Specific Issue Type)
```

---

## 🎯 Use Cases

Perfect for:
- ✅ **Restricted Environments** - Cannot install software or run servers
- ✅ **Quick Analysis** - Need fast classification without setup
- ✅ **Privacy-Sensitive Data** - Data must stay on local machine
- ✅ **Offline Work** - No internet connection available
- ✅ **Team Sharing** - Easy to distribute (just one file)
- ✅ **Non-Technical Users** - Simple double-click to run

## 📁 Repository Structure

```
mos-classifier/
├── MOS-Classifier-Standalone.html    ⭐ Main application (all you need!)
├── README.md                         ← You are here
├── STANDALONE_README.md              ← Complete user guide
├── QUICK_START_STANDALONE.md         ← Quick start guide
├── CLASSIFICATION_FIX_REPORT.md      ← Technical documentation
├── TEST_CLASSIFICATION_FIX.md        ← Testing guide
├── Classify terms.csv                ← Classification rules reference
├── MOS 11.01.25.csv                  ← Sample input file
└── MOS 11.01.25 - Classified.csv     ← Sample output file
```

**Essential File:** `MOS-Classifier-Standalone.html` - This is all you need to run the application!

---

## 🔧 Technical Details

### Architecture
- **Frontend**: Pure HTML5 + JavaScript (ES6) + CSS3
- **Processing**: Client-side JavaScript
- **Storage**: Browser memory (temporary)
- **File I/O**: FileReader API + Blob API
- **Dependencies**: None (zero external libraries)

### How It Works
1. **File Reading**: Browser's FileReader API reads CSV
2. **CSV Parsing**: Custom JavaScript parser (no libraries)
3. **Classification**: Keyword-based pattern matching
4. **Statistics**: JavaScript object counting
5. **Export**: Blob API creates downloadable CSV

### Security & Privacy
- ✅ No data uploaded to any server
- ✅ No network requests made
- ✅ No cookies or tracking
- ✅ All processing in browser memory
- ✅ Data cleared when page is closed

## 🔧 Troubleshooting

### File Won't Open
**Solution**: Right-click → Open with → Choose your browser

### Classifications Look Wrong
**Solution**:
- Check that CSV has "Any Other Comments" column
- Verify column contains meaningful text
- See [CLASSIFICATION_FIX_REPORT.md](CLASSIFICATION_FIX_REPORT.md) for logic details

### Download Doesn't Work
**Solution**:
- Check browser download settings
- Ensure downloads aren't blocked
- Try a different browser

### Large File is Slow
**Solution**:
- Files with 1000+ rows may take a few seconds
- This is normal for browser-based processing
- Consider splitting very large files

For more help, see **[STANDALONE_README.md](STANDALONE_README.md)**

---

## 🛠️ Customization

### Modify Classification Rules

1. Open `MOS-Classifier-Standalone.html` in a text editor
2. Find the `classifyCase()` function (around line 310)
3. Modify the keyword patterns and logic
4. Save and refresh browser

Example:
```javascript
// Add new category
if (lowerComment.includes('your keyword')) {
    return 'Your New Category';
}
```

### Modify Styling

1. Open `MOS-Classifier-Standalone.html` in a text editor
2. Find the `<style>` section (lines 7-200)
3. Modify colors, fonts, layout
4. Save and refresh browser

---

## 🔗 Integration with Luong's Productivity Hub

### Option 1: Embed as iFrame
```html
<iframe src="path/to/MOS-Classifier-Standalone.html"
        width="100%" height="800px" frameborder="0">
</iframe>
```

### Option 2: Link from Dashboard
```html
<a href="path/to/MOS-Classifier-Standalone.html" target="_blank">
    MOS Cases Classifier
</a>
```

### Option 3: Extract Components
The HTML file contains modular JavaScript functions that can be extracted and integrated into larger applications.

See **[INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)** for detailed instructions.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📊 Performance

- **File Size**: ~50KB (single HTML file)
- **Load Time**: < 1 second
- **Processing Speed**:
  - Small files (< 100 cases): < 1 second
  - Medium files (100-500 cases): 1-2 seconds
  - Large files (500-1000 cases): 2-5 seconds
- **Memory Usage**: Minimal (browser-based)

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

---

## 👤 Author

**Luong's Productivity Hub Team**

---

## 🙏 Acknowledgments

- Built for MOS case classification automation
- Designed for restricted environments
- Optimized for privacy and offline use

---

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check the documentation files
- Review the troubleshooting section

---

**Ready to classify your MOS cases?**

**Just download `MOS-Classifier-Standalone.html` and double-click to start!** 🚀

