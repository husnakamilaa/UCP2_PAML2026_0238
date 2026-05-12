const db = require("../config/database")

// create
exports.createKategori = (req, res) => {
  const { merk } = req.body;

  const sql = `
    INSERT INTO kategori (merk)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [merk], (err) => {
    if (err) {
      return res.status(500).json({
        message: "Gagal menambah kategori",
        error: err.message
      });
    }

    res.status(201).json({
      message: "Kategori berhasil ditambahkan"
    });
  });
};

// read all
exports.getAllKategori = (req, res) => {
  const sql = "SELECT * FROM kategori";

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json(err);
    }
    res.json(results);
  });
};

// delete
exports.deleteKategori = (req, res) => {
  const { id } = req.params;

  const sql = "DELETE FROM kategori WHERE id = ?";
  db.query(sql, [id], (err) => {
    if (err) return res.status(500).json(err);

    res.json({ message: "Data kategori berhasil dihapus" });
  });
};
