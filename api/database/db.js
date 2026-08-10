const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const path = require('path');

const dbPath = path.join(__dirname, 'pwp_database.sqlite');
const schemaPath = path.join(__dirname, 'schema.sql');
const seedPath = path.join(__dirname, 'seed.sql');

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error connecting to SQLite database:', err.message);
  } else {
    console.log('Connected to SQLite database.');
    initDatabase();
  }
});

function initDatabase() {
  const schemaSql = fs.readFileSync(schemaPath, 'utf8');
  
  db.exec(schemaSql, (err) => {
    if (err) {
      console.error('Error executing schema:', err.message);
      return;
    }
    
    // Check if initial data exists, if not run seed
    db.get('SELECT COUNT(*) AS count FROM Departments', [], (err, row) => {
      if (err) {
        console.error('Error checking database status:', err.message);
        return;
      }
      
      if (row.count === 0) {
        const seedSql = fs.readFileSync(seedPath, 'utf8');
        db.exec(seedSql, (err) => {
          if (err) {
            console.error('Error executing seed data:', err.message);
          } else {
            console.log('Master seed data inserted successfully.');
          }
        });
      }
    });
  });
}

module.exports = db;