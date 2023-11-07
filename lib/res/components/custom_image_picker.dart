import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final void Function(File) onImageSelected;
  const CustomImagePicker({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? image;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
      widget.onImageSelected(image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(.6),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: CircleAvatar(
            radius: 70,
            backgroundImage: image != null
                ? FileImage(image!) as ImageProvider
                : const AssetImage('assets/images/burger_cl2.png'),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            onPressed: _pickImageFromGallery,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
