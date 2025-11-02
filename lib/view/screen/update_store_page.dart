import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/store.dart';
import '../controller/store_controller.dart';

class UpdateStorePage extends StatefulWidget {
  final Store store;

  const UpdateStorePage({super.key, required this.store});

  @override
  State<UpdateStorePage> createState() => _UpdateStorePageState();
}

class _UpdateStorePageState extends State<UpdateStorePage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final prepTimeController = TextEditingController();
  String status = "open";

  final storeController = Get.put(StoreController());

  @override
  void initState() {
    super.initState();
    // Pre-fill text fields
    nameController.text = widget.store.name ?? "";
    addressController.text = widget.store.address ?? "";
    prepTimeController.text = widget.store.prep_time_minutes ?? "";
    status = widget.store.status ?? "open";
  }

  Future<void> _updateStore() async {
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final prepTime = prepTimeController.text.trim();

    if (name.isEmpty || address.isEmpty || prepTime.isEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please fill in all fields.",
        backgroundColor: Colors.brown.shade100,
        colorText: Colors.brown.shade900,
      );
      return;
    }

    await storeController.updateStore(
      widget.store.id.toString(),
      name,
      address,
      prepTime,
      status,
    );

    Get.snackbar(
      "Success",
      "Store updated successfully! ✅",
      backgroundColor: Colors.brown.shade100,
      colorText: Colors.brown.shade900,
    );

    Navigator.pop(context, true);
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
                  // 🔙 Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF3E2723)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Update Store",
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
                    "Modify your store information below.",
                    style: TextStyle(color: Colors.brown, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // 🧾 Form Section
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
                        _buildLabel("Store Name"),
                        _buildTextField(nameController, "e.g. Café Delight"),
                        const SizedBox(height: 20),

                        _buildLabel("Address"),
                        _buildTextField(
                          addressController,
                          "e.g. 123 Brew Street, Makati City",
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("Preparation Time (minutes)"),
                        _buildTextField(prepTimeController, "e.g. 10",
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 20),

                        _buildLabel("Status"),
                        DropdownButtonFormField<String>(
                          value: status,
                          items: const [
                            DropdownMenuItem(
                              value: "open",
                              child: Text("🟢 Open"),
                            ),
                            DropdownMenuItem(
                              value: "closed",
                              child: Text("🔴 Closed"),
                            ),
                          ],
                          onChanged: (val) => setState(() => status = val!),
                          decoration: _fieldDecoration(),
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
                              onPressed: _updateStore,
                              icon: const Icon(Icons.save_rounded, size: 20),
                              label: const Text("Save Changes"),
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
