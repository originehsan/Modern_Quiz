import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  bool get isPortrait => screenSize.width < screenSize.height;
  bool get isLandscape => screenSize.width > screenSize.height;
  bool get isSmallDevice => screenWidth < 600;
  bool get isMediumDevice => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeDevice => screenWidth >= 1200;
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool isValidEmail() {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool isValidPassword() {
    return length >= 8;
  }

  String truncate({int length = 20, String omission = '...'}) {
    if (this.length <= length) return this;
    return substring(0, length) + omission;
  }
}

extension IntExtension on int {
  String toTimeString() {
    final minutes = (this / 60).floor();
    final seconds = this % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String formatNumber() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

extension DoubleExtension on double {
  String toPercentage({int decimals = 1}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }
}

extension DateTimeExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String toReadableString() {
    if (isToday()) {
      return 'Today at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }
    if (isYesterday()) {
      return 'Yesterday at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
