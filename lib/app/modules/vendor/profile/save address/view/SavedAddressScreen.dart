
import '../../../../../core/appExports/app_export.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../shared/widgets/custom_app_bar.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  int selectedIndex = 0; // Default selected is Home (index 0)

  final List<Map<String, dynamic>> addresses = [
    {
      'title': 'Home',
      'tag': 'Default',
      'icon': ImageConstants.home,
      'address': '123 Main Street, San Francisco, CA 94102',
    },
    {
      'title': 'Work',
      'tag': null,
      'icon': ImageConstants.work,
      'address': '123 Main Street, San Francisco, CA 94102',
    },
    {
      'title': 'Other',
      'tag': null,
      'icon': ImageConstants.location,
      'address': '123 Market Street, Apt 4B San Francisco, CA 94102',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          CustomAppBar(title: "Saved Addresses"),

          Expanded(
            child: ListView(
              padding: REdgeInsets.all(16),
              children: [
                ...List.generate(
                  addresses.length,
                      (index) => _addressTile(
                    selected: selectedIndex == index,
                    title: addresses[index]['title'],
                    tag: addresses[index]['tag'],
                    icon: addresses[index]['icon'],
                    address: addresses[index]['address'],
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    onEdit: () {
                      print('Edit ${addresses[index]['title']}');
                    },
                    onDelete: () {
                      // Handle delete action
                      _showDeleteDialog(context, index);
                    },
                  ),
                ),

               hBox(8),

                CustomButton(
                  text: "+ Add New Address",
                  isOutlined: true,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.addAddressScreen),
                  height: 56,
                  borderRadius: BorderRadius.circular(60),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                addresses.removeAt(index);
                // Adjust selected index if needed
                if (selectedIndex >= addresses.length && addresses.isNotEmpty) {
                  selectedIndex = addresses.length - 1;
                } else if (addresses.isEmpty) {
                  selectedIndex = -1;
                }
              });
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  Widget _addressTile({
    required bool selected,
    required String title,
    required String address,
    required String icon,
    String? tag,
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(.08) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.containerBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON CONTAINER
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(.20),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.all(12),
              child: CustomImage(
                path: icon,
                color: selected ? AppColors.white : AppColors.primary,
              ),
            ),

            SizedBox(width: 14),

            /// TITLE + ADDRESS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppFontStyle.text_16_600(AppColors.black),
                      ),

                      if (tag != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            tag,
                            style: AppFontStyle.text_12_500(AppColors.primary),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 6),

                  Text(
                    address,
                    style: AppFontStyle.text_13_400(AppColors.grey),
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            /// ICONS
            Row(
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: CustomImage(path: ImageConstants.edit)
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: onDelete,
                  child: CustomImage(path: ImageConstants.bin)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}