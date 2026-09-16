class MilestoneApp6Category {
  final String name;
  final String image;

  const MilestoneApp6Category(
      this.name,
      this.image,
      );
}

class MilestoneApp6Food {
  final String id;
  final String name;
  final String category;
  final String restaurant;
  final String image;
  final double price;
  final double rating;
  final String description;

  const MilestoneApp6Food({
    required this.id,
    required this.name,
    required this.category,
    required this.restaurant,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
  });
}

// ============================================================================
// CATEGORIES
// ============================================================================

const milestoneApp6Categories = <MilestoneApp6Category>[
  MilestoneApp6Category(
    'Pizza',
    'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=400',
  ),

  MilestoneApp6Category(
    'Burger',
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
  ),

  MilestoneApp6Category(
    'Sushi',
    'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400',
  ),

  MilestoneApp6Category(
    'Dessert',
    'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400',
  ),

  MilestoneApp6Category(
    'Pasta',
    'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
  ),

  MilestoneApp6Category(
    'Salad',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
  ),

  MilestoneApp6Category(
    'Drinks',
    'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400',
  ),

  MilestoneApp6Category(
    'Tacos',
    'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400',
  ),

  MilestoneApp6Category(
    'Asian',
    'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
  ),

  MilestoneApp6Category(
    'Breakfast',
    'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400',
  ),

  MilestoneApp6Category(
    'Sandwich',
    'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=400',
  ),
];


const milestoneApp6Foods = <MilestoneApp6Food>[

  MilestoneApp6Food(
    id: 'margherita',
    name: 'Margherita Pizza',
    category: 'Pizza',
    restaurant: 'The Italian Bistro',
    image:
    'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=900',
    price: 8.99,
    rating: 4.5,
    description:
    'Classic delight with fresh tomatoes, mozzarella, basil and olive oil.',
  ),

  MilestoneApp6Food(
    id: 'pepperoni',
    name: 'Pepperoni Pizza',
    category: 'Pizza',
    restaurant: 'Pizza House',
    image:
    'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=900',
    price: 9.99,
    rating: 4.7,
    description:
    'Crispy pepperoni, melted mozzarella and rich tomato sauce.',
  ),

  MilestoneApp6Food(
    id: 'veggie',
    name: 'Veggie Pizza',
    category: 'Pizza',
    restaurant: 'Green Oven',
    image:
    'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=900',
    price: 8.49,
    rating: 4.4,
    description:
    'Roasted vegetables, mozzarella and herbs on a crisp crust.',
  ),

  MilestoneApp6Food(
    id: 'bbq',
    name: 'BBQ Chicken Pizza',
    category: 'Pizza',
    restaurant: 'Fire Oven',
    image:
    'https://images.unsplash.com/photo-1566843972142-a7fcb70de55a?w=900',
    price: 10.99,
    rating: 4.6,
    description:
    'Smoky BBQ chicken, onions and mozzarella with a sweet glaze.',
  ),

  // ==========================================================================
  // BURGER
  // ==========================================================================

  MilestoneApp6Food(
    id: 'classic-burger',
    name: 'Classic Burger',
    category: 'Burger',
    restaurant: 'Burger Hub',
    image:
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
    price: 7.99,
    rating: 4.6,
    description:
    'Juicy beef patty with lettuce, tomato, cheese and house sauce.',
  ),

  MilestoneApp6Food(
    id: 'cheese-burger',
    name: 'Double Cheese Burger',
    category: 'Burger',
    restaurant: 'Burger Hub',
    image:
    'https://images.unsplash.com/photo-1550547660-d9450f859349?w=900',
    price: 9.49,
    rating: 4.8,
    description:
    'Double beef patties with melted cheese, lettuce and special sauce.',
  ),

  MilestoneApp6Food(
    id: 'chicken-burger',
    name: 'Crispy Chicken Burger',
    category: 'Burger',
    restaurant: 'Chicken House',
    image:
    'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=900',
    price: 8.49,
    rating: 4.5,
    description:
    'Crunchy chicken fillet with fresh lettuce and creamy sauce.',
  ),

  // ==========================================================================
  // SUSHI
  // ==========================================================================

  MilestoneApp6Food(
    id: 'salmon-sushi',
    name: 'Salmon Sushi',
    category: 'Sushi',
    restaurant: 'Sushi World',
    image:
    'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=900',
    price: 12.99,
    rating: 4.8,
    description:
    'Fresh salmon sushi prepared with seasoned rice and delicate toppings.',
  ),

  MilestoneApp6Food(
    id: 'california-roll',
    name: 'California Roll',
    category: 'Sushi',
    restaurant: 'Tokyo Kitchen',
    image:
    'https://images.unsplash.com/photo-1553621042-f6e147245754?w=900',
    price: 10.49,
    rating: 4.7,
    description:
    'Classic California roll with crab, avocado, cucumber and sushi rice.',
  ),

  MilestoneApp6Food(
    id: 'tuna-roll',
    name: 'Spicy Tuna Roll',
    category: 'Sushi',
    restaurant: 'Tokyo Kitchen',
    image:
    'https://images.unsplash.com/photo-1617196034183-421b4917c92d?w=900',
    price: 11.49,
    rating: 4.6,
    description:
    'Fresh tuna mixed with spicy sauce and rolled with seasoned rice.',
  ),

  MilestoneApp6Food(
    id: 'dragon-roll',
    name: 'Dragon Roll',
    category: 'Sushi',
    restaurant: 'Sushi World',
    image:
    'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=900',
    price: 13.99,
    rating: 4.9,
    description:
    'Premium sushi roll with avocado, shrimp and a flavorful house sauce.',
  ),

  // ==========================================================================
  // DESSERT
  // ==========================================================================

  MilestoneApp6Food(
    id: 'chocolate-cake',
    name: 'Chocolate Cake',
    category: 'Dessert',
    restaurant: 'Sweet Corner',
    image:
    'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=900',
    price: 6.49,
    rating: 4.8,
    description:
    'Rich chocolate cake layered with smooth chocolate cream.',
  ),

  MilestoneApp6Food(
    id: 'ice-cream',
    name: 'Vanilla Ice Cream',
    category: 'Dessert',
    restaurant: 'Ice Cream House',
    image:
    'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=900',
    price: 4.99,
    rating: 4.7,
    description:
    'Creamy vanilla ice cream served with a sweet topping.',
  ),

  MilestoneApp6Food(
    id: 'donut',
    name: 'Glazed Donut',
    category: 'Dessert',
    restaurant: 'Donut Factory',
    image:
    'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=900',
    price: 3.99,
    rating: 4.6,
    description:
    'Soft golden donut covered with a smooth sweet glaze.',
  ),

  MilestoneApp6Food(
    id: 'cheesecake',
    name: 'Classic Cheesecake',
    category: 'Dessert',
    restaurant: 'Sweet Corner',
    image:
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=900',
    price: 6.99,
    rating: 4.9,
    description:
    'Creamy cheesecake with a buttery biscuit base and berry topping.',
  ),

  // ==========================================================================
  // PASTA
  // ==========================================================================

  MilestoneApp6Food(
    id: 'pasta',
    name: 'Creamy Pasta',
    category: 'Pasta',
    restaurant: 'Pasta Corner',
    image:
    'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900',
    price: 8.49,
    rating: 4.5,
    description:
    'Creamy parmesan sauce tossed with pasta and fresh herbs.',
  ),

  MilestoneApp6Food(
    id: 'carbonara',
    name: 'Spaghetti Carbonara',
    category: 'Pasta',
    restaurant: 'Italian Kitchen',
    image:
    'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=900',
    price: 9.99,
    rating: 4.7,
    description:
    'Classic spaghetti with creamy sauce, parmesan and herbs.',
  ),

  MilestoneApp6Food(
    id: 'arrabbiata',
    name: 'Penne Arrabbiata',
    category: 'Pasta',
    restaurant: 'Pasta Corner',
    image:
    'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=900',
    price: 8.99,
    rating: 4.4,
    description:
    'Penne pasta tossed in a rich tomato and chili sauce.',
  ),

  // ==========================================================================
  // SALAD
  // ==========================================================================

  MilestoneApp6Food(
    id: 'salad',
    name: 'Garden Salad',
    category: 'Salad',
    restaurant: 'Fresh Bowl',
    image:
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 6.99,
    rating: 4.4,
    description:
    'Crisp greens, vegetables and a light house dressing.',
  ),

  MilestoneApp6Food(
    id: 'caesar-salad',
    name: 'Caesar Salad',
    category: 'Salad',
    restaurant: 'Fresh Bowl',
    image:
    'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=900',
    price: 7.99,
    rating: 4.7,
    description:
    'Fresh romaine lettuce, parmesan, croutons and Caesar dressing.',
  ),

  MilestoneApp6Food(
    id: 'greek-salad',
    name: 'Greek Salad',
    category: 'Salad',
    restaurant: 'Mediterranean Cafe',
    image:
    'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=900',
    price: 7.49,
    rating: 4.6,
    description:
    'Fresh cucumber, tomato, olives, feta cheese and herbs.',
  ),

  MilestoneApp6Food(
    id: 'lemonade',
    name: 'Fresh Lemonade',
    category: 'Drinks',
    restaurant: 'Fresh Drinks',
    image:
    'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=800&auto=format&fit=crop',
    price: 3.49,
    rating: 4.5,
    description:
    'Refreshing lemonade made with fresh lemons and a touch of sweetness.',
  ),

  MilestoneApp6Food(
    id: 'iced-coffee',
    name: 'Iced Coffee',
    category: 'Drinks',
    restaurant: 'Coffee House',
    image:
    'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=900',
    price: 4.49,
    rating: 4.7,
    description:
    'Cold brewed coffee served over ice with creamy milk.',
  ),

  MilestoneApp6Food(
    id: 'strawberry-shake',
    name: 'Strawberry Shake',
    category: 'Drinks',
    restaurant: 'Shake Station',
    image:
    'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=900',
    price: 5.49,
    rating: 4.8,
    description:
    'Creamy strawberry milkshake topped with fresh berries.',
  ),

  MilestoneApp6Food(
    id: 'orange-juice',
    name: 'Fresh Orange Juice',
    category: 'Drinks',
    restaurant: 'Fresh Drinks',
    image:
    'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=900',
    price: 3.99,
    rating: 4.6,
    description:
    'Freshly squeezed orange juice served chilled.',
  ),





  MilestoneApp6Food(
    id: 'fried-rice',
    name: 'Vegetable Fried Rice',
    category: 'Asian',
    restaurant: 'Asian Kitchen',
    image:
    'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=900',
    price: 7.99,
    rating: 4.5,
    description:
    'Fragrant fried rice tossed with fresh vegetables and Asian spices.',
  ),

  MilestoneApp6Food(
    id: 'noodles',
    name: 'Asian Noodles',
    category: 'Asian',
    restaurant: 'Asian Kitchen',
    image:
    'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=900',
    price: 8.49,
    rating: 4.6,
    description:
    'Stir-fried noodles with vegetables and a savory house sauce.',
  ),

  // ==========================================================================
  // BREAKFAST
  // ==========================================================================

  MilestoneApp6Food(
    id: 'pancakes',
    name: 'Pancake Stack',
    category: 'Breakfast',
    restaurant: 'Morning Cafe',
    image:
    'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=900',
    price: 6.99,
    rating: 4.8,
    description:
    'Fluffy pancakes served with berries, syrup and butter.',
  ),

  MilestoneApp6Food(
    id: 'avocado-toast',
    name: 'Avocado Toast',
    category: 'Breakfast',
    restaurant: 'Morning Cafe',
    image:
    'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=900',
    price: 7.49,
    rating: 4.6,
    description:
    'Toasted bread topped with creamy avocado and fresh herbs.',
  ),

  MilestoneApp6Food(
    id: 'breakfast-bowl',
    name: 'Healthy Breakfast Bowl',
    category: 'Breakfast',
    restaurant: 'Fresh Bowl',
    image:
    'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=900',
    price: 8.49,
    rating: 4.7,
    description:
    'A healthy bowl with fruit, yogurt, granola and fresh toppings.',
  ),


  MilestoneApp6Food(
    id: 'paneer-sandwich',
    name: 'Paneer Sandwich',
    category: 'Sandwich',
    restaurant: 'Veggie Corner',
    image:
    'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=900',
    price: 7.49,
    rating: 4.7,
    description:
    'Grilled sandwich filled with soft paneer, fresh vegetables, cheese and creamy sauce.',
  ),

  MilestoneApp6Food(
    id: 'grilled-cheese',
    name: 'Grilled Cheese Sandwich',
    category: 'Sandwich',
    restaurant: 'Toast House',
    image:
    'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=900',
    price: 5.99,
    rating: 4.6,
    description:
    'Crispy toasted bread filled with melted cheese and a delicious buttery flavor.',
  ),

  MilestoneApp6Food(
    id: 'veg-club-sandwich',
    name: 'Veg Club Sandwich',
    category: 'Sandwich',
    restaurant: 'Fresh Bites',
    image:
    'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 6.99,
    rating: 4.5,
    description:
    'Triple-layer sandwich with lettuce, tomato, cucumber, cheese and fresh vegetables.',
  ),

  MilestoneApp6Food(
    id: 'cheese-corn-sandwich',
    name: 'Cheese Corn Sandwich',
    category: 'Sandwich',
    restaurant: 'Veggie Corner',
    image:
    'https://images.unsplash.com/photo-1481070414801-51fd732d7184?w=900',
    price: 6.49,
    rating: 4.5,
    description:
    'Toasted sandwich packed with sweet corn, melted cheese and creamy seasoning.',
  ),

  MilestoneApp6Food(
    id: 'avocado-sandwich',
    name: 'Avocado Sandwich',
    category: 'Sandwich',
    restaurant: 'Green Cafe',
    image:
    'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=900',
    price: 7.49,
    rating: 4.6,
    description:
    'Fresh avocado with lettuce, tomato and herbs served between toasted bread.',
  ),

  MilestoneApp6Food(
    id: 'vegetable-grilled-sandwich',
    name: 'Vegetable Grilled Sandwich',
    category: 'Sandwich',
    restaurant: 'Fresh Bites',
    image:
    'https://images.unsplash.com/photo-1553909489-cd47e0907980?w=900',
    price: 6.49,
    rating: 4.4,
    description:
    'Crispy grilled bread filled with fresh vegetables, cheese and flavorful herbs.',
  ),
  MilestoneApp6Food(
    id: 'veg-tacos',
    name: 'Classic Veg Tacos',
    category: 'Tacos',
    restaurant: 'Mexican Fiesta',
    image:
    'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 7.49,
    rating: 4.6,
    description:
    'Crispy tacos filled with fresh vegetables, black beans, corn, lettuce and salsa.',
  ),

  MilestoneApp6Food(
    id: 'paneer-tacos',
    name: 'Paneer Tacos',
    category: 'Tacos',
    restaurant: 'Mexican Fiesta',
    image:
    'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=900',
    price: 8.49,
    rating: 4.7,
    description:
    'Soft tortillas filled with spiced paneer, fresh vegetables, cheese and creamy sauce.',
  ),

  MilestoneApp6Food(
    id: 'avocado-tacos',
    name: 'Avocado Veg Tacos',
    category: 'Tacos',
    restaurant: 'Green Mexican',
    image:
    'https://images.unsplash.com/photo-1615870216519-2f9fa575fa5c?w=900',
    price: 7.99,
    rating: 4.6,
    description:
    'Fresh avocado, crunchy vegetables, black beans and cilantro served in soft tortillas.',
  ),

  MilestoneApp6Food(
    id: 'bean-tacos',
    name: 'Mexican Bean Tacos',
    category: 'Tacos',
    restaurant: 'Taco House',
    image:
    'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=900',
    price: 6.99,
    rating: 4.5,
    description:
    'Flavorful tacos filled with seasoned beans, lettuce, tomato, corn and fresh salsa.',
  ),

  MilestoneApp6Food(
    id: 'corn-tacos',
    name: 'Cheesy Corn Tacos',
    category: 'Tacos',
    restaurant: 'Taco Corner',
    image:
    'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?w=900',
    price: 6.49,
    rating: 4.4,
    description:
    'Sweet corn, melted cheese, peppers and fresh herbs wrapped in warm tortillas.',
  ),

  MilestoneApp6Food(
    id: 'mushroom-tacos',
    name: 'Mushroom Tacos',
    category: 'Tacos',
    restaurant: 'Veggie Mexican',
    image:
    'https://images.unsplash.com/photo-1624300629298-e9de39c13be5?w=900',
    price: 7.99,
    rating: 4.7,
    description:
    'Seasoned mushrooms with lettuce, salsa, avocado and fresh cilantro in crispy tortillas.',
  ),
];