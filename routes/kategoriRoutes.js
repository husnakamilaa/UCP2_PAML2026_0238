const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware")
const kategoriController = require("../controllers/kategoriController")

router.post("/", authMiddleware, kategoriController.createKategori);
router.get("/", authMiddleware, kategoriController.getAllKategori);
router.delete("/:id", authMiddleware, kategoriController.deleteKategori);

module.exports = router;