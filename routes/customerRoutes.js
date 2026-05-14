const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/authMiddleware")
const customerController = require("../controllers/customerController")

router.get("/", authMiddleware, customerController.getAllKatalogCustomer);
router.get("/search", authMiddleware, customerController.searchKatalogCustomer);
router.get("/:id", authMiddleware, customerController.getKatalogCustomerById);

module.exports = router;