const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware")
const kategoriController = require("../controllers/kategoriController")

router.post("/", authMiddleware, kategoriController.createKatalog);
router.get("/", authMiddleware, kategoriController.getAllKatalog);
router.delete("/:id", authMiddleware, kategoriController.deleteKatalog);

module.exports = router;