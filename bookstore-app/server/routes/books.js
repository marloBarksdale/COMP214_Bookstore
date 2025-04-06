const express = require('express');
const router = express.Router();
const { getConnection } = require('../db');

// GET all books
router.get('/', async (req, res) => {
  try {
    const conn = await getConnection();
    const result = await conn.execute(
      `SELECT ISBN, Title, Category, Retail FROM Books ORDER BY Title`
    );
    await conn.close();
    res.json(result.rows.map(row => ({
      ISBN: row[0],
      Title: row[1],
      Category: row[2],
      Retail: row[3]
    })));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST a new book
router.post('/', async (req, res) => {
  const { ISBN, Title, PubDate, PubID, Cost, Retail, Discount, Category } = req.body;
  try {
    const conn = await getConnection();
    await conn.execute(
      `INSERT INTO Books (ISBN, Title, PubDate, PubID, Cost, Retail, Discount, Category)
       VALUES (:ISBN, :Title, TO_DATE(:PubDate, 'YYYY-MM-DD'), :PubID, :Cost, :Retail, :Discount, :Category)`,
      [ISBN, Title, PubDate, PubID, Cost, Retail, Discount, Category],
      { autoCommit: true }
    );
    await conn.close();
    res.status(201).json({ message: 'Book added successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
