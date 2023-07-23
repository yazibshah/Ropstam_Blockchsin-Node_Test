// routes/cars.js
const express = require('express');
const router = express.Router();
const Car = require('../models/Car');

// Create a car
router.post('/cars', async (req, res) => {
  try {
    const { category, color, model, make, registrationNo } = req.body;

    // Data validation (optional)
    // You can add additional checks to validate the input data.

    const newCar = new Car({
      category,
      color,
      model,
      make,
      registrationNo,
    });
    await newCar.save();

    return res.status(201).json({ message: 'Car created successfully' });
  } catch (error) {
    console.error('Error creating a car:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Read all cars
router.get('/cars', async (req, res) => {
  try {
    const cars = await Car.find();
    return res.status(200).json(cars);
  } catch (error) {
    console.error('Error fetching cars:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Update a car
router.put('/cars/:id', async (req, res) => {
  try {
    const { category, color, model, make, registrationNo } = req.body;
    const carId = req.params.id;

    // Data validation (optional)
    // You can add additional checks to validate the input data.

    await Car.findByIdAndUpdate(carId, {
      category,
      color,
      model,
      make,
      registrationNo,
    });

    return res.status(200).json({ message: 'Car updated successfully' });
  } catch (error) {
    console.error('Error updating a car:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Delete a car
router.delete('/cars/:id', async (req, res) => {
  try {
    const carId = req.params.id;
    await Car.findByIdAndDelete(carId);

    return res.status(200).json({ message: 'Car deleted successfully' });
  } catch (error) {
    console.error('Error deleting a car:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
