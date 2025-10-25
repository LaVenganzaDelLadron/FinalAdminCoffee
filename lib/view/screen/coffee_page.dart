import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/auth_controller.dart';
import '../controller/coffee_controller.dart';

class AddCoffeePage extends StatefulWidget {
  const AddCoffeePage({super.key});

  @override
  State<AddCoffeePage> createState() => _AddCoffeePageState();
}

class _AddCoffeePageState extends State<AddCoffeePage> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  final coffeeController = Get.put(CoffeeController());
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  String selectedCategory = "Signature";
  bool isActive = true;

  final List<String> categories = [
    "Signature",
    "Classics",
    "Cold Brew",
    "Seasonal",
    "Reserve",
  ];

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    } else {
      Get.snackbar("No Image", "You didn’t select any image.",
          backgroundColor: Colors.brown.shade100,
          colorText: Colors.brown.shade900);
    }
  }

  Future<void> _addCoffee() async {
    final name = nameController.text.trim();
    final desc = descController.text.trim();
    final price = priceController.text.trim();

    if (name.isEmpty || desc.isEmpty || price.isEmpty || _imageFile == null) {
      Get.snackbar("Error", "Please fill all fields and upload an image.",
          backgroundColor: Colors.brown.shade100,
          colorText: Colors.brown.shade900);
      return;
    }

    final adminId =
        AuthController.instance.currentAdmin.value?.id.toString() ?? "0";

    await coffeeController.AddCoffee(
      name,
      desc,
      double.tryParse(price) ?? 0,
      selectedCategory,
      adminId,
      _imageFile!, // Pass the picked File here
    );

    Get.snackbar("Success", "Coffee added successfully! ☕",
        backgroundColor: Colors.brown.shade100,
        colorText: Colors.brown.shade900);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF3E2723)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Add Coffee",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Craft your next bestseller — smooth, rich, and irresistible.",
                    style: TextStyle(color: Colors.brown, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // Coffee Preview
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        image: DecorationImage(
                          image: _imageFile == null
                              ? const AssetImage(
                              'assets/placeholder_coffee.jpg')
                              : FileImage(_imageFile!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.green.shade700
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                "Tap to upload image",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Form container
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Coffee Name"),
                        _buildTextField(nameController, "Casa Latte"),
                        const SizedBox(height: 20),

                        _buildLabel("Description"),
                        _buildTextField(descController,
                            "Silky espresso with oat milk and cardamom sugar.",
                            maxLines: 3),
                        const SizedBox(height: 20),

                        _buildLabel("Price"),
                        _buildTextField(priceController, "5.80",
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 20),

                        _buildLabel("Category"),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          items: categories
                              .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedCategory = val!),
                          decoration: _fieldDecoration(),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Checkbox(
                              value: isActive,
                              onChanged: (val) =>
                                  setState(() => isActive = val ?? false),
                              activeColor: Colors.brown,
                            ),
                            const Text("Active on menu",
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.brown,
                                side: const BorderSide(color: Colors.brown),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 28),
                              ),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton.icon(
                              onPressed: _addCoffee,
                              icon: const Icon(Icons.coffee, size: 20),
                              label: const Text("Add Coffee"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E2723),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 28),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.brown,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _fieldDecoration(hintText: hint),
    );
  }

  InputDecoration _fieldDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFFFFBF5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.brown.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF6D4C41), width: 1.5),
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    );
  }
}
