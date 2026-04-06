enum PassType {
  day(
    title: 'Day Pass',
    subtitle: 'Unlimited rentals for one day',
    priceLabel: '\$3.90',
    validityDays: 1,
  ),
  monthly(
    title: 'Monthly Pass',
    subtitle: 'Best for daily commuting',
    priceLabel: '\$24.90',
    validityDays: 30,
  ),
  annual(
    title: 'Annual Pass',
    subtitle: 'Long-term access with lower cost',
    priceLabel: '\$169.00',
    validityDays: 365,
  );

  const PassType({
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.validityDays,
  });

  final String title;
  final String subtitle;
  final String priceLabel;
  final int validityDays;
}
