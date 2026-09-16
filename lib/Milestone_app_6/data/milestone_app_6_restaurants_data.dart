class MilestoneApp6Restaurant {
  final String name;
  final String image;
  final String rating;
  final String time;
  final String cuisine;
  final String price;

  const MilestoneApp6Restaurant({
    required this.name,
    required this.image,
    required this.rating,
    required this.time,
    required this.cuisine,
    required this.price,
  });
}

const restaurants = <MilestoneApp6Restaurant>[
  MilestoneApp6Restaurant(
    name: 'The Italian Bistro',
    image:
    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=700',
    rating: '4.5',
    time: '20-30 min',
    cuisine: 'Italian • Pizza • Pasta',
    price: '₹₹',
  ),

  MilestoneApp6Restaurant(
    name: 'Sushi World',
    image:
    'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=700',
    rating: '4.7',
    time: '25-35 min',
    cuisine: 'Japanese • Sushi • Asian',
    price: '₹₹₹',
  ),

  MilestoneApp6Restaurant(
    name: 'Burger Hub',
    image:
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=700',
    rating: '4.6',
    time: '15-25 min',
    cuisine: 'Burgers • Fast Food',
    price: '₹₹',
  ),

  MilestoneApp6Restaurant(
    name: 'Green Bowl',
    image:
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=700',
    rating: '4.5',
    time: '20-30 min',
    cuisine: 'Healthy • Salads • Veg',
    price: '₹₹',
  ),

  MilestoneApp6Restaurant(
    name: 'Pasta Corner',
    image:
    'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=700',
    rating: '4.6',
    time: '20-30 min',
    cuisine: 'Italian • Pasta',
    price: '₹₹',
  ),

  MilestoneApp6Restaurant(
    name: 'Fresh Bites',
    image:
    'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=700',
    rating: '4.4',
    time: '15-25 min',
    cuisine: 'Sandwiches • Veg • Cafe',
    price: '₹',
  ),

  MilestoneApp6Restaurant(
    name: 'Morning Cafe',
    image:
    'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=700',
    rating: '4.7',
    time: '15-25 min',
    cuisine: 'Breakfast • Cafe • Veg',
    price: '₹₹',
  ),

  MilestoneApp6Restaurant(
    name: 'Asian Kitchen',
    image:
    'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=700',
    rating: '4.6',
    time: '25-35 min',
    cuisine: 'Asian • Noodles • Rice',
    price: '₹₹',
  ),
];