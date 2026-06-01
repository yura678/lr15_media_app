import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_storage_service.dart';
import '../services/permission_service.dart';
import 'image_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();
  final ImageStorageService _storage = ImageStorageService();

  List<String> _imagePaths = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final images = await _storage.loadSavedImages();
    if (!mounted) return;
    setState(() => _imagePaths = images);
  }

  Future<void> _pickImage(ImageSource source) async {
    final granted = source == ImageSource.camera
        ? await _permissionService.requestCameraPermission()
        : await _permissionService.requestGalleryPermission();

    if (!granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Доступ заборонено')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        final savedPath = await _storage.saveImage(image.path);
        if (!mounted) return;
        setState(() => _imagePaths = [..._imagePaths, savedPath]);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Камера'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Галерея'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteImage(String path) async {
    await _storage.deleteImage(path);
    setState(() => _imagePaths = _imagePaths.where((e) => e != path).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _showSourceSheet,
        child: const Icon(Icons.add_a_photo),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _imagePaths.isEmpty
              ? const Center(child: Text('Немає фото. Натисніть +'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: _imagePaths.length,
                  itemBuilder: (context, index) {
                    final path = _imagePaths[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImageDetailScreen(imagePath: path),
                        ),
                      ),
                      onLongPress: () => _deleteImage(path),
                      child: Hero(
                        tag: path,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(path), fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
