import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploadWidget extends StatefulWidget {
  final File? imageFile;

  final String? imageUrl;

  final String folderName;

  final double maxSizeInMB;

  final ValueChanged<File?> onChanged;

  final VoidCallback? onRemove;

  const ImageUploadWidget({
    super.key,

    this.imageFile,

    this.imageUrl,

    required this.folderName,

    this.maxSizeInMB = 1,

    required this.onChanged,

    this.onRemove,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,

      imageQuality: 90,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final file = File(picked.path);

      final compressed = await _compressImage(file);

      widget.onChanged(compressed);
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<File> _compressImage(File file) async {
    final size = await file.length();

    if (size <= widget.maxSizeInMB * 1024 * 1024) {
      return file;
    }

    final dir = await getTemporaryDirectory();

    final path =
        '${dir.path}/'
        '${widget.folderName}_'
        '${DateTime.now().millisecondsSinceEpoch}'
        '.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,

      path,

      quality: 70,

      minWidth: 1280,

      minHeight: 1280,

      format: CompressFormat.jpeg,
    );

    if (result == null) {
      return file;
    }

    File compressed = File(result.path);

    // compress kedua jika masih besar

    if (await compressed.length() > widget.maxSizeInMB * 1024 * 1024) {
      final path2 =
          '${dir.path}/'
          '${widget.folderName}_small_'
          '${DateTime.now().millisecondsSinceEpoch}'
          '.jpg';

      final result2 = await FlutterImageCompress.compressAndGetFile(
        compressed.path,

        path2,

        quality: 50,

        minWidth: 1024,

        minHeight: 1024,

        format: CompressFormat.jpeg,
      );

      if (result2 != null) {
        compressed = File(result2.path);
      }
    }

    return compressed;
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,

      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),

                title: const Text("Gallery"),

                onTap: () {
                  Navigator.pop(context);

                  _pickImage(ImageSource.gallery);
                },
              ),

              ListTile(
                leading: const Icon(Icons.camera_alt),

                title: const Text("Camera"),

                onTap: () {
                  Navigator.pop(context);

                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.imageFile != null || widget.imageUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        GestureDetector(
          onTap: hasImage ? null : _showPicker,

          child: Container(
            height: 180,

            width: double.infinity,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Theme.of(context).dividerColor),
            ),

            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : hasImage
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),

                        child: widget.imageFile != null
                            ? Image.file(
                                widget.imageFile!,

                                width: double.infinity,

                                height: 180,

                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                widget.imageUrl!,

                                width: double.infinity,

                                height: 180,

                                fit: BoxFit.cover,

                                errorBuilder: (_, _, _) {
                                  return const Center(
                                    child: Icon(Icons.broken_image),
                                  );
                                },
                              ),
                      ),

                      Positioned(
                        right: 5,

                        top: 5,

                        child: IconButton(
                          onPressed: () {
                            widget.onRemove?.call();
                          },

                          icon: const CircleAvatar(child: Icon(Icons.close)),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(Icons.add_photo_alternate, size: 45),

                        SizedBox(height: 8),

                        Text("Upload Image"),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
