require("dotenv").config();

const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/authRoutes");
const katalogRoutes = require("./routes/katalogRoutes");
const customerRoutes = require("./routes/customerRoutes");
const kategoriRoutes = require("./routes/kategoriRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ message: "API DriveEase running" });
});

app.use("/api/auth", authRoutes);
app.use("/api/katalog", katalogRoutes);
app.use("/api/katalog/customer", customerRoutes);
app.use("/api/kategori", kategoriRoutes);

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});