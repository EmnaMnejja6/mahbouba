import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agriwie/models/product_model.dart'; // Import the Product model
import 'package:agriwie/databases/product_database.dart'; // Import the database helper
import 'package:geolocator/geolocator.dart'; // For location detection
import 'package:permission_handler/permission_handler.dart'; // For location permissions

class SellItemPage extends StatefulWidget {
  final Product? productToEdit; // Optional: Pass a product for editing

  const SellItemPage({super.key, this.productToEdit});

  @override
  State<SellItemPage> createState() => _SellItemPageState();
}

class _SellItemPageState extends State<SellItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String selectedCategory = "seeds";
  List<File> images = [];
  final ImagePicker _picker = ImagePicker();

  final Map<String, String> categories = {
    "seeds": "بذور",
    "tools": "معدات",
    "animal_food": "أعلاف حيوانية",
    "fertilizers": "أسمدة",
    "pesticides": "مبيدات",
    "irrigation": "أدوات الري",
    "animals": "حيوانات",
    "crops": "محاصيل",
    "other": "أخرى",
    "animalproduct": "منتح حيواني"
  };

  bool _isDetectingLocation = false;

  @override
  void initState() {
    super.initState();
    // If a product is passed for editing, pre-fill the fields
    if (widget.productToEdit != null) {
      nameController.text = widget.productToEdit!.name;
      priceController.text = widget.productToEdit!.price.toString();
      stockController.text = widget.productToEdit!.stock.toString();
      descriptionController.text = widget.productToEdit!.description;
      unitController.text = widget.productToEdit!.unit;
      phoneController.text = widget.productToEdit!.phone;
      locationController.text = widget.productToEdit!.location;
      selectedCategory = widget.productToEdit!.category;
      images = widget.productToEdit!.imagePaths.map((path) => File(path)).toList();
    }
  }

  Future<void> pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        images.addAll(selectedImages.map((img) => File(img.path)).toList());
        if (images.length > 5) {
          images = images.sublist(0, 5);
        }
      });
    }
  }

  Future<void> pickCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        if (images.length < 5) {
          images.add(File(image.path));
        }
      });
    }
  }

  Future<void> _detectLocation() async {
    setState(() {
      _isDetectingLocation = true;
    });
    try {
      var status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        // In a real app, you would use geocoding to convert lat/long to a readable address.
        // For simplicity, we'll just put a placeholder or coordinates.
        // Example with geocoding (requires another package like 'geocoding'):
        // List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        // if (placemarks.isNotEmpty) {
        //   locationController.text = "${placemarks.first.locality}, ${placemarks.first.country}";
        // } else {
        //   locationController.text = "Lat: ${position.latitude.toStringAsFixed(2)}, Lon: ${position.longitude.toStringAsFixed(2)}";
        // }
        locationController.text = "تم الكشف عن الموقع (الرجاء التعديل إن لزم الأمر)"; // Detected location placeholder
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم رفض إذن الموقع. لا يمكن الكشف التلقائي."),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("تم رفض إذن الموقع بشكل دائم. يرجى تمكينه من الإعدادات."),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: "الإعدادات",
              onPressed: () => openAppSettings(),
            ),
          ),
        );
      }
    } catch (e) {
      print("Error detecting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء الكشف عن الموقع: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isDetectingLocation = false;
      });
    }
  }


  Future<void> saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("الرجاء إضافة صورة واحدة على الأقل"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final Product newOrUpdatedProduct = Product(
        id: widget.productToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        category: selectedCategory,
        price: double.parse(priceController.text),
        stock: int.parse(stockController.text),
        unit: unitController.text,
        description: descriptionController.text.isEmpty ? "لا يوجد وصف" : descriptionController.text,
        phone: phoneController.text,
        location: locationController.text,
        imagePaths: images.map((e) => e.path).toList(),
        seller: "مستخدم", // This could be dynamic in a real app
        date: DateTime.now().toIso8601String(),
        featured: widget.productToEdit?.featured ?? false,
      );

      if (widget.productToEdit == null) {
        await ProductDatabase.instance.create(newOrUpdatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text("تم نشر المنتج بنجاح!"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        await ProductDatabase.instance.update(newOrUpdatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text("تم تحديث المنتج بنجاح!"),
              ],
            ),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
      Navigator.pop(context, true); // Pop with true to indicate a successful save/update
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.productToEdit == null ? "بيع منتج" : "تعديل منتج",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "أضف صور واضحة ومعلومات دقيقة لزيادة فرص البيع",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.right, // Align text to the right for Arabic
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Upload Images
            const Text(
              "صور المنتج *",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),
            Container(
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: images.isEmpty
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate,
                      size: 50, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    "أضف حتى 5 صور",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickImages,
                        icon: const Icon(Icons.photo_library, size: 20),
                        label: const Text("المعرض"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: pickCamera,
                        icon: const Icon(Icons.camera_alt, size: 20),
                        label: const Text("الكاميرا"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  : Stack(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    itemCount: images.length + (images.length < 5 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == images.length) {
                        return GestureDetector(
                          onTap: pickImages,
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 2),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[50],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, size: 40,
                                    color: Colors.grey[400]),
                                Text(
                                  "إضافة",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Stack(
                        children: [
                          Container(
                            width: 120,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          if (index == 0)
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "الرئيسية",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Product Name
            TextFormField(
              controller: nameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: "اسم المنتج *",
                hintText: "مثال: بذور طماطم عالية الجودة",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.inventory),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الرجاء إدخال اسم المنتج";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: "الفئة *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.category),
              ),
              items: categories.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(entry.value),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Price and Stock
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: stockController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "الكمية المتوفرة *",
                      hintText: "100",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.inventory_2),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "أدخل الكمية";
                      }
                      if (int.tryParse(value) == null) {
                        return "رقم غير صحيح";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: priceController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "السعر (د.ت) *",
                      hintText: "25.5",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.money),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "أدخل السعر";
                      }
                      if (double.tryParse(value) == null) {
                        return "رقم غير صحيح";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Unit
            TextFormField(
              controller: unitController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: "الوحدة *",
                hintText: "مثال: كيس 50 بذرة، كيلوغرام، قطعة...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.straighten),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "الرجاء تحديد الوحدة";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description (No longer required)
            TextFormField(
              controller: descriptionController,
              textAlign: TextAlign.right,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "الوصف (اختياري)",
                hintText: "اكتب وصفاً تفصيلياً للمنتج، مميزاته، وطريقة الاستخدام...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              // Validator removed, description is optional now
            ),

            const SizedBox(height: 20),

            // Contact Information
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.contact_phone, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      const Text(
                        "معلومات الاتصال",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "رقم الهاتف *",
                      hintText: "مثال: 20123456",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال رقم الهاتف";
                      }
                      if (value.length < 8) {
                        return "رقم هاتف غير صحيح";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Location field with auto-detection
                  TextFormField(
                    controller: locationController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: "الموقع *",
                      hintText: "مثال: سوسة، القيروان، صفاقس...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: IconButton(
                        icon: _isDetectingLocation
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        )
                            : const Icon(Icons.location_on),
                        onPressed: _isDetectingLocation ? null : _detectLocation,
                        tooltip: "الكشف التلقائي عن الموقع",
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال الموقع";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Publish Button
            ElevatedButton(
              onPressed: saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    widget.productToEdit == null ? "نشر المنتج" : "تحديث المنتج",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Cancel Button
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false); // Pop with false to indicate no change
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "إلغاء",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    unitController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }
}