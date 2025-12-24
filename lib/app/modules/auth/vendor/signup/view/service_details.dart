

import 'package:image_picker/image_picker.dart';

import '../../../../../core/appExports/app_export.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';
import '../../../../../shared/widgets/custom_dropdown.dart';
import '../../../../../shared/widgets/custom_text_form_field.dart';
import '../provider/service details provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceDetailsProvider(),
      child: const _ServiceDetailsContent(),
    );
  }
}

class _ServiceDetailsContent extends StatelessWidget {
  const _ServiceDetailsContent({super.key});

  Future<void> pickImage(BuildContext context) async {
    final provider = Provider.of<ServiceDetailsProvider>(context, listen: false);

    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      provider.setImage(File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServiceDetailsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: "Service Details"),
              SizedBox(height: 8),
              Center(
                child: Text(
                  "Step 2 of 6",
                  style: AppFontStyle.text_14_400(AppColors.grey),
                ),
              ),

              SizedBox(height: 20),

              // ===================== IMAGE UPLOAD =====================
              Center(
                child: GestureDetector(
                  onTap: () => pickImage(context),
                  child: Column(
                    children: [
                      provider.pickedImage == null
                          ? Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: AppColors.fieldBgColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Icon(Icons.upload, color: AppColors.primary),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          provider.pickedImage!,
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        provider.pickedImage == null
                            ? "Upload Service Image"
                            : "Change Image",
                        style: AppFontStyle.text_14_500(AppColors.primary),
                      ),

                      Text(
                        "PNG, JPG up to 5MB",
                        style: AppFontStyle.text_12_400(AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // ===================== SERVICE NAME =====================
              CustomTextFormField(
                label: "Service Name",
                hintText: "e.g. Deep House Cleaning",
                onChanged: provider.setName,
                borderRadius: 60,
              ),

              SizedBox(height: 20),

              // ===================== CATEGORY =====================
              CustomDropDown(
                label: "Category",
                items: ["Tailor Services", "Cleaning", "Food", "Engineering"],
                selectedValue: provider.category,
                hintText: "Select a category",
                onChanged: provider.setCategory,
                validator: (_) => null,
                borderRadius: 60,
              ),

              SizedBox(height: 20),

              // ===================== SUB CATEGORY =====================
              CustomDropDown(
                label: "Sub Category",
                items: ["Clothing", "Home Cleaning", "Food Delivery"],
                selectedValue: provider.subCategory,
                hintText: "Select a sub category",
                onChanged: provider.setSubCategory,
                validator: (_) => null,
                borderRadius: 60,
              ),

              SizedBox(height: 20),

              // ===================== DESCRIPTION =====================
              CustomTextFormField(
                label: "Description",
                hintText: "Describe your service in detail...",
                maxLines: 5,
                onChanged: provider.setDescription,
                borderRadius: 20,
              ),

              SizedBox(height: 20),

              // ===================== PRICE =====================
              CustomTextFormField(
                label: "Service Price",
                hintText: "\$ 0.00",
                textInputType: TextInputType.number,
                prefix: Padding(
                  padding: EdgeInsets.only(left: 14, right: 8),
                  child: Text("\$", style: AppFontStyle.text_16_600(AppColors.primary)),
                ),
                onChanged: provider.setPrice,
                borderRadius: 60,
              ),

              SizedBox(height: 20),

              // ===================== ESTIMATED DURATION =====================
              Text("Estimated Duration",
                  style: AppFontStyle.text_14_500(AppColors.darkText)),

              SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: CustomDropDown(
                      items: ["1", "2", "3", "4"],
                      selectedValue: provider.durationValue,
                      hintText: "0",
                      onChanged: provider.setDurationValue,
                      validator: (_) => null,
                      borderRadius: 60,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomDropDown(
                      items: ["Minutes", "Hours"],
                      selectedValue: provider.durationUnit,
                      hintText: "Minutes",
                      onChanged: provider.setDurationUnit,
                      validator: (_) => null,
                      borderRadius: 60,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // ===================== CONTINUE BUTTON =====================
              CustomButton(
                text: "Continue",
                borderRadius: BorderRadius.circular(60),
                height: 54,
                onPressed: () {},
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
