const double laptopLargeSize = 1440;
const double laptopSize = 1150;
const double tabletSize = 800;
const double mobileSize = 576;

const double laptopContainer = 50;
const double tabletContainer = 50;
const double mobileContainer = 25;

double breakPoint(double size, double mobile, double tablet, double laptop,
    double laptopLarge) {
  if (size <= mobileSize) {
    return mobile;
  } else if (size <= tabletSize) {
    return tablet;
  } else if (size <= laptopSize) {
    return laptop;
  } else {
    return laptopLarge;
  }
}

dynamic breakPointDynamic(dynamic size, dynamic mobile, dynamic tablet,
    dynamic laptop, dynamic laptopLarge) {
  if (size <= mobileSize) {
    return mobile;
  } else if (size <= tabletSize) {
    return tablet;
  } else if (size <= laptopSize) {
    return laptop;
  } else {
    return laptopLarge;
  }
}

dynamic deviceType(dynamic size) {
  if (size <= mobileSize) {
    return 1;
  } else if (size <= tabletSize) {
    return 2;
  } else if (size <= laptopSize) {
    return 3;
  } else {
    return 4;
  }
}
