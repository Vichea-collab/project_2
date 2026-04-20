import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.minimumSize,
    this.padding,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? minimumSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final Widget label = Text(text);
    
    final style = FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      minimumSize: minimumSize,
      padding: padding,
    );

    if (isLoading) {
      return FilledButton(
        onPressed: null,
        style: style,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }

    if (icon != null) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: label,
        style: style,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      style: style,
      child: label,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.foregroundColor,
    this.borderColor,
    this.minimumSize,
    this.padding,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? foregroundColor;
  final Color? borderColor;
  final Size? minimumSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final Widget label = Text(text);

    final style = OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      side: borderColor != null ? BorderSide(color: borderColor!) : null,
      minimumSize: minimumSize,
      padding: padding,
    );

    if (isLoading) {
      return OutlinedButton(
        onPressed: null,
        style: style,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2, 
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: label,
        style: style,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: label,
    );
  }
}
