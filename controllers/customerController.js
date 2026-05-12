const db = require("../config/database")

exports.getKatalogCustomer = (req, res) => {

  const sql = `
    SELECT
      katalog.*,
      kategori.merk
    FROM katalog
    JOIN kategori
      ON katalog.id_kategori = kategori.id
  `;

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json(err);
    }

    res.json(results);
  });
};

exports.searchKatalogCustomer = (req, res) => {
  const { nama } = req.query;

  const sql = "SELECT * FROM katalog WHERE nama LIKE ?";
  db.query(sql, [`%${nama}%`], (err, results) => {
    if (err) {
      return res.status(500).json(err);
    }
    res.json(results);
  });
};