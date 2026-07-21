import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

typedef ImageChanged = void Function(File? file);

class CompressedImagePicker extends StatefulWidget {
  const CompressedImagePicker({
    super.key,
    this.maxSizeInMB = 1,
    this.label = 'Upload Gambar',
    this.onChanged,
    this.initialFile,
    this.enabled = true,
  });

  final double maxSizeInMB;
  final String label;
  final ImageChanged? onChanged;
  final File? initialFile;
  final bool enabled;

  @override
  State<CompressedImagePicker> createState() => _CompressedImagePickerState();
}

class _CompressedImagePickerState extends State<CompressedImagePicker> {
  final ImagePicker _picker = ImagePicker();

  File? _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _image = widget.initialFile;
  }

  Future<void> _showSourcePicker() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.camera);
              },
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Future<void> _pick(ImageSource source) async {
    try {
      setState(() => _loading = true);

      final XFile? result = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );

      if (result == null) {
        setState(() => _loading = false);
        return;
      }

      final compressed = await _compressUntilTarget(File(result.path));

      if (!mounted) return;

      setState(() {
        _image = compressed;
        _loading = false;
      });

      widget.onChanged?.call(compressed);
    } catch (e) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
    }
  }

  Future<File> _compressUntilTarget(File file) async {
    final maxBytes = (widget.maxSizeInMB * 1024 * 1024).round();

    final tempDir = await getTemporaryDirectory();

    File current = file;

    int quality = 90;
    int width = 1920;
    int height = 1920;

    while (await current.length() > maxBytes) {
      final outputPath =
          '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';

      final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
        current.path,
        outputPath,
        quality: quality,
        minWidth: width,
        minHeight: height,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        break;
      }

      current = File(compressed.path);

      quality -= 10;

      if (quality < 30) {
        quality = 60;
        width = (width * 0.8).round();
        height = (height * 0.8).round();
      }

      if (width < 600) {
        break;
      }
    }

    return current;
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });

    widget.onChanged?.call(null);
  }

  String _fileSize(File file) {
    final bytes = file.lengthSync();

    if (bytes >= 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(2)} MB';
    }

    return '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.enabled && !_loading ? _showSourcePicker : null,
          child: Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      const Text('Tap untuk memilih gambar'),
                      const SizedBox(height: 4),
                      Text(
                        'Kamera atau Galeri',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _image!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        if (_image != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ukuran: ${_fileSize(_image!)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              IconButton(
                tooltip: 'Hapus',
                onPressed: _removeImage,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
