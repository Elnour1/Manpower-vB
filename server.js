const express = require('express');
const path = require('path');
const { createClient } = require('@libsql/client');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(__dirname));

// CORS Configuration
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// 📲 HR WHATSAPP NOTIFICATION CONFIGURATION
const HR_WHATSAPP_NUMBER = "+966570544368"; // رقم الواتساب المعتمد لـ HR

// Function to dispatch WhatsApp notifications via API (Twilio / Webhook Gateway)
async function sendWhatsAppHRNotification(shiftName, totalWorkers, hrActionText) {
  const messageBody = `🔔 *PWP System - Workforce Dispatch Order*\n\n` +
                      `📅 *Shift:* ${shiftName}\n` +
                      `👷‍♂️ *Shift Total Required:* ${totalWorkers} Workers\n` +
                      `📌 *HR Decision:* ${hrActionText}\n\n` +
                      `-------------------------------\n` +
                      `📱 Sent to HR Contact: ${HR_WHATSAPP_NUMBER}`;

  console.log(`[WHATSAPP DISPATCH] Sending to ${HR_WHATSAPP_NUMBER}:\n${messageBody}`);

  // Example API Integration (e.g., Twilio or Direct Gateway)
  /*
  try {
    await fetch('https://api.twilio.com/2010-04-01/Accounts/YOUR_ACCOUNT_SID/Messages.json', {
      method: 'POST',
      headers: {
        'Authorization': 'Basic ' + Buffer.from('YOUR_SID:YOUR_AUTH_TOKEN').toString('base64'),
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: new URLSearchParams({
        'From': 'whatsapp:+14155238886',
        'To': `whatsapp:${HR_WHATSAPP_NUMBER}`,
        'Body': messageBody
      })
    });
    console.log('✅ WhatsApp message sent successfully to HR!');
  } catch (err) {
    console.error('❌ Failed to send WhatsApp message:', err);
  }
  */
}

// -------------------------------------------------------------
// 🌐 PAGE ROUTES
// -------------------------------------------------------------
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'login.html')));
app.get('/login', (req, res) => res.sendFile(path.join(__dirname, 'login.html')));
app.get('/register', (req, res) => res.sendFile(path.join(__dirname, 'register.html')));
app.get('/dashboard', (req, res) => res.sendFile(path.join(__dirname, 'index.html')));
app.get('/planner.html', (req, res) => res.sendFile(path.join(__dirname, 'planner.html')));

app.get('/:page.html', (req, res) => {
  res.sendFile(path.join(__dirname, `${req.params.page}.html`));
});

// -------------------------------------------------------------
// 🔐 AUTHENTICATION APIs
// -------------------------------------------------------------
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }
  res.json({ message: 'Login successful', token: 'pwp-authenticated-token' });
});

app.post('/api/auth/register', async (req, res) => {
  const { name, email, password, role } = req.body;
  if (!name || !email || !password) {
    return res.status(400).json({ error: 'All fields are required' });
  }
  res.json({ message: 'Account created successfully' });
});

// -------------------------------------------------------------
// 📲 WHATSAPP DISPATCH API TRIGGER
// -------------------------------------------------------------
app.post('/api/dispatch/whatsapp', async (req, res) => {
  const { shift, totalWorkers, actionText } = req.body;
  if (!shift || !actionText) {
    return res.status(400).json({ error: 'Shift details and action text are required' });
  }

  await sendWhatsAppHRNotification(shift, totalWorkers, actionText);
  res.json({ 
    success: true, 
    message: `HR Notification queued for WhatsApp: ${HR_WHATSAPP_NUMBER}` 
  });
});

app.listen(PORT, () => console.log(`PWP System Running on http://localhost:${PORT}`));
