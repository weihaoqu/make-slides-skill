# Feedback Form Template

Add this as the **last slide** in a deck when the user requests a feedback form. It submits responses to a Google Sheet via Apps Script.

## Google Sheet Setup Instructions

Provide these to the user:

1. Create a new Google Sheet
2. Go to **Extensions > Apps Script**
3. Replace the default code with:

```javascript
function doPost(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var data = JSON.parse(e.postData.contents);
  if (sheet.getLastRow() === 0) {
    sheet.appendRow(['Timestamp','Topic','Overall Rating (1-5)','ASCII Diagrams','Knew AI-Assisted?','vs eCampus (1-5)','Best Slide','Comments']);
  }
  sheet.appendRow([
    new Date(),
    data.topic || '',
    data.rating || '',
    data.diagrams || '',
    data.knew_ai || '',
    data.vs_ecampus || '',
    data.best_slide || '',
    data.comments || ''
  ]);
  return ContentService.createTextOutput(JSON.stringify({status:'ok'}))
    .setMimeType(ContentService.MimeType.JSON);
}
```

4. Click **Deploy > New Deployment**
5. Select **Web app**
6. Set "Execute as" to **Me** and "Who has access" to **Anyone**
7. Click **Deploy** and copy the URL

## Additional CSS (add to the `<style>` block)

```css
/* Feedback form styles */
.feedback-form label { display: block; margin: 12px 0 4px; color: #93c5fd; font-weight: 600; }
.feedback-form select, .feedback-form textarea, .feedback-form input[type="text"] {
  width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #475569;
  background: #1e293b; color: #e2e8f0; font-size: 1em; font-family: inherit;
}
.feedback-form textarea { min-height: 80px; resize: vertical; }
.feedback-form .radio-group { display: flex; gap: 16px; margin-top: 6px; }
.feedback-form .radio-group label { display: flex; align-items: center; gap: 6px; cursor: pointer; color: #cbd5e1; font-weight: normal; }
```

## Feedback Slide HTML

Replace `TOPIC_NAME` with the actual topic and `GOOGLE_SHEET_URL_HERE` with the Apps Script URL.

```html
<!-- ==================== SLIDE N: FEEDBACK ==================== -->
<div class="slide" id="sN">
  <h1>We'd Love Your Feedback!</h1>
  <p class="subtitle">Help us improve these teaching materials</p>
  <div id="feedback-form-container" style="max-width: 700px; margin: 0 auto;">
    <form id="feedbackForm" onsubmit="submitFeedback(event)" class="feedback-form">

      <label>1. How helpful was this slide deck overall? (1 = not helpful, 5 = very helpful)</label>
      <div class="radio-group">
        <label><input type="radio" name="rating" value="1" required> 1</label>
        <label><input type="radio" name="rating" value="2"> 2</label>
        <label><input type="radio" name="rating" value="3"> 3</label>
        <label><input type="radio" name="rating" value="4"> 4</label>
        <label><input type="radio" name="rating" value="5"> 5</label>
      </div>

      <label>2. Were the ASCII diagrams helpful for understanding concepts?</label>
      <select name="diagrams">
        <option value="">-- Select --</option>
        <option value="Very helpful">Very helpful - made concepts much clearer</option>
        <option value="Somewhat helpful">Somewhat helpful</option>
        <option value="Neutral">Neutral - didn't make a difference</option>
        <option value="Not helpful">Not helpful - preferred other formats</option>
      </select>

      <label>3. Did you know these slides were AI-assisted before this question?</label>
      <div class="radio-group">
        <label><input type="radio" name="knew_ai" value="Yes" required> Yes</label>
        <label><input type="radio" name="knew_ai" value="No"> No</label>
        <label><input type="radio" name="knew_ai" value="Suspected"> I suspected</label>
      </div>

      <label>4. Compared to traditional eCampus slides, how would you rate this format? (1 = much worse, 5 = much better)</label>
      <div class="radio-group">
        <label><input type="radio" name="vs_ecampus" value="1" required> 1</label>
        <label><input type="radio" name="vs_ecampus" value="2"> 2</label>
        <label><input type="radio" name="vs_ecampus" value="3"> 3</label>
        <label><input type="radio" name="vs_ecampus" value="4"> 4</label>
        <label><input type="radio" name="vs_ecampus" value="5"> 5</label>
      </div>

      <label>5. Which slide was most helpful? (optional)</label>
      <input type="text" name="best_slide" placeholder="e.g., 'The BFS step-by-step trace'">

      <label>6. Any other comments or suggestions? (optional)</label>
      <textarea name="comments" placeholder="What could be improved? What did you like most?"></textarea>

      <div style="margin-top: 20px; text-align: center;">
        <button type="submit" id="submitBtn" style="background:linear-gradient(135deg,#3b82f6,#8b5cf6); color:white; border:none; padding:12px 36px; border-radius:8px; font-size:1.1em; cursor:pointer; font-weight:600; transition: opacity 0.2s;">Submit Feedback</button>
      </div>
    </form>
    <div id="feedback-success" style="display:none; text-align:center; padding:40px;">
      <h2 style="color:#34d399;">Thank You!</h2>
      <p style="font-size:1.2em;">Your feedback has been recorded. It helps us make better learning materials.</p>
    </div>
    <div id="feedback-error" style="display:none; text-align:center; padding:20px;">
      <p style="color:#f87171;">There was an issue submitting. Your response was saved locally.</p>
    </div>
  </div>
  <div class="slide-number">N</div>
</div>
```

## Feedback JavaScript

Add this to the `<script>` block, before `showSlide(1);`:

```javascript
// ===== GOOGLE SHEET FEEDBACK SUBMISSION =====
const GOOGLE_SHEET_URL = 'GOOGLE_SHEET_URL_HERE';

function submitFeedback(e) {
  e.preventDefault();
  const btn = document.getElementById('submitBtn');
  btn.textContent = 'Submitting...';
  btn.disabled = true;

  const form = document.getElementById('feedbackForm');
  const fd = new FormData(form);
  const payload = {
    topic: 'TOPIC_NAME',
    rating: fd.get('rating'),
    diagrams: fd.get('diagrams'),
    knew_ai: fd.get('knew_ai'),
    vs_ecampus: fd.get('vs_ecampus'),
    best_slide: fd.get('best_slide'),
    comments: fd.get('comments')
  };

  if (!GOOGLE_SHEET_URL || GOOGLE_SHEET_URL === 'GOOGLE_SHEET_URL_HERE') {
    alert('Feedback recorded locally (Google Sheet URL not configured yet):\n\n' + JSON.stringify(payload, null, 2));
    document.getElementById('feedbackForm').style.display = 'none';
    document.getElementById('feedback-success').style.display = 'block';
    return;
  }

  fetch(GOOGLE_SHEET_URL, {
    method: 'POST',
    mode: 'no-cors',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  })
  .then(() => {
    document.getElementById('feedbackForm').style.display = 'none';
    document.getElementById('feedback-success').style.display = 'block';
  })
  .catch(() => {
    document.getElementById('feedback-error').style.display = 'block';
    btn.textContent = 'Submit Feedback';
    btn.disabled = false;
  });
}
```

## Important Notes

- Use `mode: 'no-cors'` in the fetch call — Google Apps Script does not return proper CORS headers
- The `topic` field is hardcoded per slide deck so responses can be filtered by topic in the spreadsheet
- If the user already has a Google Sheet URL from a previous deck, reuse it — all topics go to the same sheet
- The form works without the Google Sheet URL (falls back to a local alert) so the user can set it up later
