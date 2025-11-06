# 📝 Guide: Updating Classification Rules

## Overview

The MOS Cases Classifier uses **hardcoded classification logic** in JavaScript to categorize cases. The `Classify terms.csv` file is **for reference only** and is not used by the application during classification.

---

## ⚠️ Important Understanding

### Current Architecture:
- ✅ **Classification logic**: Hardcoded in `MOS-Classifier-Standalone.html` (JavaScript)
- ❌ **Classify terms.csv**: Reference documentation only (NOT used by the app)

### Why This Design?
1. **100% browser-based**: No server needed, works completely offline
2. **Fast performance**: No need to load/parse external files
3. **Self-contained**: Single HTML file with all logic embedded
4. **Reliability**: No dependency on external file loading

---

## 🔧 How to Update Classification Rules

### Method 1: Edit the JavaScript Code (Recommended)

**Step 1: Open the file**
```
tools/mos-classifier/MOS-Classifier-Standalone.html
```

**Step 2: Find the classification function**
Search for: `function classifyCase(comment)`
Located around line 369-450

**Step 3: Modify the classification logic**

Each category follows this pattern:
```javascript
// Category Name
if (lowerComment.includes('keyword1') || lowerComment.includes('keyword2')) {
    return 'Category Name';
}
```

**Example - Adding a new keyword to "Financial/Claim/Refund":**

**Before:**
```javascript
// Financial/Claim/Refund
if (lowerComment.includes('refund') || lowerComment.includes('compensation') ||
    lowerComment.includes('claim') || lowerComment.includes('discount')) {
    return 'Financial/Claim/Refund';
}
```

**After:**
```javascript
// Financial/Claim/Refund
if (lowerComment.includes('refund') || lowerComment.includes('compensation') ||
    lowerComment.includes('claim') || lowerComment.includes('discount') ||
    lowerComment.includes('reimbursement') || lowerComment.includes('credit')) {
    return 'Financial/Claim/Refund';
}
```

**Step 4: Save the file**

**Step 5: Test locally**
- Open `MOS-Classifier-Standalone.html` in your browser
- Upload a test CSV file
- Verify the new classification rules work correctly

**Step 6: Deploy to GitHub**
```bash
git add tools/mos-classifier/MOS-Classifier-Standalone.html
git commit -m "Update classification rules: Add new keywords for Financial/Claim/Refund"
git push origin main
```

**Step 7: Wait for GitHub Pages to rebuild (30-60 seconds)**

---

## 📋 Current Classification Categories

### 1. Status Conflict (Shipped/OOS)
**Keywords:**
- "marked as shipped" OR "marked as ship"
- AND ("out of stock" OR "not shipped" OR "hasn't" OR "oos")

### 2. Label/Document Failure
**Keywords:**
- "blank" AND "label"

### 3. API/Platform Blockers
**Keywords:**
- "api" OR "sftp" OR "file is not getting created" OR "not getting exported"
- OR ("tech issue" AND "dropship")

### 4. System Feature Failure
**Keywords:**
- ("system does not allow" OR ("no" AND "option available"))
- AND ("change" OR "changing")
- AND "ship"

### 5. Replacement/Logistics Error
**Keywords:**
- ("replacement" AND ("order" OR "po"))
- OR "split" OR "two items" OR "two packages" OR "additional label"
- OR "wrong tracking" OR "confusing order"
- OR "shipped incorrectly" OR "missing hardware"

### 6. Mismatched Status/Stuck
**Keywords:**
- ("replaced" OR "replacement")
- AND ("still" AND ("overdue" OR "pending"))

### 7. Missing/Incorrect Data
**Keywords:**
- "return tracking"
- AND ("not find" OR "no movement")

### 8. Financial/Claim/Refund
**Keywords:**
- "refund" OR "compensation" OR "claim" OR "discount"

### 9. Ineligible Cancellation/Change
**Keywords:**
- "cannot cancel" OR "cannot change"

### 10. Policy & Guidance Gap
**Keywords:**
- ("out of stock" AND "delay")
- OR "wants to be actived" OR "activate"
- OR "inquired" OR "requested assistance"

### 11. Unclassified
**Default category** when:
- Comment is empty, "N/A", or undefined
- No keywords match any category

---

## 🎯 Best Practices for Updating Rules

### 1. **Test Before Deploying**
Always test changes locally before pushing to GitHub:
```bash
# Open the file directly in browser
file:///d:/STID/Software/Test-main/tools/mos-classifier/MOS-Classifier-Standalone.html
```

### 2. **Use Lowercase Keywords**
The code converts comments to lowercase, so use lowercase keywords:
```javascript
✅ lowerComment.includes('refund')
❌ lowerComment.includes('Refund')
```

### 3. **Order Matters**
Categories are checked in order. More specific rules should come first:
```javascript
// ✅ Good: Specific rule first
if (lowerComment.includes('marked as shipped') && lowerComment.includes('out of stock')) {
    return 'Status Conflict (Shipped/OOS)';
}
if (lowerComment.includes('out of stock')) {
    return 'Policy & Guidance Gap';
}

// ❌ Bad: Generic rule first (will catch everything)
if (lowerComment.includes('out of stock')) {
    return 'Policy & Guidance Gap';
}
if (lowerComment.includes('marked as shipped') && lowerComment.includes('out of stock')) {
    return 'Status Conflict (Shipped/OOS)';  // Never reached!
}
```

### 4. **Use AND/OR Logic Carefully**
```javascript
// AND logic (both must be present)
if (lowerComment.includes('refund') && lowerComment.includes('partial')) {
    return 'Financial/Claim/Refund';
}

// OR logic (any one can be present)
if (lowerComment.includes('refund') || lowerComment.includes('compensation')) {
    return 'Financial/Claim/Refund';
}

// Complex logic (use parentheses)
if ((lowerComment.includes('refund') || lowerComment.includes('compensation')) &&
    lowerComment.includes('partial')) {
    return 'Financial/Claim/Refund';
}
```

### 5. **Keep Classify terms.csv Updated**
While not used by the app, update it for documentation:
```csv
Category,Keywords,Example
Financial/Claim/Refund,"refund, compensation, claim, discount, reimbursement, credit","Supplier requests partial refund"
```

---

## 🔄 Workflow for Business Policy Changes

### Scenario: New business policy requires tracking "price adjustment" cases

**Step 1: Decide the category**
- Should "price adjustment" go to "Financial/Claim/Refund"? ✅
- Or create a new category? (requires more changes)

**Step 2: Update the JavaScript**
```javascript
// Financial/Claim/Refund
if (lowerComment.includes('refund') || lowerComment.includes('compensation') ||
    lowerComment.includes('claim') || lowerComment.includes('discount') ||
    lowerComment.includes('price adjustment')) {
    return 'Financial/Claim/Refund';
}
```

**Step 3: Update Classify terms.csv (for documentation)**
```csv
Financial/Claim/Refund,"refund, compensation, claim, discount, price adjustment","..."
```

**Step 4: Test with sample data**
Create a test CSV with "price adjustment" in comments

**Step 5: Deploy**
```bash
git add tools/mos-classifier/
git commit -m "Add 'price adjustment' to Financial/Claim/Refund category"
git push origin main
```

**Step 6: Verify on GitHub Pages**
Wait 1 minute, then test at: https://luuamanda2-source.github.io/Test/mos-classifier.html

---

## 🆕 Adding a New Category

If you need to add a completely new category (e.g., "Shipping Delays"):

**Step 1: Add the classification logic**
```javascript
// Add BEFORE the final "return 'Unclassified';" line

// Shipping Delays
if (lowerComment.includes('delayed') || lowerComment.includes('late shipment') ||
    lowerComment.includes('shipping delay')) {
    return 'Shipping Delays';
}
```

**Step 2: Update the category list in the HTML**
Search for the statistics section and add the new category to the color mapping.

**Step 3: Update Classify terms.csv**
Add a new row for the category.

**Step 4: Test and deploy**

---

## 📊 Monitoring Classification Accuracy

### Use Browser Console for Debugging
1. Open the classifier page
2. Press F12 to open Developer Tools
3. Go to Console tab
4. Upload your CSV file
5. Check the console logs:
   ```
   CSV Headers detected: ["Ticket ID", "Any Other Comments", ...]
   First data row: {Ticket ID: "...", Any Other Comments: "..."}
   Row 1 - Comment: "..." -> Classification: "..."
   ```

### Review Unclassified Cases
After classification, check which cases are "Unclassified":
- These are cases that didn't match any keywords
- Review them to identify missing keywords
- Update the classification logic accordingly

---

## 🚀 Quick Reference

| Task | File to Edit | Line Number |
|------|-------------|-------------|
| Add/modify keywords | `MOS-Classifier-Standalone.html` | ~369-450 |
| Update documentation | `Classify terms.csv` | Any |
| Test changes | Open HTML file in browser | - |
| Deploy changes | `git push origin main` | - |

---

## ❓ FAQ

**Q: Can I make the app read from Classify terms.csv instead of hardcoded logic?**
A: Yes, but it would require significant code changes and add complexity. The current approach is simpler and more reliable.

**Q: How long does it take for changes to appear on GitHub Pages?**
A: Usually 30-60 seconds after pushing to GitHub.

**Q: Can I test changes without deploying?**
A: Yes! Open the HTML file directly in your browser from your local folder.

**Q: What if I break something?**
A: Use Git to revert: `git checkout HEAD -- tools/mos-classifier/MOS-Classifier-Standalone.html`

---

**Last Updated**: 2025-11-07  
**Maintained By**: Luong's Productivity Hub Team

