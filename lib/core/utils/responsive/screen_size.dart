import 'package:flutter/material.dart';

enum DeviceScreenType {
  extraSmall,
  small,
  medium,
  large,
  extraLarge,
}

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static Orientation? orientation;
  static late double pixelRatio;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    pixelRatio = _mediaQueryData.devicePixelRatio;
  }

  static DeviceScreenType getDeviceScreenType() {
    if (screenWidth < 360) {
      return DeviceScreenType.extraSmall;
    } else if (screenWidth >= 360 && screenWidth < 480) {
      return DeviceScreenType.small;
    } else if (screenWidth >= 480 && screenWidth < 600) {
      return DeviceScreenType.medium;
    } else if (screenWidth >= 600 && screenWidth < 840) {
      return DeviceScreenType.large;
    } else {
      return DeviceScreenType.extraLarge;
    }
  }
}


double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}

/// Returns height for a percentage of the screen (0–100%)
double getHeightForPercentage(double percentage) {
  if (percentage > 0 && percentage <= 100) {
    return SizeConfig.screenHeight * (percentage / 100);
  } else {
    return SizeConfig.screenHeight;
  }
}

/// Returns width for a percentage of the screen (0–100%)
double getWidthForPercentage(double percentage) {
  if (percentage > 0 && percentage <= 100) {
    return SizeConfig.screenWidth * (percentage / 100);
  } else {
    return SizeConfig.screenWidth;
  }
}

/// Returns the device pixel ratio
double getPixelRatio() {
  return SizeConfig.pixelRatio;
}

/// Returns responsive font size based on screen type
/*double getResponsiveFontSize(double baseFontSize) {
  final type = SizeConfig.getDeviceScreenType();

  switch (type) {
    case DeviceScreenType.extraSmall:
      return baseFontSize * 0.75;
    case DeviceScreenType.small:
      return baseFontSize * 0.85;
    case DeviceScreenType.medium:
      return baseFontSize;
    case DeviceScreenType.large:
      return baseFontSize * 1.1;
    case DeviceScreenType.extraLarge:
      return baseFontSize * 1.2;
  }*/

double getResponsiveFontSize(double baseFontSize) {
  final width = SizeConfig.screenWidth;
  final height = SizeConfig.screenHeight;
  final isPortrait = SizeConfig.orientation == Orientation.portrait;

  if (width < 360 || height < 640) {
    return baseFontSize * 0.75;
  } else if (width >= 360 && width < 480) {
    return baseFontSize * 0.85;
  } else if (width >= 480 && width < 600) {
    return baseFontSize;
  } else if (width >= 600 && width < 840) {
    return baseFontSize * 1.1;
  } else {
    return baseFontSize * 1.2;
  }
}
