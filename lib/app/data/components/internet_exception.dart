import '../../core/appExports/app_export.dart';

class InternetExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;

  const InternetExceptionWidget({super.key, required this.onPress});

  @override
  State<InternetExceptionWidget> createState() =>
      _InternetExceptionWidgetState();
}

class _InternetExceptionWidgetState extends State<InternetExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: height * .15,
          ),
          Icon(
            Icons.cloud_off,
            // color: AppColor.primaryColor,
            size: 30.sp,
          ),
          Padding(
            padding: REdgeInsets.only(top: 30),
            child:  Center(
                child: Text(
                  "Oh no!\nYour internet took a coffee break!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily:AppFontFamily.regular ,
                  ),
                )),
          ),
          SizedBox(
            height: height * .06,
          ),
          InkWell(
            onTap: widget.onPress,
            child: Container(
              height: 44,
              width: 160,
              decoration: BoxDecoration(
                  // color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: const Center(
                  child: Text(
                    "Retry",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'RammettoOne',
                        color: Colors.white),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
