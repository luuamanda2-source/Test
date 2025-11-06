# 🔗 Integration Guide - Luong's Productivity Hub

## Overview

This guide explains how to integrate the MOS Cases Classifier into Luong's Productivity Hub.

---

## 🎯 Integration Options

### Option 1: Direct Link (Easiest)
Add a link to the standalone HTML file from your Productivity Hub dashboard.

### Option 2: iFrame Embed (Recommended)
Embed the classifier as an iframe within your hub.

### Option 3: Component Integration (Advanced)
Extract and integrate the classification logic into your existing application.

---

## 📋 Option 1: Direct Link

### Implementation

Add this to your Productivity Hub dashboard:

```html
<div class="tool-card">
    <h3>🎯 MOS Cases Classifier</h3>
    <p>Automatically classify MOS cases into 11 categories</p>
    <a href="tools/mos-classifier/MOS-Classifier-Standalone.html" 
       target="_blank" 
       class="btn btn-primary">
        Open Classifier
    </a>
</div>
```

### File Structure
```
productivity-hub/
├── index.html
├── tools/
│   └── mos-classifier/
│       └── MOS-Classifier-Standalone.html
```

### Pros
- ✅ Easiest to implement
- ✅ No code changes needed
- ✅ Opens in new tab
- ✅ Full functionality

### Cons
- ❌ Separate window
- ❌ Not integrated into hub UI

---

## 🖼️ Option 2: iFrame Embed (Recommended)

### Implementation

Create a dedicated page in your Productivity Hub:

```html
<!-- productivity-hub/pages/mos-classifier.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MOS Cases Classifier - Productivity Hub</title>
    <link rel="stylesheet" href="../styles/main.css">
</head>
<body>
    <!-- Your Productivity Hub Header/Navigation -->
    <header class="hub-header">
        <h1>Luong's Productivity Hub</h1>
        <nav><!-- Your navigation --></nav>
    </header>

    <!-- MOS Classifier iFrame -->
    <main class="hub-content">
        <div class="tool-container">
            <iframe 
                src="../tools/mos-classifier/MOS-Classifier-Standalone.html" 
                width="100%" 
                height="900px" 
                frameborder="0"
                style="border: none; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
            </iframe>
        </div>
    </main>

    <!-- Your Productivity Hub Footer -->
    <footer class="hub-footer">
        <!-- Your footer content -->
    </footer>
</body>
</html>
```

### Dashboard Link

Add this to your main dashboard:

```html
<div class="tool-card">
    <div class="tool-icon">🎯</div>
    <h3>MOS Cases Classifier</h3>
    <p>Classify MOS cases automatically</p>
    <a href="pages/mos-classifier.html" class="btn btn-primary">
        Launch Tool
    </a>
</div>
```

### Styling for Integration

```css
/* Add to your hub's CSS */
.tool-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 20px;
}

.tool-container iframe {
    width: 100%;
    min-height: 900px;
    border: none;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

/* Responsive */
@media (max-width: 768px) {
    .tool-container iframe {
        min-height: 700px;
    }
}
```

### Pros
- ✅ Integrated into hub UI
- ✅ Maintains hub navigation
- ✅ Consistent user experience
- ✅ Easy to implement

### Cons
- ❌ Slight iframe overhead
- ❌ Scrolling within iframe

---

## 🔧 Option 3: Component Integration (Advanced)

### Extract Classification Logic

Extract the `classifyCase()` function from the standalone HTML:

```javascript
// Add to your Productivity Hub's JavaScript
function classifyMOSCase(comment) {
    if (!comment || comment === 'N/A') {
        return 'Unclassified';
    }

    const lowerComment = comment.toLowerCase();

    // Status Conflict (Shipped/OOS)
    if ((lowerComment.includes('marked as shipped') || 
         lowerComment.includes('marked as ship')) && 
        (lowerComment.includes('out of stock') || 
         lowerComment.includes('not shipped') || 
         lowerComment.includes("hasn't") || 
         lowerComment.includes('oos'))) {
        return 'Status Conflict (Shipped/OOS)';
    }

    // Label/Document Failure
    if (lowerComment.includes('blank') && lowerComment.includes('label')) {
        return 'Label/Document Failure';
    }

    // ... (copy all other classification logic)

    return 'Unclassified';
}
```

### CSV Processing Functions

```javascript
// CSV Parser
function parseCSV(text) {
    const lines = text.split('\n').filter(line => line.trim());
    if (lines.length === 0) return [];

    const headers = lines[0].split(',').map(h => h.trim().replace(/^"|"$/g, ''));
    const rows = [];

    for (let i = 1; i < lines.length; i++) {
        const values = parseCSVLine(lines[i]);
        if (values.length === headers.length) {
            const row = {};
            headers.forEach((header, index) => {
                row[header] = values[index];
            });
            rows.push(row);
        }
    }

    return rows;
}

function parseCSVLine(line) {
    const result = [];
    let current = '';
    let inQuotes = false;

    for (let i = 0; i < line.length; i++) {
        const char = line[i];
        
        if (char === '"') {
            inQuotes = !inQuotes;
        } else if (char === ',' && !inQuotes) {
            result.push(current.trim().replace(/^"|"$/g, ''));
            current = '';
        } else {
            current += char;
        }
    }
    
    result.push(current.trim().replace(/^"|"$/g, ''));
    return result;
}
```

### Integration into Your App

```javascript
// Example: Add to your existing file upload handler
async function handleMOSFileUpload(file) {
    const text = await file.text();
    const rows = parseCSV(text);
    
    // Classify each row
    const classifiedData = rows.map(row => {
        const comment = row['Any Other Comments'] || '';
        const classification = classifyMOSCase(comment);
        return {
            ...row,
            'Escalation - Sub Reason (Specific Issue Type)': classification
        };
    });
    
    // Display results in your UI
    displayResults(classifiedData);
}
```

### Pros
- ✅ Fully integrated into your app
- ✅ Can customize UI completely
- ✅ Can add additional features
- ✅ No iframe needed

### Cons
- ❌ More complex implementation
- ❌ Need to maintain code
- ❌ Requires JavaScript knowledge

---

## 📁 Recommended File Structure

```
luongs-productivity-hub/
├── index.html                          # Main dashboard
├── pages/
│   ├── mos-classifier.html            # MOS Classifier page (Option 2)
│   ├── other-tool-1.html
│   └── other-tool-2.html
├── tools/
│   └── mos-classifier/
│       └── MOS-Classifier-Standalone.html  # Standalone tool
├── styles/
│   ├── main.css                       # Hub styles
│   └── tools.css                      # Tool-specific styles
├── scripts/
│   ├── main.js                        # Hub JavaScript
│   └── mos-classifier.js              # Extracted logic (Option 3)
└── assets/
    └── images/
        └── mos-classifier-icon.png
```

---

## 🎨 UI Integration Examples

### Dashboard Card

```html
<div class="tools-grid">
    <!-- Other tools -->
    
    <div class="tool-card mos-classifier">
        <div class="tool-header">
            <span class="tool-icon">🎯</span>
            <h3>MOS Cases Classifier</h3>
        </div>
        <p class="tool-description">
            Automatically classify MOS cases into 11 predefined categories. 
            Upload CSV, get instant results.
        </p>
        <div class="tool-stats">
            <span class="stat">
                <strong>11</strong> Categories
            </span>
            <span class="stat">
                <strong>Instant</strong> Results
            </span>
        </div>
        <div class="tool-actions">
            <a href="pages/mos-classifier.html" class="btn btn-primary">
                Launch Tool
            </a>
            <a href="tools/mos-classifier/MOS-Classifier-Standalone.html" 
               target="_blank" 
               class="btn btn-secondary">
                Open Standalone
            </a>
        </div>
    </div>
    
    <!-- Other tools -->
</div>
```

### Styling

```css
.tool-card.mos-classifier {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.tool-card.mos-classifier .tool-icon {
    font-size: 3rem;
}

.tool-card.mos-classifier .btn-primary {
    background: white;
    color: #667eea;
}

.tool-card.mos-classifier .btn-primary:hover {
    background: #f0f0f0;
}
```

---

## 🔄 Data Flow Integration

### Option A: Standalone Workflow
```
User → Dashboard → Click "MOS Classifier" → 
Opens Standalone HTML → Upload CSV → 
Classify → Download Results → 
User manually saves/uses results
```

### Option B: Integrated Workflow
```
User → Dashboard → Click "MOS Classifier" → 
Opens in Hub Page (iframe) → Upload CSV → 
Classify → Download Results → 
Results can be sent to other hub tools
```

### Option C: Fully Integrated Workflow
```
User → Dashboard → Upload CSV → 
Hub processes with integrated logic → 
Results displayed in hub → 
Can export or send to other tools → 
Stored in hub database (optional)
```

---

## 🚀 Deployment Steps

### Step 1: Prepare Files
1. Copy `MOS-Classifier-Standalone.html` to your hub's `tools/mos-classifier/` folder
2. Create integration page (if using Option 2)
3. Update dashboard with link/card

### Step 2: Test Integration
1. Open your Productivity Hub
2. Navigate to MOS Classifier
3. Test file upload and classification
4. Verify download works
5. Check responsive design

### Step 3: Deploy
1. Commit changes to your repository
2. Push to GitHub
3. Deploy to GitHub Pages or your hosting

---

## 📊 Analytics Integration (Optional)

Track usage of the MOS Classifier:

```javascript
// Add to your hub's analytics
function trackMOSClassifierUsage(action, data) {
    // Example with Google Analytics
    gtag('event', action, {
        'event_category': 'MOS Classifier',
        'event_label': data.label,
        'value': data.value
    });
}

// Track when tool is opened
trackMOSClassifierUsage('tool_opened', { label: 'MOS Classifier', value: 1 });

// Track when file is classified
trackMOSClassifierUsage('file_classified', { 
    label: 'Cases Classified', 
    value: numberOfCases 
});
```

---

## 🔒 Security Considerations

### Data Privacy
- ✅ All processing happens client-side
- ✅ No data sent to external servers
- ✅ Files not stored on server
- ✅ Safe for sensitive data

### Content Security Policy
If your hub uses CSP, ensure it allows:
```html
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self' 'unsafe-inline'; 
               frame-src 'self';">
```

---

## 📱 Mobile Responsiveness

The standalone HTML is already mobile-responsive. For iframe integration:

```css
@media (max-width: 768px) {
    .tool-container iframe {
        min-height: 600px;
    }
}

@media (max-width: 480px) {
    .tool-container {
        padding: 10px;
    }
    
    .tool-container iframe {
        min-height: 500px;
    }
}
```

---

## ✅ Integration Checklist

- [ ] Choose integration option (Link, iFrame, or Component)
- [ ] Copy standalone HTML to hub directory
- [ ] Create integration page (if using iFrame)
- [ ] Add dashboard card/link
- [ ] Test file upload functionality
- [ ] Test classification accuracy
- [ ] Test download functionality
- [ ] Verify mobile responsiveness
- [ ] Test in different browsers
- [ ] Update hub navigation
- [ ] Add to hub documentation
- [ ] Deploy to production

---

## 🎉 Recommended Approach

**For Luong's Productivity Hub, we recommend Option 2 (iFrame Embed):**

1. ✅ Easy to implement
2. ✅ Maintains hub UI consistency
3. ✅ No code changes to classifier
4. ✅ Easy to update
5. ✅ Works with existing hub structure

---

## 📞 Support

For integration help:
- Review this guide
- Check the main README.md
- Test with sample files
- Verify browser compatibility

---

**Ready to integrate?** Follow the steps above and your MOS Classifier will be part of Luong's Productivity Hub! 🚀

