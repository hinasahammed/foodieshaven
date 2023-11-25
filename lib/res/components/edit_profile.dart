import 'package:flutter/material.dart';
import 'package:foodies_haven/res/components/custom_image_picker.dart';
import 'package:foodies_haven/res/components/custom_textfield.dart';
import 'package:foodies_haven/viewModel/upload_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  final String userName;
  const EditProfile({super.key, required this.userName, required this.uid});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final uploadController = Get.put(UploadController());

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: Get.width,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Edit your Profile',
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(30),
            const CustomImagePicker(),
            const Gap(20),
            CustomTextfield(
              controller: _name,
              text: widget.userName,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Username is required';
                }

                if (value.length < 3) {
                  return 'Username must be at least 3 characters long';
                }
                return null;
              },
            ),
            const Gap(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
                const Gap(10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      uploadController.updateEditedData(widget.uid, _name.text);
                    }
                  },
                  child: uploadController.loading.value
                      ? CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        )
                      : Text(
                          'Save',
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
