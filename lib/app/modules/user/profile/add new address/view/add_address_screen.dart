import 'package:ozi/app/modules/user/profile/save%20address/provider/saved_address_provider.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/add_address_provider.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddAddressProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const CustomAppBar(title: "Add New Address"),

          Expanded(
            child: SingleChildScrollView(
              padding: REdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  hBox(10),

                  // Street Address
                  CustomTextFormField(
                    controller: provider.streetAddressController,
                    label: "Street Address",
                    hintText: "123 Main Street",
                    borderRadius: 14,
                  ),
                  hBox(15),

                  // Apartment
                  CustomTextFormField(
                    controller: provider.apartmentController,
                    label: "Apartment, Suite, etc.",
                    hintText: "Apt 4B",
                    borderRadius: 14,
                  ),
                  hBox(15),

                  // City and ZIP Code
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: provider.cityController,
                          label: "City",
                          hintText: "New York",
                          borderRadius: 14,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          controller: provider.zipCodeController,
                          label: "ZIP Code",
                          hintText: "10001",
                          borderRadius: 14,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  hBox(25),

                  // Address type
                  Row(
                    children: [
                      _type(context, "Home", ImageConstants.home2, 0, provider.selectedType == 0),
                      wBox(12),
                      _type(context, "Work", ImageConstants.work, 1, provider.selectedType == 1),
                      wBox(12),
                      _type(context, "Other", ImageConstants.location, 2, provider.selectedType == 2),
                    ],
                  ),
                  hBox(22),

                  CustomButton(
                    text: "Save Address",
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                      bool success = await provider.addNewAddress(context);

                      if (success && context.mounted) {
                        final savedAddressProvider =
                        context.read<SavedAddressProvider>();
                        await savedAddressProvider.fetchUserAddresses();
                        Navigator.pop(context, true);
                      }
                    },
                    child: provider.isLoading
                        ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : null,
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
      BuildContext context,
      String title,
      String imagePath,
      int index,
      bool isSelected,
      ) {
    final provider = context.read<AddAddressProvider>();

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.updateType(index),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.containerBorder,
              width: isSelected ? 1.5 : 1,
            ),
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                path: imagePath,
                color: isSelected ? AppColors.primary : AppColors.grey,
                height: 18,
                width: 18,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: AppFontStyle.text_14_500(
                  isSelected ? AppColors.primary : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}