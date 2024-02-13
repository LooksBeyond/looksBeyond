class Clients {
  const Clients({
    required this.image,
    required this.name,
  });

  final String image;
  final String name;

  static List<Clients> getClients() {
    return const [
      Clients(image: 'assets/images/salon1.jpg', name: 'Glamour Beauty'),
      Clients(image: 'assets/images/salon2.jpg', name: 'Tranquility Spa'),
      Clients(image: 'assets/images/salon3.jpg', name: 'Revive Wellness'),
      Clients(image: 'assets/images/salon4.jpg', name: 'Nail Nook'),
      Clients(image: 'assets/images/salon5.jpg', name: 'Blissful Retreat'),
      Clients(image: 'assets/images/salon6.jpg', name: 'Serenity Salon'),
      Clients(image: 'assets/images/salon7.jpg', name: 'Wellness Haven'),
      Clients(image: 'assets/images/salon8.jpg', name: 'Relax & Renew'),
      Clients(image: 'assets/images/salon9.jpg', name: 'Zen Zone'),
      Clients(image: 'assets/images/salon10.jpg', name: 'Aura Aesthetics'),
      Clients(image: 'assets/images/salon11.jpg', name: 'Glowing Skin Spa'),
      Clients(image: 'assets/images/salon12.jpg', name: 'Tranquil Retreat'),
    ];
  }
}
