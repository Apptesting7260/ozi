import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../../save address/provider/saved_address_provider.dart';
import '../provider/edit_user_address_provider.dart';

class EditUserAddressScreen extends StatefulWidget {
  const EditUserAddressScreen({super.key});

  @override
  State<EditUserAddressScreen> createState() =>
      _EditUserAddressScreenState();
}

class _EditUserAddressScreenState extends State<EditUserAddressScreen> {
  @override
  void initState() {
    super.initState();

    final savedProvider = context.read<SavedAddressProvider>();
    final editProvider = context.read<EditUserAddressProvider>();

    editProvider.init(savedProvider.editingAddress);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EditUserAddressProvider>();

    if (!provider.initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "Edit Address"),
          hBox(10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  hBox(10),

                  CustomTextFormField(
                    controller: provider.streetController,
                    label: "Street Address",
                    borderRadius: 14,
                  ),
                  const SizedBox(height: 15),

                  CustomTextFormField(
                    controller: provider.apartmentController,
                    label: "Apartment, Suite, etc.",
                    borderRadius: 14,
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: provider.cityController,
                          label: "City",
                          borderRadius: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          controller: provider.zipController,
                          label: "ZIP Code",
                          textInputType: TextInputType.number,
                          borderRadius: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      _type(
                        "Home",
                        ImageConstants.home2,
                        provider.selectedType == 0,
                            () => provider.updateType(0),
                      ),
                      const SizedBox(width: 12),
                      _type(
                        "Work",
                        ImageConstants.work,
                        provider.selectedType == 1,
                            () => provider.updateType(1),
                      ),
                      const SizedBox(width: 12),
                      _type(
                        "Other",
                        ImageConstants.location,
                        provider.selectedType == 2,
                            () => provider.updateType(2),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  CustomButton(
                    text: provider.isLoading ? "Saving..." : "Save Address",
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                      final success = await provider.updateAddress(context);

                      if (success && context.mounted) {
                        // Refresh the saved addresses list
                        context.read<SavedAddressProvider>().fetchUserAddresses();

                        // Navigate back
                        Navigator.pop(context);
                      }
                    },
                  ),

                  hBox(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _type(
      String title,
      String icon,
      bool selected,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.containerBorder,
            ),
            color: selected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                path: icon,
                color: selected ? AppColors.primary : AppColors.grey,
                height: 18,
                width: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppFontStyle.text_14_500(
                  selected ? AppColors.primary : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}