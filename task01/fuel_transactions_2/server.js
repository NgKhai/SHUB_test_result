const express = require('express');
const multer = require('multer');
const xlsx = require('xlsx');
const moment = require('moment');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

app.use(bodyParser.json());

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });

// In-memory storage for parsed transaction data
let transactionsData = [];

// Helper function to parse only "Giờ" and "Thành tiền" from the uploaded Excel file
const parseExcelFile = (filePath) => {
  const workbook = xlsx.readFile(filePath);
  const sheet = workbook.Sheets[workbook.SheetNames[0]];
  const data = xlsx.utils.sheet_to_json(sheet, { header: 1 });
  
  return data
    .slice(1)  // Skip header row
    .map(row => ({
      time: row[2],  // Assuming "Giờ" is the 3rd column (index 2)
      totalAmount: parseFloat(row[8]?.toString().replace(/,/g, '')) || 0  // Assuming "Thành tiền" is the 9th column (index 8)
    }))
    .filter(row => row.time && row.totalAmount); // Filter rows with valid "Giờ" and "Thành tiền"
};

// Endpoint to upload the Excel file
app.post('/upload', upload.single('file'), (req, res) => {
  try {
    transactionsData = parseExcelFile(req.file.path);
    res.status(200).json({ message: 'File uploaded and data parsed successfully.' });
  } catch (error) {
    res.status(500).json({ message: 'Error parsing file.', error: error.message });
  }
});

// Endpoint to query transactions within a time range
app.get('/transactions', (req, res) => {
  const { startTime, endTime } = req.query;

  if (!startTime || !endTime) {
    return res.status(400).json({ error: 'Start and end times are required.' });
  }

  try {
    // Parse the start and end times
    const start = moment(startTime, "HH:mm:ss");
    const end = moment(endTime, "HH:mm:ss");

    // Filter transactions within the time range
    const filteredTransactions = transactionsData.filter(transaction => {
      const transactionTime = moment(transaction.time, "HH:mm:ss");
      return transactionTime.isBetween(start, end, null, '[]');
    });

    // Calculate the total amount
    const totalAmount = filteredTransactions.reduce((sum, transaction) => sum + transaction.totalAmount, 0);

    res.json({ totalAmount });
  } catch (error) {
    res.status(500).json({ error: 'Error processing query' });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
