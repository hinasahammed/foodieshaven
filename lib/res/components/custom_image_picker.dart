import 'package:flutter/material.dart';
import 'package:foodies_haven/viewModel/upload_controller.dart';
import 'package:get/get.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({super.key});

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final pickImageController = Get.put(UploadController());

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
          child: Obx(
            () => CircleAvatar(
              radius: 70,
              backgroundImage:
                  pickImageController.selectedImage.value.path == ''
                      ? const AssetImage('assets/images/person.jpeg')
                      : FileImage(pickImageController.selectedImage.value)
                          as ImageProvider,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            onPressed: pickImageController.pickImage,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
