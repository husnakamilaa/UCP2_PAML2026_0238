const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware")
const customerController = require("../controllers/customerController")

router.get("/", authMiddleware, cutomerController.getAllKatalogCustomer);
router.get("/search", authMiddleware, cutomerController.searchKatalogCustomer);
router.get("/:id", authMiddleware, cutomerController.searchKatalogCustomerById);

module.exports = router;