const db = require("../config/database")

// create
exports.createKatalog = (req, res) => {
  const { id_kategori, nama, harga, tahun_produksi, transmisi, capacity, maxspeed, image } = req.body;

  const sql = `
    INSERT INTO katalog (id_kategori, nama, harga, tahun_produksi, transmisi, capacity, maxspeed, image)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [id_kategori, nama, harga, tahun_produksi, transmisi, capacity, maxspeed, image], (err) => {
    if (err) {
      return res.status(500).json({
        message: "Gagal menambah katalog",
        error: err.message
      });
    }

    res.status(201).json({
      message: "Katalog berhasil ditambahkan"
    });
  });
};

// read all
exports.getAllKatalog = (req, res) => {
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
    res.json({
      message: "success",
      data: results
    });
  });
};

// search by nama
exports.searchKatalog = (req, res) => {
  const { nama } = req.query;

  const sql = `
  SELECT
  katalog.*,
  kategori.merk
  FROM katalog
  JOIN kategori
  ON katalog.id_kategori = kategori.id
  WHERE nama LIKE ?
  `;
  db.query(sql, [`%${nama}%`], (err, results) => {
    if (err) {
      return res.status(500).json(err);
    }
    res.json({
      message: "success",
      data: results
    });
  });
};

// get by id
exports.getKatalogById = (req, res) => {
  const { id } = req.params;

  const sql = `
  SELECT
  katalog.*,
  kategori.merk
  FROM katalog
  JOIN kategori
  ON katalog.id_kategori = kategori.id
  WHERE id = ?`;
  db.query(sql, [id], (err, results) => {
    if (err) return res.status(500).json(err);

    if (results.length === 0) {
      return res.status(404).json({
        message: "Katalog tidak ditemukan"
      });
    }

    res.json({
      message: "success",
      data: results[0]
    });
  });
};

// update
exports.updateKatalog = (req, res) => {
  const { id } = req.params;
  const { id_kategori, nama, harga, tahun_produksi, transmisi, capacity, maxspeed, image, } = req.body;

  const sql = `
    UPDATE katalog
    SET id_kategori = ?, nama = ?, harga = ?, tahun_produksi = ?, transmisi = ?, capacity = ?, maxspeed = ?, image = ?
    WHERE id = ?
  `;

  db.query(sql, [id_kategori, nama, harga, tahun_produksi, transmisi, capacity, maxspeed, image, id], (err) => {
    if (err) return res.status(500).json(err);

    res.json({ message: "Data katalog berhasil diupdate" });
  });
};

// delete
exports.deleteKatalog = (req, res) => {
  const { id } = req.params;

  const sql = "DELETE FROM katalog WHERE id = ?";
  db.query(sql, [id], (err) => {
    if (err) return res.status(500).json(err);

    res.json({ message: "Data katalog berhasil dihapus" });
  });
};