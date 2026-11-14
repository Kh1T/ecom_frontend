import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              tooltip: 'Back',
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_rounded),
            )
          else
            const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class AppSurface extends StatelessWidget {
  const AppSurface({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadii.medium,
    this.color = AppColors.surface,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle(this.title, {this.caption, super.key});

  final String title;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (caption != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(caption!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadii.large),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, size: 38, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: SizedBox(width: double.infinity, child: action),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
