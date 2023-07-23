// routes/metamask.js
const express = require('express');
const router = express.Router();

// MetaMask sign-in endpoint
router.post('/metamask/signin', (req, res) => {
  try {
    const { ethAddress } = req.body;

    // You can add additional checks or logic here to validate the Ethereum address
    // For simplicity, we'll assume the address is valid.

    // Create and send the JWT token for authentication
    const payload = { ethAddress };
    const token = jwt.sign(payload, 'your-secret-key', { expiresIn: '1h' });

    return res.status(200).json({ token });
  } catch (error) {
    console.error('Error with MetaMask sign-in:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
