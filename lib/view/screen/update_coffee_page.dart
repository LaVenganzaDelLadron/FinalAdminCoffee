import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/coffee.dart';
import '../controller/auth_controller.dart';
import '../controller/coffee_controller.dart';
import '../controller/category_controller.dart';

class UpdateCoffeePage extends StatefulWidget {
  final Coffee coffee;

  const UpdateCoffeePage({super.key, required this.coffee});

  @override
  State<UpdateCoffeePage> createState() => _UpdateCoffeePageState();
}

class _UpdateCoffeePageState extends State<UpdateCoffeePage> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  final coffeeController = Get.put(CoffeeController());
  final categoryController = Get.put(CategoryController());
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  bool isActive = true;
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    print("🟤 [DEBUG] UpdateCoffeePage.initState() called");
    try {
      nameController.text = widget.coffee.name;
      descController.text = widget.coffee.description;
      priceController.text = widget.coffee.price.toString();
      selectedCategoryId = widget.coffee.category;
      isActive = true;
      print("✅ [DEBUG] Pre-filled coffee data loaded successfully");
    } catch (e) {
      print("❌ [ERROR] Failed to prefill coffee data: $e");
    }
    categoryController.fetchCategories();
  }

  Future<void> _pickImage() async {
    print("🟤 [DEBUG] Image picker triggered");
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
        });
        print("✅ [DEBUG] Image selected: ${picked.path}");
      } else {
        print("⚠️ [DEBUG] No image selected");
        Get.snackbar("No Image", "You didn’t select any image.",
            backgroundColor: Colors.brown.shade100,
            colorText: Colors.brown.shade900);
      }
    } catch (e) {
      print("❌ [ERROR] Image picker failed: $e");
    }
  }

  Future<void> _updateCoffee() async {
    print("🟤 [DEBUG] UpdateCoffee triggered");
    final name = nameController.text.trim();
    final desc = descController.text.trim();
    final price = priceController.text.trim();

    if (name.isEmpty || desc.isEmpty || price.isEmpty || selectedCategoryId == null) {
      print("⚠️ [DEBUG] Missing required fields");
      Get.snackbar("Error", "Please fill all fields.",
          backgroundColor: Colors.brown.shade100,
          colorText: Colors.brown.shade900);
      return;
    }

    final adminId = AuthController.instance.currentAdmin.value?.id.toString() ?? "0";
    print("🟤 [DEBUG] Admin ID: $adminId");

    try {
      print("📤 [DEBUG] Sending updateCoffee request...");
      await coffeeController.updateCoffee(
        widget.coffee.id.toString(),
        name,
        desc,
        double.tryParse(price) ?? 0,
        selectedCategoryId!,
        adminId,
        _imageFile ?? File(''),
      );
      print("✅ [DEBUG] Coffee updated successfully");

      Get.snackbar("Updated", "Coffee updated successfully! ☕",
          backgroundColor: Colors.brown.shade100,
          colorText: Colors.brown.shade900);
      Navigator.pop(context);
    } catch (e) {
      print("❌ [ERROR] _updateCoffee failed: $e");
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🟤 [DEBUG] Building UpdateCoffeePage UI");
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
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF3E2723)),
                        onPressed: () {
                          print("🟤 [DEBUG] Back button pressed");
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Update Coffee",
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
                    "Modify your brew details below ☕",
                    style: TextStyle(color: Colors.brown, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // ☕ Image
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
                          image: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (widget.coffee.image != null &&
                              widget.coffee.image!.isNotEmpty
                              ? MemoryImage(widget.coffee.image!)
                              : const AssetImage('assets/placeholder_coffee.jpg'))
                          as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                "Tap to change image",
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

                  // 🧾 Form
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
                        _buildTextField(nameController, "Latte Deluxe"),
                        const SizedBox(height: 20),

                        _buildLabel("Description"),
                        _buildTextField(descController,
                            "Rich espresso with smooth oat milk.",
                            maxLines: 3),
                        const SizedBox(height: 20),

                        _buildLabel("Price"),
                        _buildTextField(priceController, "4.50",
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 20),

                        _buildLabel("Category"),
                        Obx(() {
                          final categories = categoryController.categories;
                          print("🟤 [DEBUG] Categories loaded: ${categories.length}");
                          if (categories.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "No categories available.",
                                style: TextStyle(color: Colors.brown),
                              ),
                            );
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedCategoryId,
                            items: categories
                                .map((cat) => DropdownMenuItem<String>(
                              value: cat.id.toString(),
                              child: Text(cat.name),
                            ))
                                .toList(),
                            onChanged: (val) {
                              print("🟤 [DEBUG] Category changed: $val");
                              setState(() => selectedCategoryId = val);
                            },
                            decoration: _fieldDecoration(),
                            hint: const Text("Select Category"),
                          );
                        }),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Checkbox(
                              value: isActive,
                              onChanged: (val) {
                                print("🟤 [DEBUG] isActive changed: $val");
                                setState(() => isActive = val ?? false);
                              },
                              activeColor: Colors.brown,
                            ),
                            const Text("Active on menu",
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                print("🟤 [DEBUG] Cancel button pressed");
                                Navigator.pop(context);
                              },
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
                              onPressed: _updateCoffee,
                              icon: const Icon(Icons.save, size: 20),
                              label: const Text("Update Coffee"),
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

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.brown,
      fontWeight: FontWeight.w600,
    ),
  );

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
