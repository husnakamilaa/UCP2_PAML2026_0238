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

// search by nama
exports.searchKatalogCustomer = (req, res) => {
  const { nama } = req.query;

  const sql = `
  SELECT
  katalog.*
  kategori.merk
  FROM katalog
  JOIN kategori
  ON katalog.id_kategori = kategori.id
  WHERE katalog.nama LIKE ?
  `;
  db.query(sql, [`%${nama}%`], (err, results) => {
    if (err) {
      return res.status(500).json(err);
    }
    res.json(results);
  });
};

// get by id
exports.getKatalogCustomerById = (req, res) => {
  const { id } = req.params;

  const sql = `
  SELECT
  katalog.*
  kategori.merk
  FROM katalog
  JOIN kategori
  ON katalog.id_kategori = kategori.id
  WHERE katalog.id = ?
  `;
  db.query(sql, [id], (err, results) => {
    if (err) return res.status(500).json(err);

    if (results.length === 0) {
      return res.status(404).json({
        message: "Katalog tidak ditemukan"
      });
    }

    res.json(results[0]);
  });
};