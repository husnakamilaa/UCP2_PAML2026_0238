const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware")
const katalogController = require("../controllers/katalogController")

router.post("/", authMiddleware, katalogController.createKatalog);
router.get("/", authMiddleware, katalogController.getAllKatalog);
router.get("/search", authMiddleware, katalogController.searchKatalog);
router.get("/:id", authMiddleware, katalogController.getKatalogById);
router.put("/:id", authMiddleware, katalogController.updateKatalog);
router.delete("/:id", authMiddleware, katalogController.deleteKatalog);

module.exports = router;