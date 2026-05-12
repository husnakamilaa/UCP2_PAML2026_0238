const db = require("../config/database");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.register = async (req, res) => {
  const { nama, email, password } = req.body;

  if (!nama || !email || !password) {
    return res.status(400).json({ 
      message: "Nama, email, dan password wajib diisi",
      code: "EMPTY_FIELDS" 
    });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    const sql = "INSERT INTO users (nama, email, password, role) VALUES (?, ?, ?, ?)";
    const defaultRole = 'customer';

    db.query(sql, [nama, email, hashedPassword, defaultRole], (err, result) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(400).json({ 
            message: "Email sudah terdaftar",
            code: "DUPLICATE_EMAIL" 
          });
        }
        return res.status(500).json({ 
          message: "Terjadi kesalahan pada database",
          code: "DATABASE_ERROR" 
        });
      }

      res.status(201).json({ 
        message: "Registrasi berhasil sebagai customer!",
        userId: result.insertId 
      });
    });
  } catch (error) {
    res.status(500).json({ 
      message: "Gagal memproses pendaftaran",
      code: "SERVER_ERROR" 
    });
  }
};

exports.login = (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      message: "Email dan password wajib diisi",
      code: "EMPTY_FIELD"
    });
  }

  const sql = "SELECT * FROM users WHERE email = ?";
  db.query(sql, [email], (err, results) => {
    if (err) {
      return res.sstatus(500).json({
        message: "Server error",
        code: "SERVER_ERROR"
      });
    }

    if (results.length === 0) {
      return res.status(404).json({
        message: "User tidak ditemukan",
      });
    }

    const user = results[0];

    bcrypt.compare(password, user.password, (err, isMatch) => {
      if (err || !isMatch) {
          return res.status(401).json({
              message: "Password salah",
              code: "WRONG_PASSWORD"
          });
      }
      const token = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES }
      );

      res.status(200).json({
        message: "Login berhasil",
        token: token,
        user: {
        id: user.id,
        nama: user.nama,
        email: user.email,
        role: user.role
  }
      });

    });
  });
};