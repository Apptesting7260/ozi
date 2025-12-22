import '../../core/appExports/app_export.dart';

class AppFontStyle {
  static TextStyle _textStyle(
    Color color,
    double size,
    FontWeight fontWeight, {
    fontFamily,
    height,
    overflow,
  }) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
      height: height ?? 1.4.h,
      overflow: overflow ?? TextOverflow.ellipsis,
      fontFamily: fontFamily ?? AppFontFamily.regular,
    );
  }

  static text_30_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      30.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_30_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      30.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  } static text_28_6002(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      28.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }
static text_34_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      34.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }static text_32_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      32.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_28_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      24.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_28_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      24.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_22_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      22.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_18_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      18.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_18_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      18.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_14_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      14.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_24_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      25.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }
static text_24_700(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      24.0,
      FontWeight.w700,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_46_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      46.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_18_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      16.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_18_300(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      18.0,
      FontWeight.w300,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_15_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      15.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_15_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      15.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_15_700(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      15.0,
      FontWeight.w700,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_16_300(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      16.0,
      FontWeight.w300,
      height: height,
      fontFamily: fontFamily,
    );
  }


  static text_14_300(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      14.0,
      FontWeight.w300,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_10_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      10.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }  static text_8_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      8.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_10_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      10.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_11_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      11.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_20_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      20.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_20_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      20.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_20_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      20.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }  static text_24_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      24.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
}static text_26_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      26.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }
  static text_22_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      22.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_20_700(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      20.0,
      FontWeight.w700,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_16_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      16.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_16_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      16.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_11_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      11.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_16_700(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      16.0,
      FontWeight.w700,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_14_700(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      14.0,
      FontWeight.w700,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_14_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      14.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_14_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      14.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }static text_16_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      16.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_12_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      12.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }
  static text_12_300(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      12.0,
      FontWeight.w200,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_12_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      12.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }static text_13_600(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      13.0,
      FontWeight.w600,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_13_400(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      13.0,
      FontWeight.w400,
      height: height,
      fontFamily: fontFamily,
    );
  }

  static text_12_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      12.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }static text_11_500(Color color, {fontFamily, height}) {
    return _textStyle(
      color,
      11.0,
      FontWeight.w500,
      height: height,
      fontFamily: fontFamily,
    );
  }
}
